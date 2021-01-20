;;; init.el --- Init for emacs
;;; Commentary: Ecamcs Startup file --- initialization for emacs

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General configuration ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; remove initial screen message
;;; Code:

(setq inhibit-startup-message t)

(scroll-bar-mode -1)  ;; Disable scrollbar
(tool-bar-mode -1)    ;; Disable the toolbar
(tooltip-mode -1)     ;; Disable tooltips

(menu-bar-mode -1)    ;; Hide menu bar

(setq visible-bell t) ;; Set up the visible bell

;; Require font-firacode installed in the system
;; Font
(set-face-attribute 'default nil :font "Fira Code Retina" :height 140)

(global-hl-line-mode 1)

;; Full Screen Mode
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(icomplete-mode t)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(package-selected-packages
   '(toml-mode flycheck-rust racer lsp-ui company-lsp lsp-mode flycheck go-mode yaml-mode cargo rust-mode ws-butler afternoon-theme helm ivy command-log-mode use-package)))

;; Backup Dir: Temp
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load Source Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Commentary:
;;

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-linux platform
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;
;; Theme ;;
;;;;;;;;;;;
(use-package afternoon-theme)
(load-theme 'afternoon t)

;;;;;;;;;;
;; HELM ;;
;;;;;;;;;;
(use-package helm
  :ensure t
  :demand
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
         ("C-x c o" . helm-occur))
         ("M-y" . helm-show-kill-ring)
         ("C-x r b" . helm-filtered-bookmarks)
	 :preface (require 'helm-config)
	 :config (helm-mode 1))

(setq helm-split-window-inside-p t
      helm-move-to-line-cycle-in-source t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;
;; Editor ;;
;;;;;;;;;;;;
(global-linum-mode 1)  ;; Show line number

(define-key global-map (kbd "RET") 'newline-and-indent) ;; autoindent

;; Highlight Matching Braces
(use-package paren
  :config
  (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
  (show-paren-mode 1))

;; Tab Widht
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; Spaces instead tabs
(setq-default indent-tabs-mode nil)

;; Clean Whitespace
(use-package ws-butler
  :hook ((text-mode . ws-butler-mode)
         (prog-mode . ws-butler-mode)))


;;;;;;;;;;;;;;;
;; LANGUAGES ;;
;;;;;;;;;;;;;;;

;; CHECK
(use-package flycheck)
(global-flycheck-mode)

;; SERVER PROTOCOL
(use-package lsp-mode
  :commands (lsp)
  :config
  (use-package company-lsp
    :config
    (add-to-list 'company-backends 'company-lsp)))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (define-key lsp-ui-mode-map
    [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map
    [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-sideline-enable nil
        lsp-ui-doc-enable t
        lsp-ui-imenu-enable t
        lsp-ui-sideline-ignore-duplicate t))

;; TOML
(use-package toml-mode)

;; RUST
(use-package rust-mode
  :mode "\\.rs\\'"
  :init (setq rust-format-on-save t))

(use-package cargo
  :defer t
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode))

(use-package company
  :config
  (setq company-idle-delay 1))

(use-package racer
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)
  :config
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (setq company-tooltip-align-annotations t))

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; MARKDOWN
(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-command "marked"))

;; YAML
(use-package yaml-mode
  :mode "\\.ya?ml\\'")

;; GOLANG
(use-package flycheck)
(use-package go-mode
  :config
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  (add-hook 'go-mode-hook 'company-mode)
  ;; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook #'lsp)
  (add-hook 'go-mode-hook #'flycheck-mode)
  (add-hook 'go-mode-hook '(lambda ()
                 (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))
  (add-hook 'go-mode-hook '(lambda ()
                 (local-set-key (kbd "C-c C-g") 'go-goto-imports)))
  (add-hook 'go-mode-hook (lambda ()
                (set (make-local-variable 'company-backends) '(company-go))
                (company-mode))))

;;; init.el ends here
