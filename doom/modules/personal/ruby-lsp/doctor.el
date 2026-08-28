;;; personal/ruby-lsp/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "ruby")
  (warn! "Couldn't find a ruby executable."))

(unless (executable-find "bundle")
  (warn! "Couldn't find bundler; per-project ruby-lsp detection relies on `bundle'."))

(unless (or (executable-find "ruby-lsp")
            (file-exists-p (expand-file-name "~/.local/bin/ruby-lsp")))
  (warn! "Couldn't find a global ruby-lsp. Install it with `gem install --bindir ~/.local/bin ruby-lsp' for projects that don't bundle their own."))
