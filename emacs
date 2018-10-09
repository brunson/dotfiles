; -*- emacs-lisp -*-

(setq suggest-key-bindings 1)
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(1
				  ((shift) . 2)
				  ((control) . 4)))
(tool-bar-mode -1)

(setq exec-path (append exec-path '("/usr/local/bin")))

(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) 
(tool-bar-mode -1)

; python-mode
(setq py-install-directory "~/.emacs.d/python-mode")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)

; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; don't split windows
(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)

(tool-bar-mode -1)

;add in a local
(setq load-path 
      (append 
       '(
 	 "~/.dotfiles/elisp"
	 "~/.dotfiles/elisp/tramp/lisp"
	 "/usr/local/share/emacs/site-lisp"
	 ) 
       load-path)
      )

(setq exec-path (append '("/usr/local/bin/") exec-path))

(if window-system
    (progn 
      (server-start)
      (define-key ctl-x-map "\C-c" 'nil)
      (define-key ctl-x-map "c" 'kill-emacs)
      (setq x-select-enable-clipboard t)
      (setq interprogram-paste-function 'x-selection-value)
      (global-set-key (kbd "<M-up>") 'scroll-down-command)
      (global-set-key (kbd "<M-down>") 'scroll-up-command)
;      (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
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
			   '("\\.pp$" . ruby-mode)
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

(mouse-wheel-mode t)
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el
(put 'dired-find-alternate-file 'disabled nil)
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck exec-path-from-shell python-docstring py-autopep8 elpy python-mode go-mode tramp-theme magit)))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode nil))

(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (message "Microsoft Windows")))
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (custom-set-faces
     '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Menlo")))))))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 143 :width normal :foundry "MONO" :family "Andale Mono"))))))))
