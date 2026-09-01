;;; personal/cc-sync/config.el -*- lexical-binding: t; -*-

;; +cc/sync-function-other-file lives in this module's autoload.el (header/source
;; sync, since clangd's own tweaks only cover header-first inline splitting).
;; NOTE: bind the full "c y" path directly -- reopening the prefix with
;; (:prefix ("c" . "code") ...) redefines SPC c's keymap from scratch and
;; clobbers Doom's existing bindings under it (ca, cf, etc).
(map! :leader :desc "Sync function to other file" "c y" #'+cc/sync-function-other-file)
