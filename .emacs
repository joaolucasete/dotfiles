(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("gnu" . "https://elpa.gnu.org/packages/"))
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(package-initialize)

;; ui
(tool-bar-mode -1)                              ;; disable toolbar
(menu-bar-mode -1)                              ;; disable menubar
(scroll-bar-mode -1)                            ;; disable scrollbar
(show-paren-mode 1)                             ;; show parent parentheses
(display-line-numbers-mode 1)                   ;; display line numbers
(setq-default display-line-numbers 'relative)   ;; display relative line number
(setq inhibit-startup-message t)                ;; disable startup screen
(setq x-select-enable-clipboard t)              ;; enable clipboard outside emacs
(setq ring-bell-function 'ignore)               ;; disable ring-bell
(defalias 'yes-or-no-p 'y-or-n-p)               ;; transform yes-or-no to y-or-n
(global-hl-line-mode t)                         ;; highlight current line
(setq scroll-conservatively 100)                ;; conservative scrolling
(global-prettify-symbols-mode t)                ;; prettify symbols mode

;; backups
(setq make-backup-files nil)                    ;; disable backup
(setq auto-save-default nil)                    ;; disable backup

(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            ))
(electric-pair-mode t)                          ;; enable bracket pair-matching

;; Creating a new window switches your cursor to it
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; resize bindings
(global-set-key (kbd "s-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<down>") 'shrink-window)
(global-set-key (kbd "s-C-<up>") 'enlarge-window)

;; org
(use-package org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            '(lambda ()
               (visual-line-mode 1))))

(use-package org-indent
  :diminish org-indent-mode)

(use-package htmlize
  :ensure t)

;; eshell
(setq eshell-prompt-regexp "^[^αλ\n]*[αλ] ")
(setq eshell-prompt-function
      (lambda nil
        (concat
         (if (string= (eshell/pwd) (getenv "HOME"))
             (propertize "~" 'face `(:foreground "#99CCFF"))
           (replace-regexp-in-string
            (getenv "HOME")
            (propertize "~" 'face `(:foreground "#99CCFF"))
            (propertize (eshell/pwd) 'face `(:foreground "#99CCFF"))))
         (if (= (user-uid) 0)
             (propertize " α " 'face `(:foreground "#FF6666"))
         (propertize " λ " 'face `(:foreground "#A6E22E"))))))

(setq eshell-highlight-prompt nil)
(defalias 'open 'find-file-other-window)
(defalias 'clean 'eshell/clear-scrollback)

(defun eshell/sudo-open (filename)
  "Open a file as root in Eshell."
  (let ((qual-filename (if (string-match "^/" filename)
                           filename
                         (concat (expand-file-name (eshell/pwd)) "/" filename))))
    (switch-to-buffer
     (find-file-noselect
      (concat "/sudo::" qual-filename)))))

;; use-package

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; treemacs
(use-package neotree
  :ensure t
  :config
  (setq-default neo-theme 'arrow)
  (global-set-key [f8] 'neotree-toggle))

(use-package diminish ;; hides minor modes
  :ensure t)

(use-package which-key ;; command tips
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))

 (use-package swiper ;; mini-buffer with results from C-s
	:ensure t
	:bind ("C-s" . 'swiper))

(use-package evil
  :ensure t
  :defer nil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
	'("a" "s" "d" "f" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))

(use-package ido
  :init
  (ido-mode 1)
  :config
  (setq ido-enable-flex-matching nil)
  (setq ido-create-new-buffer 'always)
  (setq ido-everywhere t))

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
; This enables arrow keys to select while in ido mode. If you want to
; instead use the default Emacs keybindings, change it to
; "'C-n-and-C-p-only"
(setq ido-vertical-define-keys 'C-n-C-p-up-and-down)

(use-package async
  :ensure t
  :init
  (dired-async-mode 1))

(use-package magit
  :ensure t)

(use-package eldoc
  :diminish eldoc-mode)

(use-package cyberpunk-theme
  :ensure t
  :init
  (load-theme 'cyberpunk t))

(use-package spaceline
  :ensure t)

(use-package powerline
  :ensure t
  :init
  (spaceline-spacemacs-theme)
  :hook
  ('after-init-hook) . 'powerline-reset)

;; modes
(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))


(use-package abbrev
  :diminish abbrev-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (neotree cyberpunk-theme powerline go-mode async ido-vertical-mode switch-window evil swiper which-key diminish htmlize use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
