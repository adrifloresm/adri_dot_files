;; Lisp Mode
(add-hook 'lisp-mode-hook '(lambda ()
  (setq indent-tabs-mode nil)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))
