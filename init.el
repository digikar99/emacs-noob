
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
    (slime-company slime goto-chg ace-window auto-complete tabbar helm use-package))))
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

;; Create almost-empty global keymap
(let ((my-global-map (make-keymap)))
  (substitute-key-definition 'self-insert-command
                             'self-insert-command
                             my-global-map
                             global-map)
  (cl-loop for digit below 9
           do (define-key my-global-map
                (kbd (concat "C-" (int-to-string digit)))
                'digit-argument))
  ;; Unable to do this using 'bind' in (use-package fundamental-mode ...)
  (mapc (lambda (key-binding)
          (define-key my-global-map (kbd (car key-binding)) (cdr key-binding))) 
        '(("<up>" . previous-line)
          ("<down>" . next-line)
          ("<left>" . backward-char)
          ("<right>" . forward-char)
          
          ("C-a" . mark-whole-buffer)
          ("C-h" . query-replace)
          ("C-g" . keyboard-quit)
          ("C-j" . newline)
          ("C-v" . yank)
          ("C-w" . kill-this-buffer)
          ("C-l" . goto-line)
          ("C-s" . save-buffer)
          ("C-t" . (lambda () (interactive) (switch-to-buffer "*scratch*")))
          ("C-S-t" . reopen-killed-file)
          ("C-z" . undo)
          ("C-/" . comment-line)
          
          ("C-." . goto-last-change)
          ("C-," . goto-last-change-reverse)

          ("<return>" . newline-and-indent)
          ("<tab>" . indent-for-tab-command)
          ("<escape>" . keyboard-quit)
          ("C-<left>" . backward-word)
          ("C-<right>" . forward-word)
          ("<end>" . end-of-visual-line)
          ("C-<end>" . end-of-buffer)
          ("<home>" . beginning-of-visual-line)
          ("C-<home>" . beginning-of-buffer)
          ("<backspace>" . delete-backward-char)
          ("C-<backspace>" . backward-kill-word) ; also bound to C-<backspace> in terminal mode!          
          ("<delete>" . delete-forward-char)
          ("C-<delete>" . kill-word)
          
          ("<mouse-1>" . mouse-set-point)
          ("<mouse-4>" . mwheel-scroll)
          ("<mouse-5>" . mwheel-scroll)
          ("<drag-mouse-1>" . mouse-set-region)
          ("<vertical-line>" . mouse-drag-vertical-line)
          ("<mode-line>" . mouse-drag-mode-line)
          ("<C-mouse-4>" . text-scale-increase)
          ("<C-mouse-5>" . text-scale-decrease)))
  (use-global-map my-global-map))

(use-package helm
  :ensure t
  :bind (:map helm-map 
              ("<tab>" . helm-execute-persistent-action)
              ("<up>" . helm-previous-line)
              ("<down>" . helm-next-line)
              ("C-g" . helm-keyboard-quit)
              ("<escape>" . helm-keyboard-quit)
              ("<return>" . helm-confirm-and-exit-minibuffer))
  :bind* (("M-x" . helm-M-x)
          ("C-o" . helm-find-files))
  :config (helm-mode))

(use-package helm-files
  :bind (:map helm-find-files-map
              ("C-g" . helm-keyboard-quit)
              ("<escape>" . helm-keyboard-quit)))

(use-package tabbar
  :init (defvar user-buffers '("*scratch*"))
  :bind (:map tabbar-mode-map
              ("<C-tab>" . tabbar-forward-tab)
              ("<C-iso-lefttab>" . tabbar-backward-tab))
  :ensure t
  :config
  (defun my-tabbar-buffer-groups () ;; customize to show all normal files in one group
    "Returns the name of the tab group names the current buffer belongs to.
    There are two groups: Emacs buffers (those whose name starts with '*', plus
    dired buffers), and the rest.  This works at least with Emacs v24.2 using
    tabbar.el v1.7."
    (list (cond ((member (buffer-name) user-buffers) "user")
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

  ;;; M-k
  (defun ruthlessly-kill-line ()
    (interactive)
    (delete-char (- (line-end-position) (point)) nil))

  ;; Source: https://www.reddit.com/r/emacs/comments/4ermj9/how_to_restore_last_window_size_in_emacs/
  ;; Custom functions/hooks for persisting/loading frame geometry upon save/load
  (defun save-frameg ()
    "Gets the current frame's geometry and saves to ~/.emacs.frameg."
    (let ((frameg-font (frame-parameter (selected-frame) 'font))
          (frameg-left (frame-parameter (selected-frame) 'left))
          (frameg-top (frame-parameter (selected-frame) 'top))
          (frameg-width (frame-parameter (selected-frame) 'width))
          (frameg-height (frame-parameter (selected-frame) 'height))
          (frameg-file (expand-file-name "~/.emacs.frameg")))
      (with-temp-buffer
        ;; Turn off backup for this file
        (make-local-variable 'make-backup-files)
        (setq make-backup-files nil)
        (insert
         ";;; This file stores the previous emacs frame's geometry.\n"
         ";;; Last generated " (current-time-string) ".\n"
         "(setq initial-frame-alist\n"
         ;; " '((font . \"" frameg-font "\")\n"
         " '("
         (format " (top . %d)\n" (max frameg-top 0))
         (format " (left . %d)\n" (max frameg-left 0))
         (format " (width . %d)\n" (max frameg-width 0))
         (format " (height . %d)))\n" (max frameg-height 0)))
        (when (file-writable-p frameg-file)
          (write-file frameg-file)))))

  (defun load-frameg ()
    "Loads ~/.emacs.frameg which should load the previous frame's geometry."
    (let ((frameg-file (expand-file-name "~/.emacs.frameg")))
      (when (file-readable-p frameg-file)
        (load-file frameg-file))))

  :bind (:map isearch-mode-map
              ("C-S-f" . isearch-repeat-backward)
              ("C-f" . isearch-repeat-forward)
         :map minibuffer-local-map
              ("<return>" . exit-minibuffer)
         :map package-menu-mode-map
              ("<return>" . package-menu-describe-package)
         :map help-mode-map
              ("<return>" . push-button)
         :map override-global-map
              ("C-f" . isearch-forward))

  :bind* (("C-M-f" . isearch-forward-symbol-at-point)
          ("C-M-h" . isearch-query-replace-symbol-at-point)
          ("M-h" . help-command)
          ("M-q" . save-buffers-kill-emacs)
          ("M-S-<up>" . move-text-up)
          ("M-S-<down>" . move-text-down)
          ("M-b" . switch-to-buffer)
          ("M-o" . ace-window)
          ("M-e" . eval-last-sexp)
          ("M-k" . delete-window)
          ("M-r" . rename-file-and-buffer)
          ("M-k" . ruthlessly-kill-line)
          ("<f8>" . split-window-vertically)
          ("<f9>" . delete-other-windows-vertically)
          ("<f7>" . split-window-horizontally)
          ("S-<f11>" . delete-other-windows)
          ("<f11>" . toggle-frame-fullscreen)))

(use-package company
  :ensure t
  :hook ((slime-repl-mode common-lisp-mode emacs-lisp-mode) . company-mode)
  :bind (:map company-active-map
              ("<up>" . (lambda ()
                          (interactive)
                          (company-select-previous)
                          (company-permanently-show-doc-buffer)))
              ("<down>" . (lambda ()
                            (interactive)
                            (company-select-next)
                            (company-permanently-show-doc-buffer)))
              ("SPC" . (lambda ()
                         (interactive)
                         (company-abort)
                         (insert " "))))
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.1
        company-flx-limit 20)
  (defun company-permanently-show-doc-buffer ()
    "Temporarily show the documentation buffer for the selection."
    (interactive)
    (let* ((selected (nth company-selection company-candidates))
           (doc-buffer (or (company-call-backend 'doc-buffer selected)
                           (error "No documentation available"))))
      (with-current-buffer doc-buffer
        (goto-char (point-min)))
      (display-buffer doc-buffer t))))

(use-package lisp-mode
  :bind (:map lisp-mode-map
              ("C-c C-e" . macrostep-expand)))

(use-package slime
  :ensure t
  :bind (:map slime-mode-map
              ("C-c C-e" . macrostep-expand)
              ("C-c C-p" . slime-toggle-profile-fdefinition)
              ("C-c M-r" . slime-profile-report)
              ("C-c C-r" . slime-profile-reset)
         :map slime-repl-mode-map
              ("C-c C-p" . slime-toggle-profile-fdefinition)
              ("C-c M-r" . slime-profile-report)
              ("C-c C-r" . slime-profile-reset)
         :map sldb-mode-map
              ("<mouse-1>" . sldb-default-action/mouse))
  :bind* (("M-l" . open-slime))
  :hook (slime-mode . (lambda ()
                        (set (make-local-variable 'company-backends)
                             '((company-slime company-capf)))))
  :config
  (setq inferior-lisp-program "sbcl") ; substitute with the path to the compiler
  (slime-setup '(slime-fancy slime-company))
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
            (switch-to-buffer buffer)))))))

(use-package slime-company
  :after (slime company)
  :ensure t
  :bind (:map slime-editing-map
              ("C-c C-d d" . company-maybe-show-doc-buffer)
              ("C-c C-d C-d" . company-maybe-show-doc-buffer))
  :config
  (setq slime-company-completion 'fuzzy)
  (defun company-maybe-show-doc-buffer (symbol-name)
    (interactive (list (slime-read-symbol-name "Describe symbol: ")))
    (if (not (member 'company-mode minor-mode-list))
        (slime-describe-symbol symbol-name)
      (call-interactively 'company-manual-begin)
      (call-interactively 'company-permanently-show-doc-buffer)
      (call-interactively 'company-abort))))

(progn
  (put 'upcase-region 'disabled nil)
  ;;; Smoother scrolling
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed t
        mouse-wheel-follow-mouse 't
        scroll-step 1)
  ;;; Save/Load window-geometry
  (when window-system
    (add-hook 'after-init-hook 'load-frameg)
    (add-hook 'kill-emacs-hook 'save-frameg))
  ;;; Enable additional modes
  (cua-mode)
  (tabbar-mode)
  (electric-pair-mode)
  (show-paren-mode)
  (column-number-mode)
  (global-auto-revert-mode t)
  (global-linum-mode)
  (setq-default indent-tabs-mode nil)
  ;;; Confirm
  (setq confirm-kill-emacs 'yes-or-no-p))
