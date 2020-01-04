A curated emacs set up to decrease the learning curve.

In particular, this has 

- CUA-mode enabled: this enables the "usual keys" for cut, copy, paste, undo
- melpa repository added to package archives
- helm mode installed: this seems to not work on Emacs 24.5; so use version 25 and up
- tabbar-mode installed and customized a bit
- global auto-complete-mode, electric-pair-mode, show-paren-mode, auto-revert-mode, visual-line-mode, linum-mode, column-number-mode

Keybindings that differ (or are in addition to) barebones CUA-mode enabled Emacs:

- `C-o`: other-window
- `M-o`: switch-to-buffer - "other" of a different sort
- `C-r`: query-replace - r for replace
- `C-S-r`: "isearch-query-replace-symbol-at-point"
- `F8`: split-window-vertically - see the vertical split in "8"?
- `F9`: delete-other-windows-vertically
- `F10`: split-window-horizontally - see the horizontal split in "10"?
- `F11`: delete-other-windows - effectively fullscreen
- `S-F11`: toggle-frame-fullscreen - true fullscreen
- `C-/`: comment-line - more like other editors?
- `C-w`: kill-this-buffer - cut is assigned to `C-x`
- `C-tab`: tabbar-forward-tab
- `C-S-tab`: tabbar-backward-tab
- `C-x C-r`: rename-file-and-buffer - without closing
- `M-m`: switch modes inside `ansi-term`