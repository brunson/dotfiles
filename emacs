; -*- emacs-lisp -*-

(electric-pair-mode t)
(setq suggest-key-bindings 1)
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(1
				  ((shift) . 2)
				  ((control) . 4)))
(if (functionp 'global-eldoc-mode) (global-eldoc-mode 0))

(setq exec-path (append exec-path '("/usr/local/bin")))

(require 'package) ;; You might already have this line
(package-initialize) 

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

(if window-system
    (set-frame-height (selected-frame) 60)
  (progn 
    (server-start)
    (define-key ctl-x-map "\C-c" 'nil)
    (define-key ctl-x-map "c" 'kill-emacs)
    (setq x-select-enable-clipboard t)
    (setq interprogram-paste-function 'x-selection-value)
    (global-set-key (kbd "<M-up>") 'scroll-down-command)
    (global-set-key (kbd "<M-down>") 'scroll-up-command)
    )
  )

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(require 'sje-switch-buffer)
(define-key ctl-x-map "b" 'sje-iswitch)
(define-key ctl-x-map "y" 'bury-buffer)

;  VERSION CONTROL  
(setq version-control t)
(setq trim-versions-without-asking t)
(setq delete-old-versions t)
(setq kept-old-versions 3)
(setq kept-new-versions 3)

(setq default-case-fold-search 1)

;; (if (functionp 'mouse-wheel-mode) (mouse-wheel-mode t))
(setq load-home-init-file t) ; don't load init file from ~/.xemacs/init.el
(put 'dired-find-alternate-file 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'eval-expression 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-mode pyvenv tramp-theme python-mode python-docstring py-autopep8 magit go-mode flycheck exec-path-from-shell elpy))
 '(show-paren-mode t)
 '(size-indication-mode t)
 ; '(tool-bar-mode nil)
 '(transient-mark-mode nil))

(cond
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (custom-set-faces
     '(default ((t (:inherit nil :stipple nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Menlo")))))))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(default ((t (:inherit nil :stipple nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "MONO" :family "Andale Mono"))))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Menlo")))))
