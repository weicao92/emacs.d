;;; init-local.el --- user settings
;;; Commentary:
;;; Code:

;; --- General Settings ---
(setq-default shell-file-name "/bin/zsh")
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq clean-buffer-list-delay-general 1)
(setq inhibit-splash-screen t)
(setq-default c-basic-offset 4
              tab-width 4
              c-default-style "k&r"
              indent-tabs-mode nil)

;; --- UI ---
(global-hl-line-mode 1)

(if (string-equal system-type "gnu/linux")
    (set-face-attribute 'default nil :font "Monaco 11"))
(if (and (string-equal system-type "gnu/linux") (display-graphic-p))
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset (font-spec :family "Source Han Sans CN"
                                           :size 14))))

;; (use-package solarized-theme
;;   :ensure t
;;   :if (display-graphic-p)
;;   :init
;;   (setq solarized-high-contrast-mode-line t)
;;   (setq solarized-use-less-bold t)
;;   (setq solarized-emphasize-indicators nil)
;;   (setq solarized-scale-org-headlines nil)
;;   (setq x-underline-at-descent-line t)
;;   (setq solarized-height-minus-1 1.0)
;;   (setq solarized-height-plus-1 1.0)
;;   (setq solarized-height-plus-2 1.0)
;;   (setq solarized-height-plus-3 1.0)
;;   (setq solarized-height-plus-4 1.0)
;;   :config
;;   (load-theme 'solarized-dark t))

;; --- packages ---
(use-package nyan-mode
  :ensure t
  :init
  (setq nyan-animate-nyancat t))

;; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons
  :ensure t
  :config
  (setq inhibit-compacting-font-caches t))

;; https://github.com/zk-phi/symon
(use-package symon
  :ensure t
  :init
  (setq symon-delay 60)
  :config
  (symon-mode 1))

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

;; evil
(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    "o" 'dired-jump
    "x" 'counsel-M-x
    "t" 'ansi-term
    "ff" 'counsel-find-file
    "fe" 'flycheck-list-errors
    "fr" 'lsp-find-references
    "fd" 'xref-find-definitions-other-window
    "fi" 'lsp-find-implementation
    "l" 'imenu-list-smart-toggle
    "gf" 'counsel-git
    "gg" 'counsel-git-grep
    "r" 'recentf-open-files
    "k" 'kill-buffer
    "b" 'switch-to-buffer
    "s" 'save-buffer
    "a" 'mark-whole-buffer
    "n" 'neotree-toggle
    "|" 'split-window-right
    "-" 'split-window-below
    "d" 'delete-window
    "TAB" 'other-window
    "cc" 'evilnc-comment-or-uncomment-lines
    "cr" 'comment-or-uncomment-region))

(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-add-hjkl-bindings recentf-dialog-mode-map 'emacs)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up))

(use-package evil-nerd-commenter
  :ensure t
  :config
  (evilnc-default-hotkeys nil t))

(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2)
  :config
  (evil-escape-mode))

;; neotree
(use-package neotree
  :ensure t
  :init
  (setq neo-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :config
  (evil-define-key 'normal neotree-mode-map (kbd "+") 'neotree-create-node)
  (evil-define-key 'normal neotree-mode-map (kbd "R") 'neotree-rename-node)
  (evil-define-key 'normal neotree-mode-map (kbd "D") 'neotree-delete-node)
  (evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
  (evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
  (evil-define-key 'normal neotree-mode-map (kbd "U") 'neotree-select-up-node)
  (evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle))

(use-package eldoc
  :ensure t
  :diminish
  :hook
  (prog-mode       . turn-on-eldoc-mode)
  (cider-repl-mode . turn-on-eldoc-mode))

;; imenu-list
(use-package imenu-list
  :ensure t
  :config
  (setq imenu-list-focus-after-activation t)
  (setq imenu-list-auto-resize t)
  (setq imenu-generic-expression
        '(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
          ("func" "^func *\\(.*\\) {" 1)
          ("var"  "^var" 1))))

(use-package quickrun
  :ensure t
  :bind ("<f5>" . quickrun-shell))

;; markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "pandoc"))

;; latex
(use-package auctex
  :defer t
  :ensure auctex
  :init
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook
            (lambda()
              (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
              (setq TeX-command-default "XeLaTeX")
              (setq TeX-show-compilation nil)
              (setq TeX-save-query  nil)))
  (setq-default TeX-master nil)
  (setq-default TeX-engine 'xetex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-auto-untabify t)
  (setq reftex-plug-into-AUCTeX t))

(use-package cdlatex
  :ensure t
  :init
  ;; (add-hook 'org-mode-hook 'turn-on-cdlatex)
  (add-hook 'LaTeX-mode-hook 'turn-on-cdlatex))

(custom-set-variables
 '(mode-line-format
   (quote
    ("%e"
     mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
     (vc-mode vc-mode)
     "  " mode-line-modes mode-line-misc-info mode-line-end-spaces
     (:eval
      (list
       (nyan-create))))))
 '(package-selected-packages
   (quote
    (treemacs popup ace-window lsp-treemacs rust-mode cargo lv lsp-mode lsp-ui company-lsp imenu-list symon page-break-lines all-the-icons neotree evil-escape expand-region nyan-mode go-eldoc exec-path-from-shell go-mode company-go cdlatex auctex markdown-mode flycheck quickrun hungry-delete evil-nerd-commenter solarized-theme counsel swiper which-key use-package evil-leader company org-bullets))))

(provide 'init-wu)
;;; init-local ends here
