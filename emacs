; -*- emacs-lisp -*-


(require 'package)
(let* ((no-ssl (not (gnutls-available-p)))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(package-initialize)
(elpy-enable)
(icomplete-mode)
(setq suggest-key-bindings 1)

(setq load-path 
      (append '("~/.dotfiles/elisp" "/usr/local/share/emacs/site-lisp") load-path))
(setq exec-path (append '("/usr/local/bin/") exec-path))

(if window-system
    (progn 
      (set-frame-size (selected-frame) 130 60)
      (set-frame-position (selected-frame) 200 40)
      (server-start)
      (define-key ctl-x-map "\C-c" 'nil)
      (define-key ctl-x-map "c" 'kill-emacs)
      (setq x-select-enable-clipboard t)
      (setq interprogram-paste-function 'x-selection-value)
					; (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
      (global-set-key (kbd "<M-up>") 'scroll-down-command)
      (global-set-key (kbd "<M-down>") 'scroll-up-command)
      )
  )

(require 'yaml-mode)

;  VERSION CONTROL  
(setq version-control t)
(setq trim-versions-without-asking t)
(setq delete-old-versions t)
(setq kept-old-versions 0)
(setq kept-new-versions 3)

(setq default-case-fold-search 1)
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
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(lsp-mode pyvenv tramp-theme python-mode python-docstring py-autopep8 magit go-mode flycheck exec-path-from-shell elpy))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(transient-mark-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "nil" :family "Menlo")))))
