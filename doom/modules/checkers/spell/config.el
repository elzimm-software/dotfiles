;;; checkers/spell/config.el -*- lexical-binding: t; -*-

;; Private override of Doom's stock :checkers spell module. Doom's version wires
;; flyspell/spell-fu up to an aspell/hunspell subprocess; this one drops all of
;; that for jinx, which talks to libenchant in-process. The stock module's flags
;; (+flyspell, +aspell, +hunspell, +everywhere) are intentionally ignored here.

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
  ;; look. That face isn't loaded (Doom's flyspell is gone), so take the colour
  ;; from `error' (mapped to the theme's red). jinx's own default is a tan wave;
  ;; a bare `:underline t' would render as a flat line.
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
  ;; `]s'/`[s'/`zg'/`zw' are bound to `+spell/*' commands by :editor evil and
  ;; `SPC t s' to `spell-fu-mode' by :config default -- all void now that the
  ;; stock module is gone. Rebind them onto jinx (the jinx-mode-map entries win
  ;; while jinx-mode is on; `SPC t s' is rebound below).
  (map! :map jinx-mode-map
        [remap ispell-word] #'jinx-correct
        "M-$" #'jinx-correct
        :n "z=" #'jinx-correct
        :n "zg" #'jinx-correct
        :n "zw" #'+spell/edit-personal-dictionary
        :n "]s" #'jinx-next
        :n "[s" #'jinx-previous)
  (map! :leader :desc "Spell checker" "t s" #'jinx-mode)
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
