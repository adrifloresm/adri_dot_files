;; ProtoBuf Mode
(add-hook 'protobuf-mode-hook '(lambda ()
  (setq c-basic-offset 2
        tab-width 2
        indent-tabs-mode nil)
  (setq whitespace-line-column 80
        whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t)
  (add-hook 'local-write-file-hooks 'whitespace-cleanup-on-save)
  ))

(setq auto-mode-alist (cons '("\\.proto\\'" . protobuf-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pb\\'" . protobuf-mode) auto-mode-alist))

(add-hook 'c-mode-common-hook 'google-set-c-style)
