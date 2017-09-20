;; backups occur each time you save
(setq make-backup-files t)
(defvar backup-dir "~/.emacs_backups/")
(make-directory backup-dir t)
(setq backup-directory-alist (list (cons "." backup-dir)))
(setq version-control t) ;; don't overwrite backups, number them !!!
(setq kept-new-versions 50)
(setq delete-old-versions 'Leave) ;; probably overrides kept-new-versions
(add-hook 'write-file-hooks
          '(lambda ()
             (setq buffer-backed-up nil) ;; force backup creation on EVERY save!
             (time-stamp)))              ;; Time-stamp: <>
;; vc-make-backup-files overrides backing up for version controlled files
(add-hook 'vc-hook
          '(lambda ()
             (setq vc-make-backup-files t)
             (setq vc-delete-automatic-version-backups nil)))
