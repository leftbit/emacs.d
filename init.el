(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

(prefer-coding-system 'utf-8-unix)

;; ==================================================
;; ui
(blink-cursor-mode 0)
(set-face-attribute 'default nil :height 140)
(load-theme 'solarized-light t)
(setq initial-frame-alist '((top . 0) (left . 0) (width . 120) (height . 33)))
;; Turn off the menu bar at the top of each frame because it's distracting
(menu-bar-mode -1)
;; Show line numbers
(global-linum-mode)
;; remove the graphical toolbar
(when (fboundp 'tool-bar-mode)
   (tool-bar-mode -1))
;; Don't show native OS scroll bars for buffers because they're redundant
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; ==================================================
;; fira font
;; Siehe https://github.com/tonsky/FiraCode/wiki/Emacs-instructions
;; https://github.com/jming422/fira-code-mode
;; https://github.com/tonsky/FiraCode
(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x")) ;; List of ligatures to turn off
  :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes
;; ==================================================
;; support for markdown
(use-package markdown-mode :ensure t)
;; ==================================================
;; company-mode
(use-package company
  :ensure t
  :init (global-company-mode t)
  :config
  (setq company-idle-delay nil)
  (global-set-key (kbd "M-TAB") #'company-complete)
  (global-set-key (kbd "TAB") #'company-indent-or-complete-common))
;; ==================================================
;; shows which keys can be pressed after an initial keystroke
(use-package which-key :ensure t :init (which-key-mode))

;; ==================================================
;; aggressive-indent
(use-package aggressive-indent)

;; ==================================================
;; clj-refactor
(require 'clj-refactor)
(defun my-clojure-refactor-mode-hook ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1) ; for adding require/use/import statements
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
    (cljr-add-keybindings-with-prefix "C-c C-m"))


;; ==================================================
;; clojure-mode
(use-package clojure-mode
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.edn\\'" . clojure-mode))
  :init
  (add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'smartparens-strict-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook #'my-clojure-refactor-mode-hook)
  (require 'clojure-mode-extra-font-locking))

;; ==================================================
;; cider
(use-package cider
  :ensure t
  :pin melpa-stable
  :init
  (add-hook 'cider-repl-mode-hook #'subword-mode)
  (add-hook 'cider-repl-mode-hook #'smartparens-strict-mode)
  (add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'cider-repl-mode-hook #'aggressive-indent-mode)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (setq cider-repl-wrap-history t)
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  (setq cider-save-file-on-load t)
  (setq cider-font-lock-dynamically '(macro core function var)))

;; ==================================================
;; ivy / counsel
;; Siehe https://oremacs.com/swiper/
(use-package ivy :ensure t
  :bind (("\C-s" . 'swiper))
  :init (ivy-mode))
(use-package counsel :after (ivy))

;; ==================================================
;; projectile
;; Siehe https://projectile.mx/g
(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
	      ("C-c p" . projectile-command-map)))

;; Fancy project tree
(use-package treemacs :ensure t)
(use-package lsp-treemacs :ensure t)
(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)
(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; ==================================================
;; magit
(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-x M-g" . magit-dispatch)))

;; ==================================================
;; smartparens
(require 'smartparens-config)
(sp-pair "'" nil :actions :rem)
(sp-pair "\\\"" nil :actions :rem)

;;=============================================================================
;; org-mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-switchb)
(setq org-directory "~/org")
(setq org-log-done t)
(setq org-agenda-start-on-weekday 1)
(setq org-default-notes-file "~/Dokumente/org/notes.org")
(setq org-agenda-files
      (directory-files-recursively "~/Dokumente/org/" "\\.org$"))
(setq org-file-apps
      '(("\\.docx\\'" . default)
	("\\.pdf\\'" . default)
        (auto-mode . emacs)))
(setq org-capture-templates
      '(("b" "Bookmark" entry (file+headline "~/org/notes.org" "Bookmarks")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)))



;; Auto added - do not touch!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(treemacs-magit treemacs-projectile lsp-treemacs treemacs use-package solarized-theme fira-code-mode which-key ag magit counsel aggressive-indent smartparens clj-refactor company rainbow-delimiters clojure-mode-extra-font-locking projectile zenburn-theme smex cider)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
