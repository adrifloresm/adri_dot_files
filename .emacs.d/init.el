0(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'whitespace)

(require 'graphviz-dot-mode)
(require 'markdown-mode)
;;(require 'protobuf-mode)
(require 'thrift-mode)

;; ========== Enable clipboard ==========
(setq x-select-enable-clipboard t)

;; ========== Highlight matching parentheis ==========
(show-paren-mode 1)
(setq show-paren-delay 0)

;; ========== Highlight current line ==========
(setq global-linum-mode t)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)


;; ========== Line by line scrolling ==========
(setq scroll-step 1)

;; ==========  ==========

(load "~/.emacs.d/lisp/ui.el")
(load "~/.emacs.d/lisp/keybindings.el")
(load "~/.emacs.d/lisp/functions.el")

(load "~/.emacs.d/lisp/autosave.el")
(load "~/.emacs.d/lisp/backup.el")

(load "~/.emacs.d/lisp/c-lang.el")
(load "~/.emacs.d/lisp/cpp-lang.el")
(load "~/.emacs.d/lisp/graphviz-dot-lang.el")
(load "~/.emacs.d/lisp/java-lang.el")
(load "~/.emacs.d/lisp/javascript-lang.el")
(load "~/.emacs.d/lisp/latex-lang.el")
(load "~/.emacs.d/lisp/lisp-lang.el")
(load "~/.emacs.d/lisp/markdown-lang.el")
(load "~/.emacs.d/lisp/octave-lang.el")
;;(load "~/.emacs.d/lisp/protobuf-lang.el")
(load "~/.emacs.d/lisp/python-lang.el")
(load "~/.emacs.d/lisp/shell-lang.el")
(load "~/.emacs.d/lisp/text-lang.el")
(load "~/.emacs.d/lisp/thrift-lang.el")
(load "~/.emacs.d/lisp/verilog-lang.el")
(load "~/.emacs.d/lisp/vhdl-lang.el")

(load "~/.emacs.d/lisp/google-c-style.el")

;; ========== Enable mouse wheel and buttons ==========
(require 'xt-mouse)
(xterm-mouse-mode)
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))

(setq mouse-wheel-follow-mouse 't)

(defvar alternating-scroll-down-next t)
(defvar alternating-scroll-up-next t)

(defun alternating-scroll-down-line ()
  (interactive "@")
  (when alternating-scroll-down-next
					;      (run-hook-with-args 'window-scroll-functions )
    (scroll-down-line))
  (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

(defun alternating-scroll-up-line ()
  (interactive "@")
  (when alternating-scroll-up-next
					;      (run-hook-with-args 'window-scroll-functions)
    (scroll-up-line))
  (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

(global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line)
