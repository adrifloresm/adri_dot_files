;; MarkDown Mode
(add-hook 'markdown-mode-hook '(lambda ()
  (setq whitespace-style '(face empty tabs trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))

(setq auto-mode-alist (cons '("\\.markdown\\'" . markdown-mode) auto-mode-alist))

;; GitHub Flavored MarkDown Mode
(add-hook 'gfm-mode-hook '(lambda ()
  (setq whitespace-style '(face empty tabs trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))

;; Note: .md is ambiguous between regular markdown and github flavored markdown.
;;  I'm choosing to load github markdown by default since that is what I use it
;;  for most.
(setq auto-mode-alist (cons '("\\.md\\'" . gfm-mode) auto-mode-alist))

