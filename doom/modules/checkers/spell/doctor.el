;;; checkers/spell/doctor.el -*- lexical-binding: t; -*-

;; jinx compiles a small C module against libenchant the first time it loads.

(unless (executable-find "pkg-config")
  (warn! "Couldn't find pkg-config; jinx won't be able to build its native module."))

(unless (or (executable-find "enchant-2") (executable-find "enchant"))
  (warn! "Couldn't find an enchant executable. Install enchant and its dev headers (e.g. enchant2-devel) or jinx will fail to compile."))
