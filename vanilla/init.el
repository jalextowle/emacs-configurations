;; Set up the Emacs package management system
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; HACK(jalextowle): Addresses a bug in Emacs 26.2. Source:
;; https://emacs.stackexchange.com/questions/51721/failed-to-download-gnu-archive
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(package-initialize)

;;; Appearance ;;;

;; Add line numbers
(global-display-line-numbers-mode)

;; Configure the solarized theme to make Emacs slicker
(require 'solarized-theme)
(load-theme 'solarized-dark t)
(tool-bar-mode -1)

;; Enable smooth scrolling
;; Source: https://www.emacswiki.org/emacs/SmoothScrolling
(setq scroll-step           1
	scroll-conservatively 10000)

;; Add a file tree extension with NERDTree styling.
(require 'neotree)
(setq neo-theme 'nerd)
(defun my/disable-line-numbers (&optional dummy)
    (display-line-numbers-mode -1))
(add-hook 'neo-after-create-hook 'my/disable-line-numbers)

;;; Helm Configuration ;;;

(require 'helm)

;;; Evil Configurations ;;;

;; Enable modal editing for Emacs :)
(require 'evil)
(evil-mode 1)

;; Make search more similar to normal vim search.
(evil-select-search-module 'evil-search-module 'evil-search)

;; Remap some evil keys for neotree
(evil-define-key 'normal neotree-mode-map (kbd "TAB") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "SPC") 'neotree-quick-look)
(evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
(evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
(evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
(evil-define-key 'normal neotree-mode-map (kbd "n") 'neotree-next-line)
(evil-define-key 'normal neotree-mode-map (kbd "p") 'neotree-previous-line)
(evil-define-key 'normal neotree-mode-map (kbd "A") 'neotree-stretch-toggle)
(evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)

;; Define mappings for new evil comamnds
(evil-ex-define-cmd "neotree" 'neotree)

;; Get rid of search highlighting
(setq-default evil-ex-search-highlight-all nil)

;; Remap 'jj' to <esc> in insert mode for superior ergonomics
(require 'evil-escape)
(evil-escape-mode)
(setq-default evil-escape-key-sequence "jj")
(setq-default evil-escape-delay 0.2)
;; NOTE(jalextowle): The best way to exit visual mode is to
;; use the command that entered it. It's really annoying to
;; exit with "jj", so I disable it for the visual mode.
(add-to-list 'evil-escape-excluded-major-modes 'visual)

;;; Typescript ;;;

(require 'tide)
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

(evil-define-key 'normal 'tide-mode-map
  (kbd "C-]") 'tide-jump-to-definition
  (kbd "C-t") 'tide-jump-back)

;; Start autocomplete after only typing a single character
(setq company-minimum-prefix-length 1)

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;;; Before Save Hooks ;;;

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'tide-format-before-save)

;;; Startup Screen ;;;

;; Open NeoTree on entry.
(neotree)

;; Enter into fullscreen on open.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defun display-startup-echo-area-message ()
  (message "Let the hacking begin!"))

;;; Fix Annoyances ;;;

(defun acg-initial-buffer-choice ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*"))
  (get-buffer "*Messages*"))

(setq initial-buffer-choice 'acg-initial-buffer-choice)

;; No more typing the whole yes or no. Just y or n will do.
(fset 'yes-or-no-p 'y-or-n-p)

;;; Custom (do not edit) ;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm key-chord neotree company evil-escape solarized-theme evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
