;;; horizon-trash-panda-theme.el --- Horizon Dark base, Trash Panda syntax -*- no-byte-compile: t; -*-
;;
;; Author:  (generated)
;; Base UI: Horizon Dark (https://github.com/jolaleye/horizon-theme.el)
;; Syntax:  JetBrains Trash Panda (https://github.com/jasonhulbert/jetbrains-trash-panda-theme)
;;
;; General/UI colors (background, chrome, diagnostics, VCS, terminal ANSI
;; colors) come from the Horizon Dark palette. Code syntax-highlighting
;; faces (strings, keywords, comments, functions, types, numbers, etc.)
;; are pulled from Trash Panda's color roles instead.

(require 'doom-themes)

;;
;;; Variables

(defgroup horizon-trash-panda-theme nil
  "Options for the `horizon-trash-panda' theme."
  :group 'doom-themes)

(defcustom horizon-trash-panda-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'horizon-trash-panda-theme
  :type 'boolean)

(defcustom horizon-trash-panda-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'horizon-trash-panda-theme
  :type 'boolean)

(defcustom horizon-trash-panda-comment-bg horizon-trash-panda-brighter-comments
  "If non-nil, comments will have a subtle background."
  :group 'horizon-trash-panda-theme
  :type 'boolean)

(defcustom horizon-trash-panda-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line."
  :group 'horizon-trash-panda-theme
  :type '(choice integer boolean))

;;
;;; Theme definition

(def-doom-theme horizon-trash-panda
  "A dark theme using the Horizon Dark palette for UI chrome, with
Trash Panda's syntax-highlighting colors for code."

  ;; name        default   256       16
  ((bg         '("#1C1E26" nil       nil))
   (bg-alt     '("#16161C" nil       nil))
   (base0      '("#16161C" "black"   "black"))
   (base1      '("#232530" "brightblack" "brightblack"))
   (base2      '("#282A38" "brightblack" "brightblack"))
   (base3      '("#333644" "brightblack" "brightblack"))
   (base4      '("#4A4E60" "brightblack" "brightblack"))
   (base5      '("#6B7089" "brightblack" "brightblack"))
   (base6      '("#9EA2B5" "white"   "brightwhite"))
   (base7      '("#C8CBD8" "brightwhite" "brightwhite"))
   (base8      '("#FDF0ED" "white"   "brightwhite"))
   (fg         '("#FDF0ED" "white"   "brightwhite"))
   (fg-alt     '("#FADAD1" "white"   "white"))

   (grey       base4)
   (red            '("#E95678" "red"          "red"))
   (bright-red     '("#EC6A88" "brightred"    "brightred"))
   (orange         '("#E8886D" "brightred"    "brightred"))
   (green          '("#29D398" "green"        "green"))
   (bright-green   '("#3FDAA4" "brightgreen"  "brightgreen"))
   (teal           '("#42BA90" "green"        "green"))
   (yellow         '("#FAB795" "yellow"       "yellow"))
   (bright-yellow  '("#FBC3A7" "brightyellow" "brightyellow"))
   (blue           '("#26BBD9" "blue"         "blue"))
   (bright-blue    '("#3FC6DE" "brightblue"   "brightblue"))
   (dark-blue      '("#2C99DB" "blue"         "blue"))
   (magenta        '("#EE64AE" "magenta"      "magenta"))
   (bright-magenta '("#F075B7" "brightmagenta" "brightmagenta"))
   (violet         '("#A07CF1" "magenta"      "brightmagenta"))
   (cyan           '("#59E3E3" "cyan"         "brightcyan"))
   (bright-cyan    '("#6BE6E6" "brightcyan"   "brightcyan"))
   (dark-cyan      (doom-darken cyan 0.15))

   (highlight      violet)
   (vertical-bar   base1)
   (selection      base2)
   (builtin        green)
   ;; -- syntax faces below use Trash Panda's color roles --
   (comments       (if horizon-trash-panda-brighter-comments base6 "#727A7F"))
   (doc-comments   (doom-lighten (if horizon-trash-panda-brighter-comments base6 "#727A7F") 0.15))
   (constants      "#DC6096")
   (functions      "#8EC475")
   (keywords       "#A07CF1")
   (methods        "#8EC475")
   (operators      "#A07CF1")
   (type           "#2C99DB")
   (strings        "#DCC37C")
   (variables      "#42BA90")
   (numbers        "#E8886D")
   ;; -- end Trash Panda syntax faces --
   (region         base3)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    yellow)
   (vc-added       green)
   (vc-deleted     red)

   ;; face categories -- required for all themes
   (modeline-fg     fg)
   (modeline-fg-alt base5)
   (modeline-bg     (if horizon-trash-panda-brighter-modeline
                        (doom-darken blue 0.45)
                      base1))
   (modeline-bg-l   (if horizon-trash-panda-brighter-modeline
                        (doom-darken blue 0.4)
                      base2))
   (modeline-bg-inactive   (doom-darken bg 0.1))
   (modeline-bg-inactive-l base1))

  ;;;; Base theme face overrides
  ((font-lock-comment-face
    :foreground comments
    :background (if horizon-trash-panda-comment-bg (doom-lighten bg-alt 0.05))
    :slant 'italic)
   (font-lock-doc-face
    :inherit 'font-lock-comment-face
    :foreground doc-comments)
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg-alt :weight 'bold)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if horizon-trash-panda-padded-modeline `(:line-width ,horizon-trash-panda-padded-modeline :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if horizon-trash-panda-padded-modeline `(:line-width ,horizon-trash-panda-padded-modeline :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if horizon-trash-panda-brighter-modeline base8 highlight))
   (cursor :background fg)
   ((hl-line &override) :background base1)
   (region :background region :distant-foreground base8)
   ((secondary-selection &override) :background base2)
   ;; whitespace-mode
   (whitespace-tab :background 'unspecified :foreground base2)
   (whitespace-newline :foreground base2)
   ;; ivy / vertico
   (ivy-current-match :background base3 :distant-foreground 'unspecified)
   (vertico-current :background base3 :distant-foreground 'unspecified :weight 'bold)
   (orderless-match-face-0 :foreground violet :weight 'bold)
   (orderless-match-face-1 :foreground blue :weight 'bold)
   (orderless-match-face-2 :foreground teal :weight 'bold)
   (orderless-match-face-3 :foreground yellow :weight 'bold)
   ;; company
   (company-tooltip-common :foreground highlight :distant-foreground base0 :weight 'bold)
   (company-tooltip-selection :background base3)
   (company-scrollbar-bg :background base2)
   (company-scrollbar-fg :background highlight)

   ;;; :ui
   ;; hl-todo
   (hl-todo :foreground bright-red :weight 'bold)
   ;; doom-dashboard
   (doom-dashboard-banner :foreground violet :weight 'bold)
   (doom-dashboard-menu-title :foreground green)
   (doom-dashboard-menu-desc :foreground base6)
   (doom-dashboard-loaded :foreground yellow)
   ;; indent-guides
   (highlight-indent-guides-character-face :foreground base2)
   (highlight-indent-guides-top-character-face :foreground base4)
   (highlight-indent-guides-stack-character-face :foreground base2)
   ;; treemacs
   (treemacs-root-face :foreground fg :weight 'bold :height 1.1)
   (treemacs-git-modified-face :foreground vc-modified)
   (treemacs-git-added-face :foreground vc-added)
   (treemacs-git-untracked-face :foreground base6)
   (treemacs-git-renamed-face :foreground base6)
   (treemacs-git-ignored-face :foreground base4)
   ;; ophints (evil-goggles)
   (evil-goggles-default-face :inherit 'region :background (doom-blend violet bg 0.25))
   (evil-goggles-yank-face :background (doom-blend teal bg 0.25))
   (evil-goggles-delete-face :background (doom-blend red bg 0.25))
   (evil-goggles-paste-face :background (doom-blend green bg 0.25))
   ;; evil search / substitute
   (evil-search-highlight-persist-highlight-face :background (doom-blend yellow bg 0.3))
   (evil-ex-lazy-highlight :background (doom-blend cyan bg 0.3) :foreground base8)
   (evil-ex-substitute-matches :background (doom-blend red bg 0.4) :foreground bright-red :strike-through t)
   (evil-ex-substitute-replacement :background (doom-blend green bg 0.4) :foreground bright-green :underline nil)
   ;; zen / writeroom
   (mixed-pitch-face :inherit 'variable-pitch :foreground fg)
   ;; workspaces / persp tab bar
   (+workspace-tab-selected-face :background highlight :foreground base0 :weight 'bold)

   ;;; :editor
   (fill-column-indicator :foreground base2)

   ;;; :emacs
   ;; dired
   (dired-directory :foreground blue :weight 'bold)
   (dired-marked :foreground yellow :weight 'bold)
   (dired-flagged :foreground red :weight 'bold)
   ;; undo
   (undo-tree-visualizer-current-face :foreground bright-magenta :weight 'bold)
   (undo-tree-visualizer-active-branch-face :foreground fg)
   (undo-tree-visualizer-default-face :foreground base5)
   (undo-tree-visualizer-register-face :foreground yellow)

   ;;; :term
   ;; vterm ansi colors
   (vterm-color-black       :background base0 :foreground base1)
   (vterm-color-red         :background red :foreground red)
   (vterm-color-green       :background green :foreground green)
   (vterm-color-yellow      :background yellow :foreground yellow)
   (vterm-color-blue        :background blue :foreground blue)
   (vterm-color-magenta     :background magenta :foreground magenta)
   (vterm-color-cyan        :background cyan :foreground cyan)
   (vterm-color-white       :background base6 :foreground base6)

   ;;; :checkers
   ;; flycheck
   (flycheck-error   :underline `(:style wave :color ,red))
   (flycheck-warning :underline `(:style wave :color ,yellow))
   (flycheck-info    :underline `(:style wave :color ,teal))
   (flycheck-fringe-error   :foreground red :weight 'bold)
   (flycheck-fringe-warning :foreground yellow :weight 'bold)
   (flycheck-fringe-info    :foreground teal :weight 'bold)
   ;; flyspell
   (flyspell-incorrect :underline `(:style wave :color ,red))
   (flyspell-duplicate  :underline `(:style wave :color ,yellow))

   ;;; :tools
   ;; magit
   (magit-diff-added             :foreground vc-added)
   (magit-diff-added-highlight   :foreground vc-added :weight 'bold)
   (magit-diff-removed           :foreground vc-deleted)
   (magit-diff-removed-highlight :foreground vc-deleted :weight 'bold)
   (magit-diff-hunk-heading           :background base2 :foreground base6)
   (magit-diff-hunk-heading-highlight :background base3 :foreground fg)
   (magit-section-highlight :background base1)
   (magit-branch-local  :foreground blue)
   (magit-branch-remote :foreground green)
   (magit-hash :foreground base5)
   ;; docker
   (docker-container-name  :foreground blue)
   (docker-image-name      :foreground green)
   ;; lsp / lsp-ui
   (lsp-headerline-breadcrumb-path-face      :foreground base6)
   (lsp-headerline-breadcrumb-symbols-face   :foreground fg)
   (lsp-ui-doc-background   :background base1)
   (lsp-ui-doc-header       :background base2 :foreground fg)
   (lsp-ui-sideline-code-action :foreground yellow)
   (lsp-ui-sideline-symbol-info :foreground base5 :slant 'italic)
   ;; debugger / dap
   (dap-ui-marker-face :background (doom-blend yellow bg 0.25))
   (dap-ui-pending-breakpoint-face :foreground base5)
   (dap-ui-verified-breakpoint-face :foreground green)
   ;; ein (jupyter notebooks)
   (ein:cell-input-area :background base1)
   (ein:cell-output-area :background bg)
   (ein:cell-output-prompt :foreground magenta)
   (ein:basecell-input-prompt-face :foreground blue)
   (ein:basecell-output-prompt-face :foreground magenta)

   ;;; :lang
   ;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   ((markdown-code-face &override) :background (doom-lighten base3 0.05))
   ;; org-mode
   (org-hide :foreground bg)
   ((org-block &override) :background base1)
   ((org-block-begin-line &override) :background base1 :foreground comments)
   (org-todo      :foreground bright-red :weight 'bold)
   (org-done      :foreground green :weight 'bold)
   (org-headline-done :foreground base5 :strike-through t)
   (org-level-1   :foreground violet   :weight 'bold :height 1.2)
   (org-level-2   :foreground blue     :weight 'bold :height 1.1)
   (org-level-3   :foreground teal     :weight 'bold)
   (org-level-4   :foreground green    :weight 'bold)
   (org-level-5   :foreground yellow   :weight 'bold)
   (org-level-6   :foreground orange   :weight 'bold)
   (org-level-7   :foreground magenta  :weight 'bold)
   (org-link      :foreground cyan :underline t)
   (org-code      :foreground strings)
   (org-verbatim  :foreground teal)
   (org-date      :foreground base5)
   (org-tag       :foreground base5 :weight 'normal)
   (org-special-keyword :foreground base5)
   ;; latex
   (font-latex-sectioning-1-face :foreground violet :weight 'bold :height 1.2)
   (font-latex-sectioning-2-face :foreground blue   :weight 'bold :height 1.1)
   (font-latex-sectioning-3-face :foreground teal   :weight 'bold)
   (font-latex-math-face :foreground yellow)
   (font-latex-string-face :foreground strings)
   ;; web-mode
   (web-mode-html-tag-face      :foreground keywords)
   (web-mode-html-tag-bracket-face :foreground base5)
   (web-mode-html-attr-name-face :foreground methods)
   (web-mode-css-selector-face :foreground keywords)
   (web-mode-css-property-name-face :foreground methods)
   ;; plantuml
   (plantuml-cloud-face :foreground blue)
   (plantuml-note-face :foreground yellow)

   ;;; :app
   ;; calendar
   (calendar-today :foreground bright-yellow :weight 'bold)
   (holiday :foreground magenta)
   ;; emms
   (emms-playlist-track-face :foreground base6)
   (emms-playlist-selected-track-face :foreground green :weight 'bold)
   ;; irc
   (erc-current-nick-face :foreground bright-magenta :weight 'bold)
   (erc-nick-default-face :foreground blue)
   (erc-timestamp-face    :foreground base5)
   (erc-notice-face       :foreground base5)
   (erc-prompt-face       :foreground violet :weight 'bold)
   ;; rss (elfeed)
   (elfeed-search-title-face      :foreground base6)
   (elfeed-search-unread-title-face :foreground fg :weight 'bold)
   (elfeed-search-feed-face       :foreground blue)
   (elfeed-search-tag-face        :foreground teal))

  ;;;; Base theme variable overrides
  ())

;;; horizon-trash-panda-theme.el ends here
