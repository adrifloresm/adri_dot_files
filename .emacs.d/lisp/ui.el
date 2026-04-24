;;; ui.el --- visual appearance (colors, font, chrome).
;;; Commentary:
;;   Tweaks that affect what the editor *looks* like. Loaded early from
;;   init.el so subsequent modules inherit the color scheme.

;; High-contrast black-on-white-reversed theme. If you install a full
;; color theme (e.g. `load-theme 'solarized`), remove these two lines so
;; they don't fight it.
(set-foreground-color "white")
(set-background-color "black")

;; Hide the toolbar in GUI Emacs — keyboard-driven users don't use it and
;; it eats vertical space. `display-graphic-p` is t for X/Wayland/macOS
;; frames, nil for `emacs -nw` terminal frames.
(when (display-graphic-p)
  (tool-bar-mode 0))

;; Hide the menu bar only in terminal Emacs (it looks ugly there and wastes
;; a row). Keep it in GUI frames where it's expected.
(unless (display-graphic-p)
  (menu-bar-mode 0))

;; Show the current line / column in the mode line.
(line-number-mode 1)
(column-number-mode 1)

;; Don't wrap long lines — scroll horizontally instead. Better for code
;; with long literals and for reading log files.
(set-default 'truncate-lines t)

;; Default font size. Height is in 1/10 pt units, so 105 = 10.5pt. Bump to
;; ~120 on high-DPI displays.
(set-face-attribute 'default nil :height 105)

;; Kill the startup splash so Emacs drops you straight into *scratch* on
;; launch. Empty scratch message avoids the lisp-interaction blurb.
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; `bs-show` is a lightweight buffer switcher (alternative to ibuffer).
;; Bound to C-x RET here. Inside the menu, press `a` to see internal
;; *starred* buffers too. Customize with M-x bs-customize.
(require 'bs)
(global-set-key "\C-x\m" 'bs-show)

;;; ui.el ends here
