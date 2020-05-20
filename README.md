If you reached here from [this video](https://www.youtube.com/watch?v=GJ4i10U_zzg), please
see the [version tagged demo](https://github.com/digikar99/emacs-noob/tree/demo).

***

## Requirements

Emacs 25 and up! (Due to helm.)

## Installation

Drop the `init.el` in your `~/.emacs.d/` and (re)start emacs.

Emacs will download `use-package` and then the required packages. This should take
a few minutes. Restart emacs.

## Features

- Melpa added
- Packages: use-package, tabbar-mode, ace-window, auto-complete, helm
- Several `C-x` bindings are bound to nil
- global auto-complete-mode, electric-pair-mode, show-paren-mode, auto-revert-mode, visual-line-mode, linum-mode, column-number-mode, helm-mode
- Slower scroll


## Key-bindings

**Text Editing**

- C-a: Select all
- C-f: Search (forward)
- C-r: Replace (forward); because see C-h next
- C-h (Backspace): Delete word to the left - this is so because on the terminal backspace
and C-h are equivalent. (And I haven't bothered for a workaround.)
- C-z: Undo - in emacs, redo is undo of undo; this also avoids loss of redo-undo "trees"
- C-s: Save file (save-buffer)
- C-w [std]: Cut; because C-x is complicated
- C-y [std]: Paste; because
- C-v [std]: Scroll down
- M-v [std]: Scroll up
- C-g [std]: Cancel command
- C-k [std]: Cut line this point forward
- M-k: Delete line this point forward
- C-/: Un/comment-line; also works for un/commenting region when selected
- `C-<space>` [std]: to enter/exit text-selection mode



- M-S-<up>/<down>: Move line (selected region) up or down
- C-M-f: Forward search symbol at point
- C-M-r: Forward replace symbol at point
- M-q: Quit emacs (with prompt)


**Window and Buffer Management**

- F7: Split window horizontally ("<f10>" is more mnemonic, but its bound to something
in some terminals)
- F8: Split window vertically - two parts of the "8"
- F9: Expand window vertically
- F11 [std]: Toggle "frame" full screen
- S-F11: Delete other windows (this, to avoid accidentally pressing "<f11>" while
trying to go full screen)
- C-o [~std]: Switch window
- M-o: Switch buffer

- C-t: Open `*scratch*` buffer
- C-S-t: Reopen closed file
- `C-<tab>` / `C-S-<tab>`: Switch tabs
- M-x [std]: arbitrary commands (helm-M-x)
- C-x C-f [std]: Open file (helm-find-files)
- C-x C-d [~std]: Open directory. Press '?' for help. (dired)
- C-x C-w: Close file (kill-this-buffer)
- C-x C-r: Rename file (and buffer)
- C-x C-k: Delete this window

**Miscellaneous**

- M-h k: Help key
- M-h v: Help variable
- M-h f: Help function

- M-m: ansi-term switch between line and char modes
- M-n: ansi-term next command
- M-p: ansi-term previous command