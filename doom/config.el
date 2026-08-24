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
  (setq lsp-enable-snippet nil))

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
