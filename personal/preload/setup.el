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

  ;;(require 'ergoemacs-mode)
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

  ;;org-mode
  ;(require 'org-install)
  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done t)
  (setq org-startup-indented 1)
  (add-hook 'org-mode-hook 'turn-on-visual-line-mode)

  (setq org-agenda-files (quote ( "~/Dropbox/notes")))
  (setq org-time-stamp-rounding-minutes '(0 5))

  ;;Pre-load agenda. From https://emacs.stackexchange.com/a/21950/5174
  ;;Doesn't work out-of-box, look at later.
  ;(add-hook 'after-init-hook 'org-agenda-list)
  (add-hook 'after-init-hook '(lambda () (org-agenda-list 1)))

  ;;Hide DONE items from agenda view
  (setq org-agenda-skip-scheduled-if-done t)

  ;;Exclude subtrees of trees tagged PROJECTS from showing up in agenda view for PROJECTS tag
  (setq org-tags-exclude-from-inheritance '("PROJECTS" "SOMEDAY" "Projects" "Someday"))

  ;; Capture distractions - From https://lucidmanager.org/productivity/getting-things-done-with-emacs/
  (global-set-key "\C-cc" 'org-capture)
  (setq org-capture-templates
        '(("d" "Distraction" entry (file+headline "~/Dropbox/notes/!inbox.org" "Inbox")
           "* %?\n%T")))

  ;;From http://stackoverflow.com/a/27043756/17058
  (defun org-archive-done-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
     "/DONE" 'agenda))
  (defun org-archive-canceled-tasks ()
    (interactive)
    (org-map-entries
     (lambda ()
       (org-archive-subtree)
       (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
     "/CANCELED" 'agenda))

  ;; The rest of this file comes from http://doc.norang.ca/org-mode.html
  ;; Section 5
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "blue" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold))))

  (setq org-use-fast-todo-selection t)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
