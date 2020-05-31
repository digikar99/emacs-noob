
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
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(package-selected-packages
   (quote
    (slime company slime-company ace-window auto-complete tabbar helm use-package)))
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

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install-selected-packages))

(use-package helm
  :ensure t
  :bind (:map helm-map 
         ("<tab>" . helm-execute-persistent-action))
  :bind* (("M-x" . helm-M-x)
          ("C-x C-f" . helm-find-files)))

(use-package tabbar
  :bind ((:map tabbar-mode-map
               ("<C-tab>" . tabbar-forward-tab)
               ("<C-iso-lefttab>" . tabbar-backward-tab)))
  :ensure t
  :config
  (defun my-tabbar-buffer-groups () ;; customize to show all normal files in one group
    "Returns the name of the tab group names the current buffer belongs to.
    There are two groups: Emacs buffers (those whose name starts with '*', plus
    dired buffers), and the rest.  This works at least with Emacs v24.2 using
    tabbar.el v1.7."
    (list (cond ((string= (buffer-name) "*scratch*") "user")
                ((string-prefix-p "*slime-repl" (buffer-name)) "user")
                ((string-equal "*" (substring (buffer-name) 0 1)) "emacs")
                (t "user"))))
  (setq tabbar-buffer-groups-function 'my-tabbar-buffer-groups))

(use-package auto-complete
  :ensure t
  :bind (:map ac-menu-map
              ("C-n" . ac-next)
              ("C-p" . ac-previous))
  :config
  (setq ac-auto-start 1
        ac-auto-show-menu 0.1
        ac-use-menu-map t))

(use-package term
  :bind (:map term-raw-map 
         ("M-m" . term-line-mode)
         ("M-n" . term-send-down)
         ("M-p" . term-send-up)
         :map term-mode-map 
         ("M-m" . term-raw-mode)
         ("M-n" . term-send-down)
         ("M-p" . term-send-up)))

(use-package ace-window
  :ensure t
  :config
  (setq aw-scope 'frame))

(use-package fundamental-mode
  
  :init

  (defun isearch-query-replace-symbol-at-point ()
    (interactive)
    (isearch-forward-symbol-at-point)
    (isearch-query-replace))

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
  
  ;;; C-S-t to restore killed tab
  (defvar killed-file-list nil "List of recently killed files, used for restoring them.")
  (defun add-file-to-killed-file-list ()
    (when buffer-file-name
      (push buffer-file-name killed-file-list)))
  (add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)
  (defun reopen-killed-file ()
    (interactive)
    (when killed-file-list
      (find-file (pop killed-file-list))))

  ;;; M-S-up/down to move selected text up and down
  (defun move-text-internal (arg)
    (cond ((and mark-active transient-mark-mode)
           (if (> (point) (mark))
               (exchange-point-and-mark))
           (let ((column (current-column))
                 (text (delete-and-extract-region (point) (mark))))
             (forward-line arg)
             (move-to-column column t)
             (set-mark (point))
             (insert text)
             (exchange-point-and-mark)
             (setq deactivate-mark nil)))
          (t
           (beginning-of-line)
           (when (or (> arg 0) (not (bobp)))
             (forward-line)
             (when (or (< arg 0) (not (eobp)))
               (transpose-lines arg))
             (forward-line -1)))))

  (defun move-text-down (arg)
    "Move region (transient-mark-mode-active) or current-line arg lines down"
    (interactive "*p")
    (move-text-internal arg))

  (defun move-text-up (arg)
    "Move region (transient-mark-mode-active) or current-line arg lines down"
    (interactive "*p")
    (move-text-internal (- arg)))

  ;;; C-w only works when region is selected
  (defun kill-region-when-active ()
    (interactive)
    (when (region-active-p)
      (if (> (point) (mark))
          (exchange-point-and-mark))           
      (kill-region (point) (mark))))

  ;;; M-k
  (defun ruthlessly-kill-line ()
    (interactive)
    (delete-char (- (line-end-position) (point)) nil))

  ;;; Disable key bindings with C-x prefix
  (cl-loop for ch below 128
           do (global-set-key (kbd (concat "C-x " (string ch))) nil))

  ;;; FIXME: C-x 8 doesn't set to nil
  ;; (cl-loop for ch below 128
  ;;       do (define-key iso-transl-ctl-x-8-map (kbd (concat "C-x 8 " (string ch))) nil))

  (defun window-with-name-prefix-live-p (name)
    (cl-some (lambda (buffer-name)
               (string-prefix-p name buffer-name))
             (mapcar #'buffer-name
                     (mapcar #'window-buffer
                             (window-list)))))

  (defun split-window-if-not ()
    (if (= 1 (length (window-list))) (split-window)))
  
  (defun open-slime ()
    (interactive)    
    (let* ((buffer-prefix "*slime-repl"))
      (unless (window-with-name-prefix-live-p buffer-prefix)
        (let* ((buffer-name-list (mapcar #'buffer-name
                                         (buffer-list)))
               (buffer (cl-loop for buffer-name in (mapcar #'buffer-name (buffer-list))
                                until (string-match-p (regexp-quote buffer-prefix)
                                                       buffer-name)
                                finally (if (string-match-p (regexp-quote buffer-prefix)
                                                             buffer-name)
                                             (cl-return buffer-name)
                                           nil))))
          (if (not buffer)
              (slime)
            (split-window-if-not)
            (other-window 1)
            (switch-to-buffer buffer))))))
  
  :bind (("C-x h" . mark-whole-buffer)
         ("C-a" . beginning-of-visual-line)
         ("C-e" . end-of-visual-line)
         ("C-s" . isearch-forward)
         ("C-M-s" . isearch-forward-symbol-at-point)
         ("C-M-r" . isearch-query-replace-symbol-at-point)
         ("C-r" . query-replace)
         ("C-h" . backward-kill-word) ; also bound to C-<backspace> in terminal mode!
         ("C-z" . undo)
         ("C-j" . newline)
         ("C-w" . kill-region-when-active)
         ("C-y" . yank)
         ("C-l" . goto-line)
         ("C-/" . comment-line)
         ("M-k" . ruthlessly-kill-line)
         ("C-t" . (lambda () (interactive) (switch-to-buffer "*scratch*")))
         ("C-S-t" . reopen-killed-file))
  :bind* (("M-o" . switch-to-buffer)
          ("C-v" . scroll-up)
          ("M-v" . scroll-down)
          ("C-o" . ace-window)
          ("<f8>" . split-window-vertically)
          ("<f9>" . delete-other-windows-vertically)
          ("<f7>" . split-window-horizontally)
          ("S-<f11>" . delete-other-windows)
          ("<f11>" . toggle-frame-fullscreen)
          ("C-x C-e" . eval-last-sexp)
          ("C-x C-r" . rename-file-and-buffer)
          ("C-x C-w" . kill-this-buffer)
          ("C-x C-d" . dired)
          ("C-x C-k" . delete-window)
          ("C-x C-s" . save-buffer)
          ("M-h" . help-command)
          ("M-q" . save-buffers-kill-emacs)
          ("M-l" . open-slime)
          ("M-S-<up>" . move-text-up)
          ("M-S-<down>" . move-text-down)))

(use-package company
  :ensure t
  :hook ((slime-repl-mode common-lisp-mode emacs-lisp-mode) . company-mode)
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.1
        company-flx-limit 20))

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl") ; substitute with the path to the compiler
  (slime-setup '(slime-fancy slime-company)))

(use-package slime-company
  :after (slime company)
  :ensure t
  :config
  (setq slime-company-completion 'fuzzy))

(progn
  (put 'upcase-region 'disabled nil)
  ;;; Smoother scrolling
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed t
        mouse-wheel-follow-mouse t
        scroll-step 1)
  ;;; Enable additional modes
  (helm-mode)
  (tabbar-mode)
  (electric-pair-mode)
  (show-paren-mode)
  (column-number-mode)
  (global-auto-revert-mode t)
  (global-linum-mode)
  (setq indent-tabs-mode nil)
  ;;; Confirm
  (setq confirm-kill-emacs 'yes-or-no-p))
