;;; functions.el --- small helper commands for buffer cycling + cleanup.
;;; Commentary:
;;   Loaded from init.el. All functions here are `interactive` and intended
;;   to be bound to keys in keybindings.el.

;; Jump to the buffer at the *back* of the buffer list — i.e. the one you
;; last left via bury-buffer. Useful as a "last visited" toggle.
(defun the-previous-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (car (last (buffer-list)))))

;; Cycle forward through user buffers, skipping Emacs's internal ones
;; (whose names start with `*`, e.g. *Messages*, *scratch*, *Help*).
;; The (< i 10) guard caps the skip at 10 bury calls so we can't get
;; stuck in an infinite loop if every buffer is internal.
(defun next-user-buffer ()
  "Switch to the next user buffer in cyclic order."
  (interactive)
  (bury-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 10))
      (setq i (1+ i)) (bury-buffer) )))

;; Same idea, reversed direction. Walks backward via `the-previous-buffer`.
(defun previous-user-buffer ()
  "Switch to the previous user buffer in cyclic order."
  (interactive)
  (the-previous-buffer)
  (let ((i 0))
    (while (and (string-match "^*" (buffer-name)) (< i 10))
      (setq i (1+ i)) (the-previous-buffer) )))

;; Normalize whitespace on save: convert tabs to spaces and strip trailing
;; whitespace. Invoked via before-save-hook in backup.el or a language hook.
(defun whitespace-cleanup-on-save ()
  "Clean up whitespace in the current buffer: untabify + strip trailing."
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
)

;;; functions.el ends here
