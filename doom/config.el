(setq user-full-name "Elijah Zimmerman"
      user-mail-address "elijah.zimmerman@ves.solutions")

(setq projectile-project-search-path `("~/Programs"))

(setq fancy-splash-image "~/.config/doom/st-ephrael-noback.png")
(add-to-list 'custom-theme-load-path "~/.config/doom/themes/")
(setq doom-theme `horizon-trash-panda)

(setq display-line-numbers-type t)

(setq doom-font (font-spec :family "Hack Nerd Font" :size 13))

(map! "C-=" #'text-scale-increase
      "C--" #'text-scale-decrease
      "C-0" #'(lambda () (interactive) (text-scale-set 0)))

;; Emacs is launched via i3 `exec`, which doesn't source ~/.profile, so
;; ~/go/bin (gopls, gore, etc.) never makes it into Emacs's exec-path.
(let ((go-bin (expand-file-name "~/go/bin")))
  (when (and (file-directory-p go-bin)
             (not (member go-bin exec-path)))
    (add-to-list 'exec-path go-bin)
    (setenv "PATH" (concat go-bin path-separator (getenv "PATH")))))

;; Same story for ~/.local/bin, where `gem install --bindir ~/.local/bin
;; ruby-lsp' put the ruby-lsp binary. No sourced shell rc under the
;; graphical session means lsp-mode can't find it otherwise.
(let ((local-bin (expand-file-name "~/.local/bin")))
  (when (and (file-directory-p local-bin)
             (not (member local-bin exec-path)))
    (add-to-list 'exec-path local-bin)
    (setenv "PATH" (concat local-bin path-separator (getenv "PATH")))))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages
           '((mermaid . t))))
  (setq ob-mermaid-cli-path (executable-find "mmdc")))

(after! company
  ;; In prose buffers, drop the dictionary/buffer-word backends
  ;; (`company-dabbrev', `company-ispell') that pop up completions for whatever
  ;; word you're mid-typing. `company-capf' stays, so org keyword completion
  ;; (#+... ) and snippets still work. text-mode is org/markdown's parent, so
  ;; this covers those too.
  (set-company-backend! 'text-mode '(:separate company-capf company-yasnippet)))

(after! lsp-mode
  (setq lsp-enable-snippet nil
        ;; Always show the code-action menu, even when only one action is
        ;; available, instead of silently auto-applying it.
        lsp-auto-execute-action t))

(after! lsp-ui
  ;; Lightbulb hint in the sideline when a code action is available at
  ;; point, so you know one exists before invoking SPC c a.
  (setq lsp-ui-sideline-show-code-actions t))

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
;; here instead. `+ruby/ensure-lsp-gems' appends a `group :development'
;; block for whichever of ruby-lsp/rubocop the Gemfile is missing, and the
;; local-vars-hook offers to do it once per project per session.
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

;; Match ~/.clang-format (IndentWidth/TabWidth 4, spaces not tabs) so
;; indentation and highlight-indent-guides line up with what clang-format
;; actually writes on save. `cc +tree-sitter` opens files in c-ts-mode /
;; c++-ts-mode, which ignore c-basic-offset and use their own offset var.
(add-hook! '(c-mode-hook c++-mode-hook)
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil))

(after! c-ts-mode
  (setq c-ts-mode-indent-offset 4))

(add-hook! '(c-ts-mode-hook c++-ts-mode-hook)
  (setq tab-width 4
        indent-tabs-mode nil))

