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
