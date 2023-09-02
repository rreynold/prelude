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

 
  ;;Add autosave when focus is lost (available in emacs 24.4 and later, see http://www.emacswiki.org/emacs/AutoSave#toc8)
  (defun save-all ()
    (interactive)
    (save-some-buffers t))
  (when (or
         (and (>= emacs-major-version 24)
              (>= emacs-minor-version 4))
         (>= emacs-major-version 25))
    (progn (add-hook 'focus-out-hook 'save-all)))

