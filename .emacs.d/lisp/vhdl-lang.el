;; VHDL Mode
(add-hook 'vhdl-mode-hook '(lambda ()
  (setq vhdl-clock-edge-condition (quote function))
  (setq vhdl-clock-name "clk")
  (setq vhdl-inline-comment-column 10)
  (setq vhdl-prompt-for-comments nil)
  (setq vhdl-reset-active-high t)
  (setq vhdl-reset-kind (quote sync))
  (setq vhdl-reset-name "rst")
  (setq vhdl-self-insert-comments nil)
  (setq comment-style 'plain)
  (setq auto-mode-alist (cons '("\\.vho\\'" . vhdl-mode) auto-mode-alist))
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))