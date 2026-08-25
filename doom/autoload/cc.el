;;; autoload/cc.el -*- lexical-binding: t; -*-

;; Header/source sync for the header-first workflow: write the full
;; declaration list in the .h, then generate matching stub definitions in
;; the .c as you implement, or generate a missing prototype from a
;; definition you wrote directly in the .c. clangd's own tweaks
;; ("Move function body to out-of-line"/"...to declaration") only cover
;; header-first *inline* definitions being split out, not this direction,
;; so there's no built-in code action for it.

(defun +cc--treesit-function-name (declarator-node)
  "Dig through DECLARATOR-NODE (unwrapping pointer_declarator etc. down
through function_declarator) to find the function's identifier."
  (let ((node declarator-node) (name nil))
    (while (and node (not name))
      (pcase (treesit-node-type node)
        ("identifier" (setq name (treesit-node-text node t)))
        ("function_declarator"
         (setq node (treesit-node-child-by-field-name node "declarator")))
        (_ (setq node (or (treesit-node-child-by-field-name node "declarator")
                           (treesit-node-child node 0))))))
    name))

(defun +cc--treesit-has-function-declarator (node)
  "Non-nil if NODE (a declaration/definition node) declares a function."
  (or (equal (treesit-node-type node) "function_declarator")
      (let ((decl (treesit-node-child-by-field-name node "declarator")))
        (and decl (+cc--treesit-has-function-declarator decl)))))

;;;###autoload
(defun +cc/sync-function-other-file ()
  "Sync the C/C++ function at point with its paired header/source file.

Point in a function *definition* (has a body): ensures a matching bare
prototype exists in the paired file, appending one if missing.

Point in a bare *declaration* (prototype, no body): ensures a stub
definition exists in the paired file, appending one if missing.

Uses clangd's switchSourceHeader to find the pair, and a simple name
search to avoid inserting a duplicate. The target buffer is opened and
left unsaved so you can reposition the insertion before writing it."
  (interactive)
  (unless (derived-mode-p 'c-ts-mode 'c++-ts-mode)
    (user-error "Not in a c-ts-mode/c++-ts-mode buffer"))
  (let* ((node (treesit-node-at (point)))
         (fn-node (treesit-parent-until
                   node (lambda (n) (member (treesit-node-type n)
                                             '("function_definition" "declaration")))
                   t)))
    (unless fn-node (user-error "No function declaration/definition at point"))
    (unless (+cc--treesit-has-function-declarator fn-node)
      (user-error "Not a function declaration/definition"))
    (let* ((body (treesit-node-child-by-field-name fn-node "body"))
           (sig (if body
                    (string-trim (buffer-substring-no-properties
                                  (treesit-node-start fn-node)
                                  (treesit-node-start body)))
                  (string-trim
                   (replace-regexp-in-string
                    ";[ \t\n]*\\'" ""
                    (buffer-substring-no-properties
                     (treesit-node-start fn-node) (treesit-node-end fn-node))))))
           (name (+cc--treesit-function-name
                  (treesit-node-child-by-field-name fn-node "declarator")))
           (_ (unless name (user-error "Couldn't determine function name at point")))
           (other-uri (lsp-request "textDocument/switchSourceHeader"
                                    (lsp--text-document-identifier)))
           (_ (unless other-uri (user-error "clangd found no paired header/source file")))
           (other-file (lsp--uri-to-path other-uri))
           (buf (find-file-noselect other-file)))
      (with-current-buffer buf
        (save-excursion
          (goto-char (point-min))
          (if (re-search-forward (concat "\\_<" (regexp-quote name) "\\_>[ \t\n]*(") nil t)
              (message "%s already has an entry for `%s' -- not touching it" other-file name)
            (goto-char (point-max))
            (if body
                (insert "\n" sig ";\n")
              (insert "\n" sig "\n{\n    \n}\n"))
            (message "Inserted %s for `%s' into %s -- review, then save"
                     (if body "prototype" "stub definition") name other-file))))
      (pop-to-buffer buf))))
