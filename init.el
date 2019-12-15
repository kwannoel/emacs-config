(require 'package)
;; Work-around for gnu currently down for emacs 26.1
;; package-refresh-contents to update archives
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Personal details
(setq user-full-name "Noel Kwan"
      user-mail-address "noelkwan1998@gmail.com")

(tooltip-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

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
(use-package ag)
(use-package undo-tree)
;; Use vi bindings
(use-package evil
  :init
  (evil-mode 1))

(use-package rainbow-delimiters)
(use-package pdf-tools) 
;; (use-package haskell-mode)
(use-package cl-lib) ;; common lisp
(use-package bind-key) ;; Key-binding manager
(use-package diminish) ;; Shorten mode-desc
(use-package bury-successful-compilation ;; If compilation success hide message buffer
  :hook
  (prog-mode . bury-successful-compilation))
(use-package which-key
  :init
  (which-key-mode))

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode))
)

(use-package cl-lib) ;; common lisp

(use-package intero)

(use-package rust-mode)
(use-package company)
(use-package racer)
(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
;; Rust source code PATH
(setq racer-rust-src-path 
      "~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(use-package flycheck-rust)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(use-package nix-mode)

(use-package tide)
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

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

(org-babel-do-load-languages
 'org-babel-load-languages
 '((js . t)
   (emacs-lisp . t)
   (haskell . t)))
