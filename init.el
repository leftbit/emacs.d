(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))

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

(setq make-backup-files nil) ;; stop creating those backup~ files
(setq auto-save-default nil) ;; stop creating those #autosave# files

;; ==================================================
;; ui
(blink-cursor-mode 0)
(set-frame-font "Fira Code Medium" nil t)
(set-face-attribute 'default nil :height 140)
(load-theme 'solarized-light t)
(setq initial-frame-alist '((top . 0) (left . 0) (width . 100) (height . 28)))
;; Turn off the menu bar at the top of each frame because it's distracting
(menu-bar-mode -1)
;; Show line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; remove the graphical toolbar
(when (fboundp 'tool-bar-mode)
   (tool-bar-mode -1))
;; Don't show native OS scroll bars for buffers because they're redundant
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
;; Keinen Splash-Screen
(setq inhibit-splash-screen t)
(find-file "~/Dokumente/org/notes.org")

;; ==================================================
;; This assumes you've installed the package via MELPA.
(use-package ligature
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

;; ==================================================
;; support for markdown
(use-package markdown-mode :ensure t)

;; ==================================================
;; ido/smex
(ido-mode t)
(setq ido-enable-flex-matching t) ;; fuzzy matching is a must have
(setq ido-enable-last-directory-history nil) ;; forget latest selected directory names

(use-package smex
  :ensure t
  :bind (("M-x" . smex))
  :config (smex-initialize))

;; SMEX
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command) ;; This is your old M-x:

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
;  :pin melpa-stable
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
      '(("b" "Bookmark" entry (file+headline "~/Dokumente/org/notes.org" "Bookmarks")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)
        ("t" "Todo" entry (file+headline "~/Dokumente/org/inbox.org" "Tasks")
         "* TODO %?\n  %i\n  %a")))
(setq org-todo-keywords
      '((sequence "TODO(t)" "IN-PROGRESS(i@/!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))
(setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "GoldenRod" :weight bold))
        ("IN-PROGRESS" . (:foreground "DeepPink" :weight bold))
        ("BLOCKED" . (:foreground "Red" :weight bold))
        ("DONE" . (:foreground "LimeGreen" :weight bold))
        ("OBE" . (:foreground "LimeGreen" :weight bold))
        ("WONT-DO" . (:foreground "LimeGreen" :weight bold))
        ))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

;; =====
;; lisp
; (load (expand-file-name "~/.quicklisp/slime-helper.el"))
; (setq inferior-lisp-program "sbcl")

;; rest
(add-hook 'emacs-startup-hook 'treemacs)

;; Auto added - do not touch!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(ligature treemacs-magit treemacs-projectile lsp-treemacs treemacs use-package solarized-theme which-key ag magit counsel aggressive-indent smartparens clj-refactor company rainbow-delimiters clojure-mode-extra-font-locking projectile zenburn-theme smex cider org-bullets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
