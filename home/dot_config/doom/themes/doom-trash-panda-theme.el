;;; doom-trash-panda-theme.el --- Trash Panda theme for Doom Emacs -- lexical-binding: t; --

(require 'doom-themes)

(defgroup doom-trash-panda-theme nil
"Options for the doom-trash-panda theme."
:group 'doom-themes)

(defcustom doom-trash-panda-brighter-modeline nil
"If non-nil, more vivid colors will be used to style the mode-line."
:group 'doom-trash-panda-theme
:type 'boolean)

(defcustom doom-trash-panda-brighter-comments nil
"If non-nil, comments will be highlighted in more vivid colors."
:group 'doom-trash-panda-theme
:type 'boolean)

(defcustom doom-trash-panda-padded-modeline doom-themes-padded-modeline
"If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
:group 'doom-trash-panda-theme
:type '(choice integer boolean))

;;
;;; Theme definition

(def-doom-theme doom-trash-panda
"A dark, colorful theme based on Jason Hulbert's Trash Panda."

;; name        default   256       16
((bg         '("#141618" nil       nil            ))
(bg-alt     '("#1D2123" nil       nil            ))
(base0      '("#000000" "black"   "black"        ))
(base1      '("#141618" "#141618" "black"        ))
(base2      '("#1D2123" "#1D2123" "brightblack"  ))
(base3      '("#2C3135" "#2C3135" "brightblack"  ))
(base4      '("#5f656a" "#5f656a" "brightblack"  ))
(base5      '("#727a7f" "#727a7f" "brightblack"  ))
(base6      '("#b8babd" "#b8babd" "white"        ))
(base7      '("#e2e2e2" "#e2e2e2" "brightwhite"  ))
(base8      '("#FFFFFF" "white"   "brightwhite"  ))
(fg         '("#b8babd" "#b8babd" "white"        ))
(fg-alt     '("#727a7f" "#727a7f" "brightblack"  ))

(grey       base4)
(red        '("#e8626f" "#e8626f" "red"          ))
(orange     '("#E8886D" "#E8886D" "brightred"    ))
(green      '("#42ba90" "#42ba90" "green"        ))
(lime       '("#8ec475" "#8ec475" "brightgreen"  ))
(yellow     '("#dcc37c" "#dcc37c" "yellow"       ))
(blue       '("#2c99db" "#2c99db" "brightblue"   ))
(dark-blue  '("#18285C" "#18285C" "blue"         ))
(magenta    '("#DC6096" "#DC6096" "magenta"      ))
(violet     '("#A07CF1" "#A07CF1" "brightmagenta"))
(cyan       '("#50cae5" "#50cae5" "brightcyan"   ))
(dark-cyan  '("#3c98ac" "#3c98ac" "cyan"         ))
(accent     '("#406bf4" "#406bf4" "blue"         ))

;; custom diff colors from jetbrains xml
(diff-add   '("#102f24" "#102f24" "green"        ))
(diff-mod   '("#0B2637" "#0B2637" "blue"         ))
(diff-rm    '("#3a181c" "#3a181c" "red"          ))

(highlight      dark-blue)
(vertical-bar   base3)
(selection      dark-blue)
(builtin        lime)
(comments       (if doom-trash-panda-brighter-comments base6 base5))
(doc-comments   (if doom-trash-panda-brighter-comments base6 base5))
(constants      magenta)
(functions      lime)
(keywords       violet)
(methods        lime)
(operators      violet)
(type           cyan)
(strings        yellow)
(variables      fg)
(numbers        orange)
(region         selection)
(error          red)
(warning        orange)
(success        green)
(vc-modified    blue)
(vc-added       green)
(vc-deleted     red)

;; custom categories
(modeline-fg     fg)
(modeline-fg-alt base5)
(modeline-bg     (if doom-trash-panda-brighter-modeline base3 base2))
(modeline-bg-l   (if doom-trash-panda-brighter-modeline base4 base3))
(modeline-bg-inactive   base1)
(modeline-fg-inactive   base4))

;;;; Base theme face overrides
(((font-lock-comment-face &override)
:foreground comments :slant 'italic)
((font-lock-doc-face &override)
:foreground doc-comments :slant 'italic)
((font-lock-keyword-face &override)
:foreground keywords)
((font-lock-function-name-face &override)
:foreground functions)
((font-lock-variable-name-face &override)
:foreground variables)
((font-lock-type-face &override)
:foreground type)
((font-lock-constant-face &override)
:foreground constants)
((font-lock-builtin-face &override)
:foreground builtin)
((font-lock-string-face &override)
:foreground strings)
((font-lock-number-face &override)
:foreground numbers)

;; Treesit faces (Emacs 29+)
(treesit-font-lock-variable-use-face :foreground variables)
(treesit-font-lock-property-face :foreground green)
(treesit-font-lock-operator-face :foreground operators)
(treesit-font-lock-punctuation-face :foreground base6)
(treesit-font-lock-bracket-face :foreground base6)
(treesit-font-lock-number-face :foreground numbers)
(treesit-font-lock-string-face :foreground strings)
(treesit-font-lock-type-face :foreground type)
(treesit-font-lock-builtin-face :foreground builtin)
(treesit-font-lock-constant-face :foreground constants)
(treesit-font-lock-function-call-face :foreground functions)
(treesit-font-lock-keyword-face :foreground keywords)

((line-number &override) :foreground base4)
((line-number-current-line &override) :foreground accent :weight 'bold)

;; (mode-line
;; :background modeline-bg :foreground modeline-fg
;; :box (if -line-pad (:line-width ,-line-pad :color ,modeline-bg))) (mode-line-inactive :background modeline-bg-inactive :foreground modeline-fg-inactive :box (if -line-pad (:line-width ,-line-pad :color ,modeline-bg-inactive)))
;; (mode-line-emphasis
;; :foreground (if doom-trash-panda-brighter-modeline base8 highlight))

;; (solaire-mode-line-face
;; :inherit 'mode-line
;; :background modeline-bg-l
;; :box (if -line-pad (:line-width ,-line-pad :color ,modeline-bg-l))) (solaire-mode-line-
;; inactive-face :inherit 'mode-line-inactive :background modeline-bg-inactive :box (if -line-pad (:line-width ,-line-pad :color ,modeline-bg-inactive)))

;;;; Magit & Diff (Matched closely to JetBrains schema)
(magit-diff-added   :background diff-add :foreground base7)
(magit-diff-removed :background diff-rm :foreground base7)
(magit-diff-context :foreground base6 :background bg)
(magit-diff-file-heading :foreground base7 :background base2 :weight 'bold)
(magit-diff-file-heading-selection :foreground accent :background base3 :weight 'bold)
(magit-diff-hunk-heading :foreground base5 :background base2)
(magit-diff-hunk-heading-highlight :foreground base7 :background base3)

(diff-added   :background diff-add :foreground base7)
(diff-removed :background diff-rm :foreground base7)
(diff-changed :background diff-mod :foreground base7)

;;;; UI Elements
(hl-line :background base2)
(region :background selection :foreground base8)
(cursor :background accent)
(fringe :background bg :foreground base4)
(vertical-border :foreground vertical-bar)

(minibuffer-prompt :foreground accent :weight 'bold)

;;;; Org Mode
(org-level-1 :foreground violet :weight 'bold :height 1.2)
(org-level-2 :foreground magenta :weight 'bold :height 1.1)
(org-level-3 :foreground lime :weight 'bold :height 1.05)
(org-level-4 :foreground yellow :weight 'bold)
(org-level-5 :foreground green :weight 'bold)
(org-level-6 :foreground blue :weight 'bold)
(org-level-7 :foreground cyan :weight 'bold)
(org-level-8 :foreground orange :weight 'bold)

(org-document-title :foreground base7 :weight 'bold :height 1.3)
(org-document-info :foreground base5)

(org-block :background base2 :extend t)
(org-block-begin-line :background base2 :foreground base5 :extend t :slant 'italic)
(org-block-end-line :background base2 :foreground base5 :extend t :slant 'italic)

(org-todo :foreground orange :weight 'bold)
(org-done :foreground green :weight 'bold)
(org-headline-done :foreground base5 :strike-through t)

(org-table :foreground cyan)
(org-formula :foreground yellow)

(org-link :foreground accent :underline t)
(org-code :foreground cyan :background base1)
(org-verbatim :foreground green)
(org-quote :foreground base5 :slant 'italic :background base1 :extend t)
(org-hide :foreground bg)

(org-date :foreground blue :underline t)
(org-special-keyword :foreground violet)
(org-drawer :foreground base4)
(org-property-value :foreground green)

(org-tag :foreground base5 :weight 'bold :box `(:line-width 1 :color ,base3))
(org-priority :foreground red :weight 'bold)
(org-footnote :foreground orange :underline t)

(org-checkbox :foreground accent :weight 'bold)
(org-checkbox-statistics-todo :foreground orange :weight 'bold)
(org-checkbox-statistics-done :foreground green :weight 'bold)

(org-agenda-date :foreground blue :weight 'bold)
(org-agenda-date-today :foreground accent :weight 'bold :slant 'italic)
(org-agenda-date-weekend :foreground dark-cyan :weight 'bold)
(org-agenda-done :foreground base5 :strike-through t)
(org-agenda-structure :foreground violet :weight 'bold :height 1.1)

;;;; Markdown Mode
(markdown-header-face-1 :foreground violet :weight 'bold)
(markdown-header-face-2 :foreground magenta :weight 'bold)
(markdown-header-face-3 :foreground lime :weight 'bold)
(markdown-header-face-4 :foreground yellow :weight 'bold)
(markdown-header-face-5 :foreground green :weight 'bold)
(markdown-header-face-6 :foreground blue :weight 'bold)
(markdown-code-face :background base2 :foreground cyan)
(markdown-pre-face :background base2 :foreground base6)
(markdown-inline-code-face :foreground cyan :background base1)
(markdown-link-face :foreground accent :underline t)
(markdown-url-face :foreground base5 :underline nil)

;;;; LSP & Diagnostics
(flycheck-error :underline (:style wave :color ,red)) (flycheck-warning :underline (:style wave :color ,orange))
(flycheck-info :underline `(:style wave :color ,blue))

(flymake-error :underline (:style wave :color ,red)) (flymake-warning :underline (:style wave :color ,orange))
(flymake-note :underline `(:style wave :color ,blue))

(lsp-ui-doc-background :background base2)
(lsp-ui-peek-header :foreground fg-alt :background base3)
(lsp-ui-peek-selection :foreground fg-alt :background selection)
(lsp-ui-sideline-global :foreground base5 :slant 'italic)
(lsp-ui-sideline-code-action :foreground yellow)
(lsp-ui-sideline-current-symbol :foreground blue)
(lsp-lens-face :foreground base4 :height 0.8 :slant 'italic)
(lsp-face-highlight-textual :background base3)
(lsp-face-highlight-read :background base3)
(lsp-face-highlight-write :background base3 :weight 'bold)

;; LSP Semantic Tokens (directly matched to JetBrains scheme)
(lsp-face-semhl-class :foreground lime)
(lsp-face-semhl-interface :foreground cyan)
(lsp-face-semhl-enum :foreground cyan)
(lsp-face-semhl-function :foreground lime)
(lsp-face-semhl-method :foreground lime)
(lsp-face-semhl-property :foreground green)
(lsp-face-semhl-field :foreground green)
(lsp-face-semhl-variable :foreground fg)
(lsp-face-semhl-namespace :foreground magenta)
(lsp-face-semhl-constant :foreground magenta)
(lsp-face-semhl-type :foreground cyan)
(lsp-face-semhl-keyword :foreground violet)
(lsp-face-semhl-string :foreground yellow)
(lsp-face-semhl-number :foreground orange)

;; Eglot (Emacs 29+ Built-in LSP)
(eglot-highlight-symbol-face :background base3)
(eglot-mode-line :foreground accent :weight 'bold)
(eglot-diagnostic-tag-unnecessary-face :foreground base5 :strike-through t)

;;;; Completion (Company, Vertico, Helm, Ivy)
(company-tooltip :background base2 :foreground base6)
(company-tooltip-selection :background selection :foreground base8)
(company-tooltip-common :foreground accent :weight 'bold)
(company-tooltip-annotation :foreground base5)

(corfu-default :background base2 :foreground base6)
(corfu-current :background selection :foreground base8)
(corfu-annotations :foreground base5)

(vertico-current :background base3 :foreground base7 :weight 'bold)

(helm-selection :background selection :foreground base8)
(helm-source-header :background base2 :foreground violet :weight 'bold)

(ivy-current-match :background selection :foreground base8)
(ivy-minibuffer-match-face-1 :foreground accent)
(ivy-minibuffer-match-face-2 :foreground green :weight 'bold)
(ivy-minibuffer-match-face-3 :foreground magenta :weight 'bold)
(ivy-minibuffer-match-face-4 :foreground yellow :weight 'bold)

;;;; Dired / Treemacs
(dired-directory :foreground blue :weight 'bold)
(dired-symlink :foreground cyan)
(dired-ignored :foreground base4)

(treemacs-directory-face :foreground blue)
(treemacs-file-face :foreground base6)
(treemacs-git-modified-face :foreground blue)
(treemacs-git-added-face :foreground green)
(treemacs-git-untracked-face :foreground orange)
(treemacs-tags-face :foreground magenta)))

;;; doom-trash-panda-theme.el ends here
