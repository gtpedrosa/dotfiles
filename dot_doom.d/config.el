;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; Setup agenda files

(require 'org)
(require 'org-habit)
;; Hugo orgmode exporter
(with-eval-after-load 'ox__
  (require 'ox-hugo))
(require 'org-hugo-auto-export-mode) ;If you want the auto-exporting on file saves
(require 'org-tempo);Enable snippets expantions: ex <s +TAB or <q +TAB

(setq-default truncate-lines t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq initial-buffer-choice "~/Dropbox/orgs/projects.org")

(setq org-agenda-files (list "~/Dropbox/orgs/work.org"
                             "~/Dropbox/orgs/university.org"
                             "~/Dropbox/orgs/personal.org"
                             "~/Dropbox/orgs/projects.org"))

;;(after! org (setq ;;org-agenda-diary-file "~/.org/diary.org"
;;                  org-agenda-dim-blocked-tasks t
;;                  org-agenda-use-time-grid t
;;                  org-agenda-hide-tags-regexp ":\\w+:"
;;                  org-agenda-prefix-format " %(my-agenda-prefix) "
;;                  org-agenda-skip-scheduled-if-done t
;;                  org-agenda-skip-deadline-if-done t
;;                  org-enforce-todo-checkbox-dependencies nil
;;                  org-habit-show-habits t))


(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
;; Orgomode configuration
(setq org-log-done 'time)
(setq org-log-done t)
(setq org-startup-indented t)

;;(defadvice org-agenda (around split-vertically activate)
;;  (let ((split-width-threshold 40))  ; or whatever width makes sense for you
;;    ad-do-it))

(use-package org-download
  :after org
  :bind
  (:map org-mode-map
        (("s-Y" . org-download-screenshot)
         ("s-y" . org-download-yank))))

(use-package mathpix.el
  ;:straight (:host github :repo "jethrokuan/mathpix.el")
  :custom ((mathpix-app-id "app-id")
           (mathpix-app-key "app-key"))
  :bind
  ("C-x m" . mathpix-screenshot))

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-date-prefix "#+TITLE: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Dropbox/orgs/roam/")
  (org-journal-date-format "%A, %d %B %Y"))

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/orgs/roam/"))

(use-package org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/Dropbox/orgs/roam/"))

;; Fix upstream issue with emacs
(setq internal-lisp-face-attributes
  [nil
   :family :foundry :swidth :height :weight :slant :underline :inverse
   :foreground :background :stipple :overline :strike :box
   :font :inherit :fontset :vector :extend])

;; Modify agenda view to show todo list
;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
;;(setq org-agenda-custom-commands
;;      '(("c" "Simple agenda view"
;;        ((tags "PRIORITY=\"A\""
;;                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
;;                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
;;          (agenda "")
;;          (alltodo "")))))

;; Make org agenda show shceduled/recurring tasks done when due
;;(setq org-agenda-log-mode-items '(closed clock state))

(with-eval-after-load 'org-capture
  (defun org-hugo-new-subtree-post-capture-template ()
    "Returns `org-capture' template string for new Hugo post. See `org-capture-templates' for more information."
    (let* ((title (read-from-minibuffer "Post Title: ")) ;Prompt to enter the post title
           (fname (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* TODO " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " (format-time-string "%Y-%m-%d-") fname)
                   ":END:"
                   "%?\n")          ;Place the cursor here finally
                 "\n"))))
;; org capture templates
(setq org-capture-templates
 '(
    ("h"         ;`org-capture' binding + h
                 "Hugo post"
                 entry
                 ;; It is assumed that below file is present in `org-directory'
                 ;; and that it has a "Blog Ideas" heading. It can even be a
                 ;; symlink pointing to the actual location of all-posts.org!
                 (file+olp "~/Projects/blog/hugo-blog/content-org/posts.org" "blog")
                 (function org-hugo-new-subtree-post-capture-template))
;; https://karl-voit.at/2014/08/10/bookmarks-with-orgmode/
;; many more capture templates
  ("b" "Bookmark" entry (file+headline "~/notes.org" "Bookmarks")
   "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n\n" :empty-lines 1)
;; many more capture templates
))

;; org refile config
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Guilherme Pedrosa"
      user-mail-address "guilherme.pedrosa@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/orgs/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
