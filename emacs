; -*- emacs-lisp -*-

(setq suggest-key-bindings 1)
(tool-bar-mode -1)

; set a few varibles based on the user environment

; add in a local
(setq load-path 
      (append 
       '(
 	 "~/.dotfiles/elisp"
	 "~/.dotfiles/elisp/tramp/lisp"
	 "/usr/local/share/emacs/site-lisp"
	 ) 
       load-path)
      )

(if window-system
    (progn 
;      (server-start)
      (define-key ctl-x-map "\C-c" 'nil)
      (define-key ctl-x-map "c" 'kill-emacs)
      (setq x-select-enable-clipboard t)
      (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
      )
)

;; Set up my backspace if I'm typing on an IBM keyboard
(setq term (getenv "TERM"))
(if (and (member term '("aixterm" "hft" "screen" "xterm" "vt100"))
	 (not window-system))
    (progn
      (keyboard-translate ?\C-h ?\C-?)
      (global-set-key "\M-?" 'help-command)
      (global-unset-key "\C-z")))

(require 'sje-switch-buffer)
(define-key ctl-x-map "b" 'sje-iswitch)
(define-key ctl-x-map "y" 'bury-buffer)

(autoload 'python-mode "python-mode" "Python editing mode." t)
(autoload 'ksh-mode "ksh-mode" "Ksh shell-script mode" t)

(setq auto-mode-alist
      (append auto-mode-alist
			  (list
			   '("python" . python-mode)
			   '("\\.py$" . python-mode)
			   '("\\.sh$" . ksh-mode)
			   '("\\.ksh$" . ksh-mode)
			   '("\\.bashrc" . ksh-mode)
			   '("\\.xpi" . archive-mode)
			   '("\\..*profile" . ksh-mode))))

;  VERSION CONTROL  
; Another nice feature of emacs.  After every session of editting 
; a file, the versions are created using the general form:
;       filename.~n~
; where "n" is an integer, one greater than the last created
; version.  The settings below keep the first 10 versions, 
; and the last 10 versions.
(setq version-control t)
(setq trim-versions-without-asking t)
(setq delete-old-versions t)
(setq kept-old-versions 3)
(setq kept-new-versions 3)

(setq default-case-fold-search 1)

;; font-lock whenever possible
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode 1)
  ;; xemacs has defaults set up ok, but needs explicit loading
  (require 'font-lock))

;; (require 'mmm-auto)
;; (setq mmm-global-mode 'maybe)
;; (mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)

(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)

(defun db-eng ()
  ( interactive )
  ( setq sql-user "nmsWrite" )
  ( setq sql-server "engdb.wldblu.net" )
  ( setq sql-database "sysconfig" )
  ( sql-mysql )
  ( sql-set-sqli-buffer-generally ) )

(mouse-wheel-mode t)

(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(tool-bar-mode nil)
 '(transient-mark-mode (quote (only . t))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el