;; +cc/sync-function-other-file lives in doom/autoload/cc.el (header/source
;; sync, since clangd's own tweaks only cover header-first inline splitting).
;; NOTE: bind the full "c y" path directly -- reopening the prefix with
;; (:prefix ("c" . "code") ...) redefines SPC c's keymap from scratch and
;; clobbers Doom's existing bindings under it (ca, cf, etc).
(map! :leader :desc "Sync function to other file" "c y" #'+cc/sync-function-other-file)

;; Spell checking via jinx instead of the `(spell +flyspell)' module: same
;; JIT-underline + correct-at-point model as flyspell, but talks to libenchant
;; in-process rather than piping the buffer to a hunspell subprocess.
;; First activation compiles a small C module (needs the enchant2-devel package).
(defun +spell/jinx-correct-at-mouse (event)
  "Move point to the clicked word and run `jinx-correct'."
  (interactive "e")
  (mouse-set-point event)
  (jinx-correct))

(use-package! jinx
  :init
  (setq jinx-languages "en_US")
  ;; text-mode covers org/markdown/etc; prog-mode checks comments + docstrings +
  ;; string literals (jinx's default `jinx-include-faces').
  (add-hook! '(text-mode-hook git-commit-mode-hook prog-mode-hook) #'jinx-mode)
  :config
  ;; Red wavy underline for misspellings, matching the old `flyspell-incorrect'
  ;; look. That face isn't loaded now that the spell module is off, so take the
  ;; colour from `error' (mapped to the theme's red). jinx's own default is a
  ;; tan wave; a bare `:underline t' would render as a flat line.
  (let ((red (face-attribute 'error :foreground nil t)))
    (set-face-attribute 'jinx-misspelled nil
                        :underline `(:style wave :color ,(if (stringp red) red "red"))))
  ;; Accept period-terminated abbreviations. jinx tokenises "eg." as the word
  ;; "eg" (the dot is punctuation), so a dictionary entry can't carry the dot;
  ;; exclude them by regexp instead -- matched case-sensitively at each word's
  ;; start. Only covers the dotless-internal forms ("eg.", not "e.g.").
  (add-to-list 'jinx-exclude-regexps
               '(t "[Ee]g\\." "[Ii]e\\." "etc\\." "cf\\." "vs\\." "viz\\." "al\\."))
  ;; Correction UI stays the plain vertical completing-read (like
  ;; `flyspell-correct-at-point'). The candidate list already includes the
  ;; "Accept and save" entries -- @word (personal dict), *word (file-local),
  ;; +word (session) -- and `@'/`*'/`+' work as one-key prefixes in the prompt.
  (map! :map jinx-mode-map
        [remap ispell-word] #'jinx-correct
        "M-$" #'jinx-correct
        :n "z=" #'jinx-correct
        :n "]s" #'jinx-next
        :n "[s" #'jinx-previous)
  ;; Left-click a misspelled word to run `jinx-correct' (the same minibuffer UI
  ;; as z=). Drop jinx's graphical popup on mouse-3 entirely.
  (keymap-set jinx-overlay-map "<mouse-1>" #'+spell/jinx-correct-at-mouse)
  (keymap-unset jinx-overlay-map "<down-mouse-3>" t)

  ;; The correction UI's "save (directory)" option runs `jinx--save-dir', which
  ;; edits .dir-locals.el via `add-dir-local-variable'. That `find-file's the
  ;; file and leaves it modified-but-unsaved; jinx then buries the buffer in a
  ;; `save-window-excursion', so you're left with a stray unsaved .dir-locals.el
  ;; to `C-x C-s' by hand (and lose on kill). Save it as soon as
  ;; `add-dir-local-variable' / `delete-dir-local-variable' returns -- that
  ;; buffer is still current at that point -- then drop it from the current
  ;; workspace (persp-mode) and bury it, so it stays live and visitable via
  ;; `SPC <' / `switch-to-buffer' but no longer clutters the workspace-scoped
  ;; `SPC ,' list or sits as `other-buffer'. Only act while jinx is the caller,
  ;; and only if the current buffer really is a dir-locals file (the delete path
  ;; can bail out early without visiting anything).
  (defvar +spell--jinx-persisting-dir-locals nil)
  (defadvice! +spell--jinx-persisting-dir-locals-a (fn &rest args)
    :around #'jinx--save-dir
    (let ((+spell--jinx-persisting-dir-locals t))
      (apply fn args)))
  (defadvice! +spell--jinx-persist-dir-locals-a (&rest _)
    :after '(add-dir-local-variable delete-dir-local-variable)
    (when (and +spell--jinx-persisting-dir-locals
               (buffer-file-name)
               (string-match-p "\\`\\.dir-locals\\(?:-2\\)?\\.el\\'"
                               (file-name-nondirectory (buffer-file-name))))
      (let ((buf (current-buffer)))
        (when (buffer-modified-p) (save-buffer))
        (when (and (bound-and-true-p persp-mode) (fboundp 'persp-remove-buffer))
          (persp-remove-buffer buf))
        (bury-buffer buf)))))

;; `M-x +spell/edit-personal-dictionary' -- open the enchant personal word list
;; jinx saves accepted words into. Not bound to a key; toggle `jinx-mode' off/on
;; (or restart) after editing, since enchant only reads it when opening a dict.
(defun +spell/edit-personal-dictionary ()
  "Open the enchant personal word list used by jinx (~/.config/enchant/<lang>.dic)."
  (interactive)
  (let* ((lang (car (split-string (if (boundp 'jinx-languages) jinx-languages "en_US"))))
         (dir  (or (getenv "ENCHANT_CONFIG_DIR")
                   (expand-file-name "enchant"
                                     (or (getenv "XDG_CONFIG_HOME") "~/.config"))))
         (file (expand-file-name (concat lang ".dic") dir)))
    (make-directory dir t)
    (find-file file)))
