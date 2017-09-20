(defvar autosave-dir "~/.emacs_autosaves/")
(make-directory autosave-dir t)
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
(defun make-auto-save-file-name ()
  (concat autosave-dir
         (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
              (expand-file-name
             (concat "#%" (buffer-name) "#"))
            )
          )
  )
(setq delete-auto-save-files t) ;after saved
(setq auto-save-default t)
(setq auto-save-hash-p t)
(setq auto-save-file-format t)
(setq auto-save-interval 100) ;keystrokes
(setq auto-save-timeout  400) ;seconds
