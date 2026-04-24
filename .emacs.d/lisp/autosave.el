;;; autosave.el --- send autosave files to a central dir.
;;; Commentary:
;;   Emacs autosaves write `#foo#` next to `foo`. That pollutes project
;;   dirs and confuses file watchers. This file redirects autosaves into
;;   ~/.emacs_autosaves/ and tunes the save frequency.
;;
;;   Autosave != backup: autosaves protect against a crash between saves,
;;   backups (backup.el) protect against you overwriting good content.

;; Central dir for all autosave files. t = don't error if it already exists.
(defvar autosave-dir "~/.emacs_autosaves/")
(make-directory autosave-dir t)

;; Pattern Emacs uses to recognize an autosave file on disk ("#foo#").
;; Used when it needs to offer recovery after a crash.
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

;; Map a buffer's real filename to its autosave path in `autosave-dir`.
;; For unnamed buffers (no file), embed the buffer name instead.
(defun make-auto-save-file-name ()
  (concat autosave-dir
         (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
              (expand-file-name
             (concat "#%" (buffer-name) "#"))
            )
          )
  )

;; Delete the autosave file after a successful real save — the autosave's
;; job is done once the primary save landed.
(setq delete-auto-save-files t)
;; Enable autosave globally.
(setq auto-save-default t)
(setq auto-save-hash-p t)
(setq auto-save-file-format t)

;; Two independent autosave triggers; whichever hits first fires.
(setq auto-save-interval 100)  ;; after N keystrokes (busy typing)
(setq auto-save-timeout  400)  ;; after N seconds of idle

;;; autosave.el ends here
