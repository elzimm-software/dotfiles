;;; checkers/spell/doctor.el -*- lexical-binding: t; -*-

;; jinx compiles jinx-mod.c into a dynamic module -- against <emacs-module.h> and
;; libenchant -- the first time `jinx-mode' turns on (see `jinx--load-module').
;; A missing prerequisite makes that compile fail inside a mode hook, where the
;; error is demoted to a message interactively, or aborts `emacs --daemon' with
;; "server did not start correctly".
;;
;; Probing for proxy executables misses this: Fedora ships the enchant-2 CLI in
;; the runtime package but enchant-2.pc and the headers only in enchant2-devel,
;; and <emacs-module.h> only in emacs-devel. So reproduce jinx's build here --
;; an actual compile of a stub with the same includes, compiler resolution and
;; flags jinx uses.

(if (not module-file-suffix)
    (warn! "Emacs lacks dynamic-module support; jinx cannot load.")
  (let ((cc (or (getenv "CC")
                (seq-find #'executable-find '("gcc" "clang" "cc")))))
    (if (not cc)
        (progn
          (warn! "No C compiler found (need gcc, clang or cc); jinx cannot build jinx-mod.")
          (explain! "jinx builds its native module on first use; install a C toolchain."))
      (let* ((enchant-flags
              (with-temp-buffer
                (if (and (executable-find "pkg-config")
                         (eq 0 (call-process "pkg-config" nil t nil
                                             "--cflags" "--libs" "enchant-2")))
                    (split-string (buffer-string))
                  ;; jinx's own fallback when pkg-config can't resolve enchant-2
                  '("-I/usr/include/enchant-2" "-I/usr/local/include/enchant-2"
                    "-L/usr/local/lib" "-lenchant-2"))))
             (src (make-temp-file "jinx-doctor-" nil ".c"
                                  "#include <emacs-module.h>\n#include <enchant.h>\n"))
             (obj (make-temp-file "jinx-doctor-" nil module-file-suffix))
             ;; matches `jinx--compile-flags' in jinx.el
             (flags '("-I." "-O2" "-Wall" "-Wextra" "-fPIC" "-shared"))
             (result (with-temp-buffer
                       (cons (apply #'call-process cc nil t nil
                                    `(,@flags "-o" ,obj ,src ,@enchant-flags))
                             (buffer-string)))))
        (ignore-errors (delete-file src))
        (ignore-errors (delete-file obj))
        (unless (eq 0 (car result))
          (warn! "jinx will fail to build its native module (jinx-mod%s)." module-file-suffix)
          (explain! "jinx compiles against <emacs-module.h> and libenchant on first use "
                    "and a build prerequisite is missing. Install the dev packages -- "
                    "Fedora: emacs-devel enchant2-devel; "
                    "Debian/Ubuntu: libenchant-2-dev; "
                    "Arch: enchant plus base-devel; "
                    "macOS/Homebrew: enchant.")
          (explain! "Compiler output:\n" (string-trim (cdr result))))))))
