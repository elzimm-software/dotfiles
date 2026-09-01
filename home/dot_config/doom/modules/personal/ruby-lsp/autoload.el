;;; personal/ruby-lsp/autoload.el -*- lexical-binding: t; -*-

;; `+ruby/ensure-lsp-gems' -- the one interactive entry point of this module.
;; Its defvars and helper (`+ruby-lsp-gems', `+ruby-lsp--missing-gems') live in
;; config.el, which has always loaded by the time this command can be invoked.

;;;###autoload
(defun +ruby/ensure-lsp-gems (&optional no-confirm)
  "Add any missing `+ruby-lsp-gems' to the current project's Gemfile.
Appends a `group :development' block, then offers to run `bundle
install'. With prefix arg NO-CONFIRM, skip both prompts."
  (interactive "P")
  (let* ((root (or (doom-project-root) (user-error "Not in a project")))
         (gemfile (expand-file-name "Gemfile" root))
         (rel (file-relative-name gemfile root)))
    (unless (file-exists-p gemfile)
      (user-error "No Gemfile in %s (not a Bundler project)"
                  (abbreviate-file-name root)))
    (let ((missing (+ruby-lsp--missing-gems gemfile)))
      (cond
       ((null missing)
        (when (called-interactively-p 'any)
          (message "%s already lists %s" rel (string-join +ruby-lsp-gems ", "))))
       ((or no-confirm
            (y-or-n-p (format "Add %s to %s? " (string-join missing " + ") rel)))
        (with-temp-buffer
          (insert-file-contents gemfile)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert "\ngroup :development do\n")
          (dolist (g missing)
            (insert (format "  gem \"%s\", require: false\n" g)))
          (insert "end\n")
          (write-region (point-min) (point-max) gemfile))
        (message "Added %s to %s" (string-join missing " + ") rel)
        (when (or no-confirm (y-or-n-p "Run `bundle install' now? "))
          (let ((default-directory root))
            (compile "bundle install"))))))))
