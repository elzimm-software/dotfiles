;;; personal/cc-sync/doctor.el -*- lexical-binding: t; -*-

;; +cc/sync-function-other-file drives clangd's textDocument/switchSourceHeader
;; and parses the buffer with the tree-sitter C grammar.

(unless (executable-find "clangd")
  (warn! "Couldn't find clangd; +cc/sync-function-other-file can't locate the paired file without it."))

(unless (and (require 'treesit nil t)
             (fboundp 'treesit-available-p)
             (treesit-available-p)
             (treesit-language-available-p 'c))
  (warn! "The tree-sitter C grammar isn't available; +cc/sync-function-other-file needs c-ts-mode."))
