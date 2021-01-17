If you reached here from [this video](https://www.youtube.com/watch?v=GJ4i10U_zzg), please
see the [version tagged demo](https://github.com/digikar99/emacs-noob/tree/demo).

***

## Requirements

Emacs 26 and up! (Due to helm, 25 and up; due to a auto-complete dependency, 26 and up!.)

## Installation

Drop the `init.el` in your `~/.emacs.d/` and (re)start emacs.

Emacs will download `use-package` and then the required packages. This should take
a few minutes. Restart emacs.

## Features

- Melpa added
- Packages: use-package, tabbar-mode, ace-window, auto-complete, helm, goto-chg
- `C-x` bindings not listed below are bound to nil: In case some exists that is missing below, it is a bug; report them! Known issue is `C-x 8-` key bindings which I've been unable to disable.
- global auto-complete-mode, electric-pair-mode, show-paren-mode, auto-revert-mode, visual-line-mode, linum-mode, column-number-mode, helm-mode
- Slower scroll

## Usage Intention

- Use intended when you are limited to a terminal interface and want a more-or-less familiar interface. The presence of terminal can mess up several keys, for instance `C-g` and `<backspace>` become equivalent (unless there's a workaround I do not know of!). Another being the response of scroll, forcing the existence of *some* key bindings for scrolling; with that case, *why not keep the default one*?
- Why not *complete* default? Because the default binding of `C-z` would frustrate the new user. There are several other keys.
- If you have access to a full GUI emacs and *do not* want to learn emacs, take a look at [emacs-modern](https://github.com/digikar99/emacs-noob/tree/emacs-modern) branch.
- If you are using emacs to learn Common Lisp and want to delay learning emacs, take a look at
    - [slime-company-modern](https://github.com/digikar99/emacs-noob/tree/slime-company-modern) if you have access to GUI emacs
    - [slime-company](https://github.com/digikar99/emacs-noob/tree/slime-company) if you do *not* have access to GUI emacs and are stuck to a terminal-only. This intends to keep the bindings of the master branch, and augment them with lisp specific bindings.

## Key-bindings

**Text Editing**

- C-a: Select all
- C-s [std]: Search (forward); because changing this means changing several other maps
and we don't want to go "too far" from vanilla emacs, so that you get used to it as well
- C-r: Replace (forward); because see C-h next
- C-h (Backspace): Delete word to the left - this is so because on the terminal backspace
and C-h are equivalent. And I haven't searched enough for a workaround.
- C-z: Undo - in emacs, redo is undo of undo; this also avoids loss of redo-undo "trees"
- `C-<space>` [std]: enter/exit text-selection mode
- C-w [std]: Cut; because C-x is complicated
- C-y [std]: Paste; because
- C-v [std]: Scroll down
- M-v [std]: Scroll up
- C-g [std]: Cancel command
- C-k [std]: Cut line this point forward
- M-k: Delete line this point forward
- C-/: Un/comment-line; also works for un/commenting region when selected
- C-l: Goto line

<br/>

- M-S-<up>/<down>: Move line (selected region) up or down
- C-M-s: Forward search symbol at point
- C-M-r: Forward replace symbol at point
- M-q: Quit emacs (with prompt)
- C-.: Goto last change (useful when one scrolls)
- C-,: Goto last change reverse


**Window and Buffer Management**

- F7: Split window horizontally: "<f10>" is more memorable, but its bound to something
in some terminals
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
- C-x C-s [std]: Save file
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