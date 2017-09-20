;; Shell Script Mode
(add-hook 'shell-script-mode-hook '(lambda ()
  ; no indent ???
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))
