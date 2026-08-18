;;; doom-ves-theme.el --- Custom Ves Theme (Slate Blue Secondary Text) -*- lexical-binding: t; -*-

(require 'doom-themes)

(deftheme doom-ves
  "A dark theme based on the Ves palette with a Graphite Black background and Slate Blue secondary text.")

(let ((space-cadet    "#1f2a44")
      (pistachio      "#a1d884")
      (blue-atoll     "#00afd7")
      (ethereal-white "#f2faf8")
      (graphite-black "#25282a")
      (dark-river     "#3f4444")
      (slate-blue     "#52728c")) ; Brighter complementary color for text readability

  (custom-theme-set-faces
   'doom-ves

   ;; Base UI Canvas (Graphite Black background)
   `(default ((t (:background ,graphite-black :foreground ,ethereal-white))))
   `(cursor ((t (:background ,blue-atoll :foreground ,graphite-black))))
   `(region ((t (:background ,dark-river :foreground ,ethereal-white))))
   `(secondary-selection ((t (:background ,space-cadet))))

   ;; Highlighting & Lines
   `(hl-line ((t (:background "#2e3235"))))
   `(fringe ((t (:background ,graphite-black :foreground ,slate-blue))))
   `(vertical-border ((t (:foreground ,space-cadet))))
   `(line-number ((t (:foreground ,slate-blue :background ,graphite-black))))
   `(line-number-current-line ((t (:foreground ,pistachio :background "#2e3235" :weight bold))))

   ;; Syntax Highlight Mapping (Using brightened Slate Blue)
   `(font-lock-builtin-face ((t (:foreground ,blue-atoll))))
   `(font-lock-comment-face ((t (:foreground ,slate-blue :italic t))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,slate-blue))))
   `(font-lock-constant-face ((t (:foreground ,pistachio :weight bold))))
   `(font-lock-doc-face ((t (:foreground ,slate-blue))))
   `(font-lock-function-name-face ((t (:foreground ,blue-atoll :weight bold))))
   `(font-lock-keyword-face ((t (:foreground ,blue-atoll :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,blue-atoll))))
   `(font-lock-preprocessor-face ((t (:foreground ,blue-atoll))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,pistachio))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,blue-atoll))))
   `(font-lock-string-face ((t (:foreground ,pistachio))))
   `(font-lock-type-face ((t (:foreground ,pistachio))))
   `(font-lock-variable-name-face ((t (:foreground ,ethereal-white))))
   `(font-lock-warning-face ((t (:foreground ,blue-atoll :weight bold))))

   ;; Mode Line (UI Bar)
   `(mode-line ((t (:background ,space-cadet :foreground ,ethereal-white :box nil))))
   `(mode-line-inactive ((t (:background ,graphite-black :foreground ,slate-blue :box nil))))

   ;; Search Modifiers
   `(isearch ((t (:background ,pistachio :foreground ,graphite-black :weight bold))))
   `(lazy-highlight ((t (:background ,blue-atoll :foreground ,graphite-black))))

   ;; Org-Mode Layouts
   `(org-level-1 ((t (:foreground ,blue-atoll :weight bold :height 1.3))))
   `(org-level-2 ((t (:foreground ,pistachio :weight bold :height 1.2))))
   `(org-level-3 ((t (:foreground ,ethereal-white :weight bold :height 1.1))))
   `(org-level-4 ((t (:foreground ,blue-atoll :height 1.0))))
   `(org-date ((t (:foreground ,pistachio))))
   `(org-block ((t (:background ,space-cadet :foreground ,ethereal-white))))
   `(org-block-begin-line ((t (:background ,space-cadet :foreground ,slate-blue))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path (file-name-directory load-file-name)))

(provide-theme 'doom-ves)
;;; doom-ves-theme.el ends here
