;;; personal/ros-container/config.el -*- lexical-binding: t; -*-

;; LSP for ROS 2 workspaces that build inside the podman dev container (see
;; ros.sh in the dev_container repo). ros.sh bind-mounts the workspace at the
;; same absolute path inside the container and drops a `.ros-container'
;; marker holding the container name at its root.
;;
;; For files under such a root, clangd and basedpyright run *inside* the
;; container via `podman exec ... ros-env', so they see /opt/ros/jazzy and the
;; container's toolchain/Python instead of the host's (which has no ROS).
;; Workspace paths are identical on both sides; anything the server reports
;; outside the workspace (ROS/system headers, rclpy sources) is opened
;; read-only over TRAMP's podman method instead of as a nonexistent host path.
;;
;; The clients are copies of lsp-mode's stock `clangd' and `pyright' clients
;; (same handlers, library folders, semantic-token faces, and honouring
;; `lsp-clients-clangd-args' / `lsp-pyright-langserver-command'), with a
;; higher priority and an activation-fn that only matches marked workspaces,
;; so everything outside a ROS workspace keeps using the host servers.

(defvar +ros-container-marker ".ros-container"
  "File at a ROS workspace root naming the podman container to use.")

(defvar +ros-container--names nil
  "Container names seen so far, to recognise their TRAMP buffers.")

(defun +ros-container-root (&optional dir)
  "Return the marked ROS workspace root containing DIR, or nil."
  (let ((dir (or dir default-directory)))
    (unless (file-remote-p dir)
      (when-let* ((root (locate-dominating-file dir +ros-container-marker)))
        (file-name-as-directory (file-truename root))))))

(defun +ros-container-name (root)
  "Return the container name recorded in ROOT's marker file."
  (let ((name (with-temp-buffer
                (insert-file-contents (expand-file-name +ros-container-marker root))
                (string-trim (buffer-string)))))
    (cl-pushnew name +ros-container--names :test #'equal)
    name))

(defun +ros-container--ensure-running (name)
  (unless (zerop (call-process "podman" nil nil nil "container" "exists" name))
    (user-error "ROS container %s doesn't exist; run ros.sh first" name))
  (call-process "podman" nil nil nil "start" name))

(defun +ros-container--connection (command-fn)
  "stdio connection running (COMMAND-FN ROOT) in the workspace's container."
  (lsp-stdio-connection
   (lambda ()
     (let* ((root (or (+ros-container-root)
                      (user-error "Not in a ROS container workspace")))
            (name (+ros-container-name root)))
       (+ros-container--ensure-running name)
       `("podman" "exec" "-i" "-w" ,(directory-file-name root) ,name
         "ros-env" ,@(funcall command-fn root))))
   (lambda () (executable-find "podman"))))

(defun +ros-container--uri-to-path (uri)
  "Map URI to a host path; container-only paths go through TRAMP."
  (let ((path (lsp--uri-to-path-1 uri)))
    (if-let* ((ws (car (lsp-workspaces)))
              (root (+ros-container-root (lsp--workspace-root ws)))
              ((not (string-prefix-p root path))))
        (concat "/podman:" (+ros-container-name root) ":" path)
      path)))

(defun +ros-container--derive-client (base-id server-id modes command-fn)
  "Register SERVER-ID as a copy of client BASE-ID that runs in the container."
  (when-let* ((base (gethash base-id lsp-clients)))
    ;; Slots are set via `cl-struct-slot-value' rather than `(setf
    ;; (lsp--client-...))': this file is macroexpanded at startup, before
    ;; lsp-mode (and so those accessors' setters) is loaded.
    (let ((client (copy-lsp--client base)))
      (pcase-dolist (`(,slot . ,value)
                     `((server-id . ,server-id)
                       (priority . 10)
                       (remote? . nil)
                       (download-server-fn . nil)
                       (new-connection . ,(+ros-container--connection command-fn))
                       (uri->path-fn . +ros-container--uri-to-path)
                       (activation-fn
                        . ,(lambda (file mode)
                             (and file (memq mode modes)
                                  (+ros-container-root (file-name-directory file)))))))
        (setf (cl-struct-slot-value 'lsp--client slot client) value))
      (lsp-register-client client))))

(after! lsp-clangd
  (+ros-container--derive-client
   'clangd 'ros-clangd '(c-mode c++-mode c-ts-mode c++-ts-mode)
   (lambda (root)
     ;; `colcon-compdb' (run by `cb' in the container) merges each package's
     ;; compile_commands.json into ROOT.
     `("clangd" ,(concat "--compile-commands-dir=" (directory-file-name root))
       ,@lsp-clients-clangd-args))))

(after! lsp-pyright
  (+ros-container--derive-client
   'pyright 'ros-basedpyright '(python-mode python-ts-mode)
   (lambda (_root)
     (cons (concat lsp-pyright-langserver-command "-langserver")
           lsp-pyright-langserver-command-args))))

;; Header/source files that only exist in the container (opened via xref from
;; the clients above) are references, not things to edit, and shouldn't spin
;; up a second server over TRAMP.
(defun +ros-container-system-file-p ()
  (when-let* ((file (buffer-file-name))
              ((equal (file-remote-p file 'method) "podman")))
    (member (file-remote-p file 'host) +ros-container--names)))

(add-hook! 'find-file-hook
  (defun +ros-container-system-file-h ()
    (when (+ros-container-system-file-p)
      (read-only-mode +1))))

(defadvice! +ros-container--skip-lsp-a (&rest _)
  "Don't start LSP in container system files."
  :before-until '(lsp lsp-deferred)
  (+ros-container-system-file-p))
