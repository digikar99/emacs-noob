If you reached here from [this video](https://www.youtube.com/watch?v=GJ4i10U_zzg), please
see the [version tagged demo](https://github.com/digikar99/emacs-noob/tree/demo).

***

## Requirements

Emacs 26 and up! (Due to helm, 25 and up; due to a auto-complete dependency, 26 and up!.)

## Installation

Drop the `init.el` in your `~/.emacs.d/` and (re)start emacs.

Emacs will download `use-package` and then the required packages. This should take
a few minutes. Optionally, restart emacs.

## Features

- Melpa added
- Packages: use-package, tabbar-mode, ace-window, auto-complete, helm, goto-chg
- `C-x` bindings not listed below are bound to nil: In case some exists that is missing below, it is a bug; report them! Known issue is `C-x 8-` key bindings which I've been unable to disable.
- global auto-complete-mode, electric-pair-mode, show-paren-mode, auto-revert-mode, visual-line-mode, linum-mode, column-number-mode, helm-mode
- Slower / less-jerky scroll

## Usage Intention

This branch `emacs-modern` is intended for one-off emacs usage. Users are *strongly discouraged* from using this in the longer run or for learning emacs. In the longer run, users might want to consider using the [master branch](https://github.com/digikar99/emacs-noob) or one of the more established [emacs starter kits](https://github.com/emacs-tw/awesome-emacs#starter-kit).

## Branch Specialized for Common Lisp Development

- If you do not have access to a full blown emacs GUI and are stuck with a terminal-only version, you are better off with [slime-company-ecl](https://github.com/digikar99/emacs-noob/tree/slime-company-ecl)
- If you intend to learn emacs in the longer run, look towards [slime-company](https://github.com/digikar99/emacs-noob/tree/slime-company).
- If you do not intend to learn emacs and instead want to focus on Common Lisp, look towards [slime-company-modern](https://github.com/digikar99/emacs-noob/tree/slime-company-modern).

## Key-bindings

The intention is that `C-o`, `C-x`, `C-z` `<escape>` and several others should "just work". In case you think a particular key-binding should exist as default, feel free to raise an issue or a PR.

The key-bindings are available at [init.el](./init.el).

**Other partially non-standard key-bindings**

- C-p: Switch buffer
- C-l: Goto line
- M-q: Quit emacs (with prompt)
- M-o: Other window
- M-k: Delete line this point forward
- M-h k: Help key
- M-h v: Help variable
- M-h f: Help function
- M-S-<up>/<down>: Move line (selected region) up or down
- C-M-f: Forward search symbol at point
- C-M-h: Forward replace symbol at point

<br/>

- F7: Split window horizontally: "<f10>" is more memorable, but its bound to something
in some terminals
- F8: Split window vertically - two parts of the "8"
- F9: Expand window vertically
- F11 [std]: Toggle "frame" full screen
- S-F11: Delete other windows (this, to avoid accidentally pressing "<f11>" while
trying to go full screen)

<br/>

- M-m: ansi-term switch between line and char modes
- M-n: ansi-term next command
- M-p: ansi-term previous command