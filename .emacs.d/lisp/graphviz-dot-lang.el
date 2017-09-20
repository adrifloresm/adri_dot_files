;; GraphViz dot Mode
(add-hook 'graphviz-dot-mode-hook '(lambda ()
  (setq graphviz-dot-indent-width 2
	graphviz-dot-auto-indent-on-newline nil
        graphviz-dot-auto-indent-on-braces nil
	graphviz-dot-auto-indent-on-semi nil
	tab-width 2
        indent-tabs-mode nil)
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))

(setq auto-mode-alist (cons '("\\.dot\\'" . graphviz-dot-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.gv\\'" . graphviz-dot-mode) auto-mode-alist))
