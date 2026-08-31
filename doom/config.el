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

;; Python LSP via basedpyright instead of stock pyright. The binary is an
;; isolated venv symlinked into ~/.local/bin, which is already on exec-path
;; (see the block near the top of this file).
(after! lsp-pyright
  (setq lsp-pyright-langserver-command "basedpyright"))

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
