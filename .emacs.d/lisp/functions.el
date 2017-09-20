(defun the-previous-buffer ()
  "Switch to previous buffer"
  (interactive)
  (switch-to-buffer (car (last (buffer-list)))))

(defun next-user-buffer ()
  "Switch to the next user buffer in cyclic order."
  (interactive)
  (bury-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (<i 10))
      (setq i (1+ i)) (bury-buffer) )))

(defun previous-user-buffer ()
  "Switch to the previous user buffer in cyclic order."
  (interactive)
  (the-previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 10))
      (setq i (1+ i)) (the-previous-buffer) )))

(defun whitespace-cleanup-on-save ()
  "The cleans up the whitespace in the buffer"
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
)
