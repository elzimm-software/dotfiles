;;; personal/ros-container/doctor.el -*- lexical-binding: t; -*-

(unless (executable-find "podman")
  (warn! "podman isn't installed; ROS container LSP clients can't start."))

(unless (modulep! :tools lsp)
  (warn! ":tools lsp is disabled; this module only adds lsp-mode clients."))

(when (modulep! :tools lsp +eglot)
  (warn! "This module targets lsp-mode, not eglot."))
