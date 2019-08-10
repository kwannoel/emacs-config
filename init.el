(require 'package)
;; Work-around for gnu currently down for emacs 26.1
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Personal details
(setq user-full-name "Noel Kwan"
      user-mail-address "noelkwan1998@gmail.com")

;; Removing extras
(tooltip-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Misc preferences
(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode +1)

;; emacs-daemon uses the same emacs instance
(setq create-lockfiles nil)
;; Not working
;; (add-to-list 'default-frame-alist
;;             '(font . "Fira Code-12"))

;; Feed generated code into here
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Push backup files in to /tmp
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; use shift-dirKeys to toggles windows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Install use-package if isn't installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Configure use-package
(require 'use-package)
(defvar use-package-verbose t)
(setq use-package-always-ensure t)

;; Always demand if daemon-mode
(setq use-package-always-demand (daemonp))

;; Use these packages
(use-package undo-tree)
;; Use vi bindings
(use-package evil
  :init
  (evil-mode 1))
(use-package pdf-tools) 
(use-package cl-lib) ;; common lisp
(use-package bind-key) ;; Key-binding manager
(use-package diminish) ;; Shorten mode-desc
(use-package bury-successful-compilation ;; If compilation success hide message buffer
  :hook
  (prog-mode . bury-successful-compilation))
(use-package which-key
  :init
  (which-key-mode))

;; Unsure if need the following
;; (bind-key (remap save-buffers-kill-terminal) 'save-buffers-kill-emacs)

;; use custom theme
(use-package ample-theme
  :init
  (load-theme 'ample-flat t))

;; Revert git buffers if branches change
(use-package autorevert
  :ensure f
  :diminish t
  :hook
  (dired-mode . auto-revert-mode)
  :config
  (global-auto-revert-mode +1)
  :custom
  (auto-revert-verbose nil))
