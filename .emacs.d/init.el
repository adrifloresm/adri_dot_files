;;; init.el --- Emacs top-level init, loaded once at startup.
;;; Commentary:
;;   Sets global behavior (clipboard, line numbers, highlights, scroll) and
;;   then `load`s smaller config files from ~/.emacs.d/lisp/. Splitting by
;;   topic/language makes it easier to turn features on/off without grepping
;;   a monolithic file.

;; Add our lisp/ dir to `load-path` so `(require 'foo)` finds foo.el there.
;; Without this, Emacs only searches the built-in package dirs.
(add-to-list 'load-path "~/.emacs.d/lisp")

;; whitespace-mode: visually highlights tabs, trailing spaces, etc.
;; Loaded here; turned on per-language in lisp/*-lang.el.
(require 'whitespace)

;; Third-party major modes vendored into lisp/.
(require 'graphviz-dot-mode)   ;; .dot Graphviz source
(require 'markdown-mode)       ;; .md / .markdown
;;(require 'protobuf-mode)     ;; disabled — re-enable if you edit .proto
(require 'thrift-mode)         ;; Apache Thrift IDL

;; ========== Clipboard integration ==========
;; Share the system clipboard with Emacs's kill ring so C-w / M-w / C-y
;; round-trip with other GUI apps.
(setq x-select-enable-clipboard t)

;; In terminal Emacs on WSL2, the setting above is a no-op (no X selection).
;; Pipe cut/copy through clip.exe so M-w / C-w also reach the Windows clipboard.
(when (and (not (display-graphic-p))
           (executable-find "clip.exe"))
  (defun wsl-copy-to-clipboard (text &optional _push)
    "Send TEXT to the Windows clipboard via clip.exe."
    (let ((process-connection-type nil))
      (let ((p (start-process "clip" nil "clip.exe")))
        (process-send-string p text)
        (process-send-eof p))))
  (setq interprogram-cut-function #'wsl-copy-to-clipboard))

;; ========== Matching parentheses ==========
;; Highlight the paren matching point's paren. Delay 0 = highlight instantly
;; (default 0.125s feels laggy when navigating lisp).
(show-paren-mode 1)
(setq show-paren-delay 0)

;; ========== Line numbers + current-line highlight ==========
;; Modern replacement for the deprecated `linum-mode` (slow on large files).
;; `display-line-numbers-mode` is native C, much faster.
;;
;; Historical note: the original line `(setq global-linum-mode t)` was a
;; no-op — setting a mode's *variable* doesn't activate it; you need to
;; call the function. Fixed here.
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#3e4446")  ;; dark gray; readable on black bg
(set-face-foreground 'highlight nil)      ;; keep foreground color intact

;; ========== Smooth scrolling ==========
;; Scroll one line at a time instead of jumping half-a-screen when the
;; cursor leaves the visible region.
(setq scroll-step 1)

;; ========== Load split config files ==========
;; UI tweaks, key bindings, helper defuns.
(load "~/.emacs.d/lisp/ui.el")
(load "~/.emacs.d/lisp/keybindings.el")
(load "~/.emacs.d/lisp/functions.el")

;; Autosave + backup policy (keeps clutter out of project dirs).
(load "~/.emacs.d/lisp/autosave.el")
(load "~/.emacs.d/lisp/backup.el")

;; Per-language settings (indent width, whitespace flags, hooks).
(load "~/.emacs.d/lisp/c-lang.el")
(load "~/.emacs.d/lisp/cpp-lang.el")
(load "~/.emacs.d/lisp/graphviz-dot-lang.el")
(load "~/.emacs.d/lisp/java-lang.el")
(load "~/.emacs.d/lisp/javascript-lang.el")
(load "~/.emacs.d/lisp/latex-lang.el")
(load "~/.emacs.d/lisp/lisp-lang.el")
(load "~/.emacs.d/lisp/markdown-lang.el")
(load "~/.emacs.d/lisp/octave-lang.el")
;;(load "~/.emacs.d/lisp/protobuf-lang.el")  ;; disabled; protobuf-mode require is also disabled above
(load "~/.emacs.d/lisp/python-lang.el")
(load "~/.emacs.d/lisp/shell-lang.el")
(load "~/.emacs.d/lisp/text-lang.el")
(load "~/.emacs.d/lisp/thrift-lang.el")
(load "~/.emacs.d/lisp/verilog-lang.el")
(load "~/.emacs.d/lisp/vhdl-lang.el")

;; Google's C/C++ style guide — loaded last so it can override c-lang.el.
(load "~/.emacs.d/lisp/google-c-style.el")

;; ========== Mouse wheel in terminal Emacs ==========
;; xt-mouse + xterm-mouse-mode teach Emacs to interpret xterm mouse escape
;; sequences (so you get mouse support in `emacs -nw`). `mouse` is the GUI
;; mouse package; loading both covers terminal + GUI invocations.
(require 'xt-mouse)
(xterm-mouse-mode)
(require 'mouse)
(xterm-mouse-mode t)
;; Stub: some old xterm-mouse code calls (track-mouse ...); provide a no-op
;; so we don't crash on those frames.
(defun track-mouse (e))

;; Scroll the window that contains the mouse pointer, not the focused one.
(setq mouse-wheel-follow-mouse 't)

;; ---- Alternating-scroll debounce ----
;; Some terminal emulators emit two mouse-4/mouse-5 events per physical
;; wheel "tick", which makes scrolling feel twice as fast as expected.
;; The two flags below skip every other event, effectively halving the
;; wheel speed. Toggle them and re-eval if your terminal already sends
;; one event per tick (then scrolling will feel sluggish — just remove
;; the `when` guard).
(defvar alternating-scroll-down-next t)
(defvar alternating-scroll-up-next t)

(defun alternating-scroll-down-line ()
  "Scroll down one line, but only on every other wheel event."
  (interactive "@")
  (when alternating-scroll-down-next
    (scroll-down-line))
  (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

(defun alternating-scroll-up-line ()
  "Scroll up one line, but only on every other wheel event."
  (interactive "@")
  (when alternating-scroll-up-next
    (scroll-up-line))
  (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

;; In xterm mouse mode, wheel-up = mouse-4, wheel-down = mouse-5.
(global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line)

;;; init.el ends here
