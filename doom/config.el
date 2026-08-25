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

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   (append org-babel-load-languages
           '((mermaid . t))))
  (setq ob-mermaid-cli-path (executable-find "mmdc")))

(after! lsp-mode
  (setq lsp-enable-snippet nil
        ;; Always show the code-action menu, even when only one action is
        ;; available, instead of silently auto-applying it.
        lsp-auto-execute-action t))

(after! lsp-ui
  ;; Lightbulb hint in the sideline when a code action is available at
  ;; point, so you know one exists before invoking SPC c a.
  (setq lsp-ui-sideline-show-code-actions t))

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

(use-package! claude-code
  :config
  (setq claude-code-terminal-backend 'vterm)
  (claude-code-mode)
  ;; Emacs's own process inherits CLAUDECODE/CLAUDE_CODE_CHILD_SESSION from
  ;; whatever shell launched it, so a `claude` session started here reads
  ;; itself as a nested child session and disables transcript saving. An
  ;; entry with no "=" unsets the var for the subprocess regardless of what
  ;; Emacs inherited, so each session started this way is treated as fresh.
  (add-hook 'claude-code-process-environment-functions
            (lambda (_buffer-name _dir)
              '("CLAUDECODE" "CLAUDE_CODE_CHILD_SESSION"))))

(use-package! monet
  :after claude-code
  :init
  ;; claude-code-command-map already uses several single letters (i, s, m,
  ;; ...) that monet's own C-c m map would also want, so monet's map is
  ;; bound as its own leader sibling ("o m") below instead of nesting it
  ;; inside "o c"; no need for monet's separate global C-c m prefix too.
  (setq monet-prefix-key nil)
  :config
  (monet-mode)
  ;; Auto-starts a Monet websocket server whenever a Claude Code session
  ;; launches from claude-code.el, instead of requiring the manual
  ;; `/ide` slash command each time.
  (add-hook 'claude-code-process-environment-functions
            #'monet-start-server-function))

(map! :leader
      :desc "Claude Code" "o c" claude-code-command-map
      :desc "Claude IDE (monet)" "o m" monet-command-map)
