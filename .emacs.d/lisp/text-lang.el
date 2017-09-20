;; LaTeX Mode
(add-hook 'text-mode-hook '(lambda ()
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs trailing))
  (whitespace-mode t)
  ;;(add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  (add-hook 'text-mode-hook 'turn-on-visual-line-mode)
  (visual-line-mode t)
  ))

;;(setq visual-line-mode t)
