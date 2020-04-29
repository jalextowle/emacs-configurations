;; Set up the Emacs package management system
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; HACK(jalextowle): Addresses a bug in Emacs 26.2. Source:
;; https://emacs.stackexchange.com/questions/51721/failed-to-download-gnu-archive
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(package-initialize)

;;; Emacs Remappings ;;;

;; Remap two bindings to avoid using M-x
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;;; Appearance ;;;

;; Add line numbers
(require 'display-line-numbers)

(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode neotree-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "turn on line numbers but excempting certain majore modes defined in `display-line-numbers-exempt-modes'"
  (if (and
       (not (member major-mode display-line-numbers-exempt-modes))
       (not (minibufferp)))
      (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; turn on highlight matching brackets when cursor is on one
(show-paren-mode 1)

;;; Themes ;;;

;; TODO(jalextowle): I really love this theme, but it's highlighting is
;; too low contrast for evil-visual-state. It's comments are also very
;; low contract. Fix this and switch back to it.
;;
;; (require 'underwater-theme)
;; (load-theme 'underwater t)

(require 'zenburn-theme)
(load-theme 'zenburn)
(tool-bar-mode -1)

;; Enable smooth scrolling
;; Source: https://www.emacswiki.org/emacs/SmoothScrolling
(setq scroll-step           1
	scroll-conservatively 10000)

;;; Helm Configuration ;;;

(require 'helm)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)

;;; Evil Configurations ;;;

;; Enable modal editing for Emacs :)
(require 'evil)
(evil-mode 1)

;; Remap <esc> to jj
(require 'key-chord)
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)

;; Make search more similar to normal vim search.
(evil-select-search-module 'evil-search-module 'evil-search)

;; Get rid of search highlighting
(setq-default evil-ex-search-highlight-all nil)

;;; Before Save Hooks ;;;

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'before-save-hook 'tide-format-before-save)

;;; Org-Mode ;;;

;; Disable the splash screen (to enable it agin, replace the t with 0)
(setq inhibit-splash-screen t)

;; Enable transient mark mode
(transient-mark-mode 1)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

;;; Org Roam ;;;

(require 'org-roam)
(org-roam-mode +1)

;;; Startup Screen ;;;

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

;;; Company Mode ;;;

;; Reduce the startup time of company autocomplete mode.
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1)

;; Map tab to autocomplete or cycle
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))

;; Map tab to autocomplete or cycle
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
     (define-key company-active-map (kbd "<backtab>") 'company-select-previous)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       Language Modes       ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;;; Yaml ;;;

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook
 '(lambda ()
    (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       Custom (DO NOT EDIT!)      ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("76c5b2592c62f6b48923c00f97f74bcb7ddb741618283bdb2be35f3c0e1030e3" default)))
 '(package-selected-packages
   (quote
    (zenburn-theme underwater-theme yaml-mode org-roam helm key-chord neotree company evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
