;;(prelude-require-package 'ergoemacs-mode)

(require 'ergoemacs-mode)
(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
(ergoemacs-mode 1)
(ergoemacs-ignore-prev-global) ; Do not honor previously defined global keys.

  ;; TODO: Figure out how to remap ctrl+z to undo. Currently mapped to alt-z in ergoemacs.
  (with-eval-after-load 'undo-tree (defun undo-tree-overridden-undo-bindings-p () nil))
  ;;(global-unset-key "\C-z")
  ;;(global-set-key "\C-z" 'advertised-undo)
  ;;(define-key global-map "\M-z" 'undo)
  ;;(define-key global-map "\M-y" 'redo)

  ;; Using regular keybindings for search forward/back.
  (define-key isearch-mode-map (kbd "<f3>") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "S-<f3>") 'isearch-repeat-backward)
