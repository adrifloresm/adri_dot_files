;;; keybindings.el --- global key bindings.
;;; Commentary:
;;   These override several Emacs defaults. Notable: C-u is rebound to
;;   undo (replacing the default `universal-argument`). If you depend on
;;   C-u <n> as a numeric-argument prefix, remap it to M-u or restore it.

;; ---- Editing ----
(global-set-key "\C-u" 'undo)          ;; non-standard: overrides universal-argument
(global-set-key "\M-s" 'save-buffer)   ;; Alt-s saves
(global-set-key "\M-o" 'find-file)     ;; Alt-o opens
(global-set-key "\C-v" 'yank)          ;; paste (overrides scroll-up-command)
(global-set-key "\M-u" 'upcase-word)
(global-set-key "\M-l" 'downcase-word)

;; ---- Windows (Emacs "frames split into windows") ----
(global-set-key "\M-0" 'delete-window)           ;; close this window
(global-set-key "\M-1" 'delete-other-windows)    ;; keep only this window
(global-set-key "\M-2" 'split-window-vertically)
(global-set-key "\M-3" 'split-window-horizontally)
(global-set-key "\M-g" 'goto-line)               ;; jump to line by number

;; ---- Buffer cycling ----
;; Alt-Left/Right cycle user buffers (see functions.el for how internal
;; `*Messages*`-style buffers are skipped).
(global-set-key (kbd "M-<left>")    'previous-user-buffer)
(global-set-key (kbd "M-<right>")   'next-user-buffer)
(global-set-key (kbd "M-C-<left>")  'the-previous-buffer)
(global-set-key (kbd "M-C-<right>") 'bury-buffer)
;; Ctrl-Tab: cycle through split windows within the frame.
(global-set-key (kbd "C-<tab>")     'next-multiframe-window)

;; ---- Window resize ----
;; Ctrl-Alt-Shift + Arrows resize the current window. Hold down to keep
;; resizing — each keypress adjusts by one row/column.
(global-set-key (kbd "C-M-S-<left>")  'shrink-window-horizontally)
(global-set-key (kbd "C-M-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-M-S-<up>")    'enlarge-window)
(global-set-key (kbd "C-M-S-<down>")  'shrink-window)

;;; keybindings.el ends here
