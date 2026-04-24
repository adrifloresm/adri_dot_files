;;; backup.el --- numbered, centralized backup policy.
;;; Commentary:
;;   By default Emacs writes `foo~` next to `foo` on save. That clutters
;;   project dirs and can confuse build/watch tools. Here we redirect all
;;   backups into ~/.emacs_backups/ and keep many numbered versions so
;;   "save early, save often" actually produces an undo history on disk.

;; Turn on numbered backups at all.
(setq make-backup-files t)

;; Centralize them under ~/.emacs_backups/foo.~N~
(defvar backup-dir "~/.emacs_backups/")
(make-directory backup-dir t)  ;; t = no error if it already exists
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Numbered versions (foo.~1~, foo.~2~, ...) instead of one generic foo~.
(setq version-control t)
;; Keep the 50 most-recent versions per file.
(setq kept-new-versions 50)
;; 'Leave = never auto-delete old versions (let the user prune manually).
;; This overrides `kept-new-versions`' implicit delete-old behavior.
(setq delete-old-versions 'Leave)

;; Force a *new* backup on every save instead of only on the first save of
;; a session. Uses `before-save-hook` (the modern replacement for the
;; obsolete `write-file-hooks`).
(add-hook 'before-save-hook
          (lambda ()
            (setq buffer-backed-up nil)  ;; trick Emacs into re-backing up
            (time-stamp)))               ;; fill in `Time-stamp: <>` markers

;; By default Emacs skips backups for version-controlled files (since git
;; is "backup enough"). We keep them anyway so an accidental staged
;; revert still has an Emacs-side numbered copy.
(add-hook 'vc-hook
          (lambda ()
            (setq vc-make-backup-files t)
            (setq vc-delete-automatic-version-backups nil)))

;;; backup.el ends here
