;;; personal/ruby-lsp/config.el -*- lexical-binding: t; -*-

;; Prefer the project's bundled ruby-lsp when it's in the Gemfile (so it
;; runs against the same Ruby/gems the project uses, incl. its rubocop);
;; fall back to the global ~/.local/bin ruby-lsp otherwise. Decided
;; per-buffer so moving between projects needs no global toggle. Runs
;; before Doom's `lsp!' on the same local-vars-hook.
(add-hook! '(ruby-mode-local-vars-hook ruby-ts-mode-local-vars-hook)
  (defun +ruby-lsp-use-bundler-maybe-h ()
    (when-let* ((root (doom-project-root))
                (lock (expand-file-name "Gemfile.lock" root)))
      (setq-local lsp-ruby-lsp-use-bundler
                  (and (file-exists-p lock)
                       (with-temp-buffer
                         (insert-file-contents lock)
                         (goto-char (point-min))
                         (re-search-forward "^ +ruby-lsp\\b" nil t))
                       t)))))

;; Bundler's Gemfile templates can't be taught to add these, and they're
;; only ever useful once the project is open in Emacs -- so provision from
;; here instead. `+ruby/ensure-lsp-gems' (autoload.el) appends a
;; `group :development' block for whichever of ruby-lsp/rubocop the Gemfile
;; is missing, and the local-vars-hook below offers to do it once per
;; project per session.
(defvar +ruby-lsp-gems '("ruby-lsp" "rubocop")
  "Gems `+ruby/ensure-lsp-gems' keeps in a project's Gemfile.")

(defvar +ruby-lsp-auto-offer-gems t
  "When non-nil, offer to add `+ruby-lsp-gems' the first time a Ruby file
in a given Bundler project is visited this session.")

(defvar +ruby-lsp--offered-projects (make-hash-table :test 'equal)
  "Project roots already offered the gem-add prompt this session.")

(defun +ruby-lsp--missing-gems (gemfile)
  "Return the members of `+ruby-lsp-gems' not declared in GEMFILE."
  (let ((text (with-temp-buffer (insert-file-contents gemfile) (buffer-string))))
    (seq-remove
     (lambda (g)
       (string-match-p (format "^[ \t]*gem[ \t]+[\"']%s[\"']" (regexp-quote g)) text))
     +ruby-lsp-gems)))

(add-hook! '(ruby-mode-local-vars-hook ruby-ts-mode-local-vars-hook)
  (defun +ruby-lsp-maybe-offer-gems-h ()
    (when +ruby-lsp-auto-offer-gems
      (when-let* ((root (doom-project-root))
                  ((not (gethash root +ruby-lsp--offered-projects)))
                  (gemfile (expand-file-name "Gemfile" root))
                  ((file-exists-p gemfile))
                  (missing (+ruby-lsp--missing-gems gemfile)))
        (puthash root t +ruby-lsp--offered-projects)
        (when (y-or-n-p (format "%s: add %s to Gemfile? "
                                (file-name-nondirectory (directory-file-name root))
                                (string-join missing " + ")))
          (+ruby/ensure-lsp-gems 'no-confirm))))))

(map! :after ruby-mode
      :localleader :map ruby-mode-map
      :desc "Add ruby-lsp/rubocop to Gemfile" "b l" #'+ruby/ensure-lsp-gems)
(map! :after ruby-ts-mode
      :localleader :map ruby-ts-mode-map
      :desc "Add ruby-lsp/rubocop to Gemfile" "b l" #'+ruby/ensure-lsp-gems)
