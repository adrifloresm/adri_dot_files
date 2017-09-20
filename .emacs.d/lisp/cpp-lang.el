;; C++ Mode
(add-hook 'c++-mode-hook '(lambda ()
  (setq c-basic-offset 2
        tab-width 2
        indent-tabs-mode nil)
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))

(setq auto-mode-alist (cons '("\\.cc\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.h\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tcc\\'" . c++-mode) auto-mode-alist))

(add-hook 'c-mode-common-hook 'google-set-c-style)
