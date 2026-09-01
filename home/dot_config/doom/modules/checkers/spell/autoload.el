;;; checkers/spell/autoload.el -*- lexical-binding: t; -*-

;; This module swaps flyspell/spell-fu out for jinx, but other modules still
;; call the stock spell module's autodefs. `:lang markdown' invokes
;; `set-flyspell-predicate!' at load time, so it has to stay defined -- as a
;; no-op here, since jinx has no flyspell-style generic check predicate (this
;; is exactly how stock `(spell)' behaves without the `+flyspell' flag).

;;;###autoload
(defun set-flyspell-predicate! (_modes _predicate)
  "Compatibility no-op: this spell module uses jinx, not flyspell."
  (declare (indent defun))
  nil)

;;;###autoload
(defalias 'flyspell-mode! #'jinx-mode
  "Compatibility alias: the stock module's `flyspell-mode!' under jinx.")
