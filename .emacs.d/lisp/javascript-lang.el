;; Javascript mode
(add-hook 'js-mode-hook '(lambda ()
  (setq js-indent-level 2
        indent-tabs-mode nil)
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))
