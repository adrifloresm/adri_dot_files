;; Foreground & Background
(set-foreground-color "white")
(set-background-color "black")

;; Hide the Emacs Toolbar if in graphically mode
(when (display-graphic-p)
  (tool-bar-mode 0))

;; Hide the Emacs Menubar if not in graphical mode
(unless (display-graphic-p)
  (menu-bar-mode 0))

;; Enable line and column numbering
(line-number-mode 1)
(column-number-mode 1)

;; Truncate long lines
(set-default 'truncate-lines t)

;; Font
(set-face-attribute 'default nil :height 105)

;; get rid of lame startup screens
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Better buffer switching
;; M-x bs-customize to customize
;; press "a" in minibuffer to show all
(require 'bs)
(global-set-key "\C-x\m" 'bs-show)
