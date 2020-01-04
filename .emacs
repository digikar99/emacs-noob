
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.

;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(package-selected-packages (quote (tabbar auto-complete helm popup async)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tabbar-default ((t (:inherit variable-pitch :background "white smoke" :foreground "black" :height 1.0))))
 '(tabbar-highlight ((t (:background "spring green"))))
 '(tabbar-selected ((t (:inherit tabbar-default :background "cyan" :foreground "black" :box (:line-width 1 :color "white" :style pressed-button))))))

(prefer-coding-system 'utf-8)
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

(global-set-key (kbd "M-o") 'switch-to-buffer)
(global-set-key (kbd "C-o") 'other-window)
(global-set-key (kbd "C-r") 'query-replace)
(global-set-key (kbd "C-S-r")
		(lambda ()
		  (interactive)
		  (isearch-forward-symbol-at-point)
		  (isearch-query-replace)))
(global-set-key (kbd "<f8>") 'split-window-vertically)
(global-set-key (kbd "<f9>") 'delete-other-windows-vertically)
(global-set-key (kbd "<f10>") 'split-window-horizontally)
(global-set-key (kbd "<f11>") 'delete-other-windows)
(global-set-key (kbd "S-<f11>") 'toggle-frame-fullscreen)
(global-set-key (kbd "C-/") 'comment-line)
(put 'upcase-region 'disabled nil)

;; customize-keys-for-helm
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

(helm-mode)
(show-paren-mode)
(electric-pair-mode)

;; auto-refresh files when changed on disk
(global-auto-revert-mode t)
(global-visual-line-mode)
(global-linum-mode)
(column-number-mode)

;; set up senseless autocompletion
(with-eval-after-load
    'auto-complete-mode
  (setq ac-auto-start 1
	ac-auto-show-menu 0.1
	ac-use-menu-map t)
  (define-key ac-mode-map (kbd "C-n") 'ac-next)
  (define-key ac-mode-map (kbd "C-p") 'ac-previous))
(global-auto-complete-mode 1)


;; set up tabs ==============================
(tabbar-mode) ; faces have been customized
(defun my-tabbar-buffer-groups () ;; customize to show all normal files in one group
  "Returns the name of the tab group names the current buffer belongs to.
    There are two groups: Emacs buffers (those whose name starts with '*', plus
    dired buffers), and the rest.  This works at least with Emacs v24.2 using
    tabbar.el v1.7."
  (list (cond ((string-equal "*" (substring (buffer-name) 0 1)) "emacs")
	      ((eq major-mode 'dired-mode) "emacs")
	      (t "user"))))
(setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups)
(define-key tabbar-mode-map (kbd "<C-tab>") 'tabbar-forward-tab)
(define-key tabbar-mode-map (kbd "<C-iso-lefttab>") 'tabbar-backward-tab)

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew Name: ")
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file filename new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))
(global-set-key (kbd "C-x C-r") 'rename-file-and-buffer)

(require 'term)
(define-key term-raw-map (kbd "M-m") 'term-line-mode)
(define-key term-mode-map (kbd "M-m") 'term-char-mode)

