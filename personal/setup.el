  ;; Fixing macos right-option-modifier to work as a ctrl (for my muscle memory)
  (when (eq system-type 'darwin)
    (setq mac-right-option-modifier 'control)
  )

  ;; Set line width to 120 columns...
  (setq fill-column 120)
  (setq auto-fill-mode t)

  (defun set-frame-size-according-to-resolution ()
    (interactive)
    (if window-system
        (progn
          (add-to-list 'default-frame-alist (cons 'width 102))
          ;; for the height, subtract a couple hundred pixels
          ;; from the screen height (for panels, menubars and
          ;; whatnot), then divide by the height of a char to
          ;; get the height we want
          (add-to-list 'default-frame-alist
                       (cons 'height (/ (- (x-display-pixel-height) 300)
                                        (frame-char-height)))))))

  (set-frame-size-according-to-resolution)
  ;; Set the starting position to the upper left corner.
  (set-frame-position (selected-frame) 0 25)

 ;; (require 'ergoemacs-mode)
 ;; (ergoemacs-ignore-prev-global) ; Do not honor previously defined
 ;;                                ; global keys.
  ;;(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
  ;;(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
  ;;(ergoemacs-mode 1)

  ;; TODO: Figure out how to remap ctrl+z to undo. Currently mapped to alt-z in ergoemacs.
  (with-eval-after-load 'undo-tree (defun undo-tree-overridden-undo-bindings-p () nil))
  ;;(global-unset-key "\C-z")
  ;;(global-set-key "\C-z" 'advertised-undo)
  ;;(define-key global-map "\M-z" 'undo)
  ;;(define-key global-map "\M-y" 'redo)

  ;(cua-mode t)
  ;(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
  ;(transient-mark-mode 1) ;; No region when it is not highlighted
  ;(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

  ;; Using regular keybindings for search forward/back.
  (define-key isearch-mode-map (kbd "<f3>") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "S-<f3>") 'isearch-repeat-backward)

  ;;Add autosave when focus is lost (available in emacs 24.4 and later, see http://www.emacswiki.org/emacs/AutoSave#toc8)
  (defun save-all ()
    (interactive)
    (save-some-buffers t))
  (when (or
         (and (>= emacs-major-version 24)
              (>= emacs-minor-version 4))
         (>= emacs-major-version 25))
    (progn (add-hook 'focus-out-hook 'save-all)))

