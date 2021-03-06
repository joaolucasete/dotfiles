(require 'package)
(setq package-archives nil)
(setq package-enable-at-startup nil)
(package-initialize)

;; ui
(tool-bar-mode -1)                              ;; disable toolbar
(menu-bar-mode -1)                              ;; disable menubar
(scroll-bar-mode -1)                            ;; disable scrollbar
(fringe-mode 1)                                 ;; shrink fringes
(show-paren-mode 1)                             ;; show parent parentheses
(global-hl-line-mode t)                         ;; highlight current line
(setq inhibit-startup-message t)                ;; disable startup screen
(setq x-select-enable-clipboard t)              ;; enable clipboard outside emacs
(setq ring-bell-function 'ignore)               ;; disable ring-bell
(defalias 'yes-or-no-p 'y-or-n-p)               ;; transform yes-or-no to y-or-n
(setq scroll-conservatively 100)                ;; conservative scrolling
(global-prettify-symbols-mode t)                ;; prettify symbols mode

;; line numbers
(display-line-numbers-mode 1)                   ;; show line numbers
(setq-default display-line-numbers 'relative)   ;; set them to be relative

;; backups
(setq make-backup-files nil)                    ;; disable backup
(setq auto-save-default nil)                    ;; disable backup

;; enable bracket pair-matching
(setq electric-pair-pairs '((?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")))
(electric-pair-mode t)

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
(global-set-key (kbd "s-C-<right>") 'shrink-window-horizontally)
(global-set-key (kbd "s-C-<left>") 'enlarge-window-horizontally)
(global-set-key (kbd "s-C-<up>") 'shrink-window)
(global-set-key (kbd "s-C-<down>") 'enlarge-window)

;; transpose lines
(defun my/move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun my/move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key [(control shift up)]  'my/move-line-up)
(global-set-key [(control shift down)]  'my/move-line-down)

;; org
(use-package org
  :config

  (use-package org-indent
    :diminish org-indent-mode)

  (use-package htmlize :ensure t)

  (use-package ox-hugo :ensure t
    :after ox)
  
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((scheme . t)))
  
  (setq org-log-done 'time)
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            '(lambda ()
               (visual-line-mode 1))))

;; eshell
(setq eshell-prompt-regexp "^[^????\n]*[????] ")
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
             (propertize " ?? " 'face `(:foreground "#FF6666"))
         (propertize " ?? " 'face `(:foreground "#FF1493"))))))

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

(defun eshell-other-window ()
  "Create or visit an eshell buffer."
  (interactive)
  (if (not (get-buffer "*eshell*"))
      (progn
        (split-window-sensibly (selected-window))
        (other-window 1)
        (eshell))
    (switch-to-buffer-other-window "*eshell*")))

(global-set-key (kbd "<s-C-return>") 'eshell-other-window)

(use-package exec-path-from-shell :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package neotree :ensure t
  :config
  (setq-default neo-theme 'arrow)
  (global-set-key [f8] 'neotree-toggle))

(use-package magit :ensure t)    ;; it's git magic
(use-package diminish :ensure t ) ;; hides minor modes

(use-package which-key :ensure t ;; command tips
  :diminish which-key-mode
  :init
  (which-key-mode))

(use-package swiper :ensure t;; mini-buffer with results from C-s
  :bind ("C-s" . 'swiper))

(use-package switch-window :ensure t
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
  :init
  (ido-vertical-mode 1)
  :config
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down))
; This enables arrow keys to select while in ido mode. If you want to
; instead use the default Emacs keybindings, change it to
; "'C-n-and-C-p-only"

(use-package async :ensure t
  :init
  (dired-async-mode 1))

(use-package eldoc :diminish eldoc-mode)

(use-package cyberpunk-theme :ensure t
  :init
  (load-theme 'cyberpunk t))

(use-package powerline :ensure t
  :config
  (powerline-default-theme))

(use-package company :ensure t
  :custom
  (global-company-mode 1)
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t))

(use-package slime :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (slime-setup '(slime-fancy)))    ;; slime

; (use-package go-mode
;   :ensure t
;   :config
;   (setq gofmt-command "goimports")
;   (add-hook 'before-save-hook 'gofmt-before-save))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package rainbow-mode :ensure t)
  :config
  :hook (prog-mode . rainbow-mode))

(use-package rust-mode :ensure t)
