;; Python Mode
(add-hook 'python-mode-hook '(lambda ()
  (setq python-indent 2)
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))
