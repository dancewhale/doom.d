;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Global Config for Mac
(file-truename "~/.doom.d/")
(setq my_base_path (file-truename "~/Dropbox/emacs"))

(when (eq system-type 'darwin)
  (progn
    (setq envpath (concat my_base_path "/mac"))
    (setq system_font "Kai")
    (message "config for darwin.")
  )
)

(when (eq system-type 'gnu/linux)
  (progn
    (setq envpath (concat my_base_path "/linux"))
    (setq system_font "WenQuanYi Micro Hei Mono-14")
    (message "config for darwin.")
  )
)

(load-file (concat doom-private-dir "/function.el"))


;;;-------------------------------------------------
;; 修改默认doom的theme
;;;-------------------------------------------------
(setq doom-theme 'doom-dracula)


;;;-------------------------------------------------
;; notdeft配置
;;;-------------------------------------------------
(setq notdeft-xapian-program (concat envpath "/bin/notdeft-xapian"))
(setenv "XAPIAN_CJK_NGRAM" "1")
(setq notdeft-directories '("~/.roam/"))

;;;-------------------------------------------------
;; roam 的配置
;;;-------------------------------------------------
(setq org-roam-directory "~/.roam/")



;;;-------------------------------------------------
;; rime input-method
;; rime的输入法在doom中的配置的编译失败可以手工介入
;; 在repos中的emacs-rime目录中执行make lib后
;; 把编译好的so和.c文件放入build/rime目录之下。
;;;-------------------------------------------------
(require 'rime)
(setq rime-user-data-dir (concat my_base_path "/chinese/rime"))
(custom-set-variables '(rime-librime-root (concat my_base_path "/lib/librime")))

(setq rime-posframe-properties
      (list :background-color "#333333"
            :foreground-color "#dcdccc"
            :font system_font
            :internal-border-width 10))

(setq default-input-method "rime"
      rime-show-candidate 'posframe)
(global-set-key (kbd "s-j") 'toggle-input-method)

;;;-------------------------------------------------
;;; org-journal的个人配置,该包主要用于工作学习日志
;;;-------------------------------------------------
(require 'org-journal)
(customize-set-variable 'org-journal-dir "~/Dropbox/org/worklog")
(customize-set-variable 'org-journal-new-date-entry "%A, %d %B %Yz")
(customize-set-variable 'org-journal-file-type `weekly)
(customize-set-variable 'org-journal-file-format "%Y%m%d")

(defun org-journal-date-format-func (time)
  "Custom function to insert journal date header,
and some custom text on a newly created journal file."
  (when (= (buffer-size) 0)
    (insert
     (pcase org-journal-file-type
      (`daily "#+TITLE: Daily Journal")
       (`weekly "#+TITLE: Weekly Journal")
       (`monthly "#+TITLE: Monthly Journal")
       (`yearly "#+TITLE: Yearly Journal"))))
  (concat org-journal-date-prefix (format-time-string "%A, %x" time)))

(setq org-journal-date-format 'org-journal-date-format-func)


;;;-------------------------------------------------
;;; org的个人配置,如何记录、如何作笔记。
;;;-------------------------------------------------
(setq org-directory "~/Dropbox/org")

(setq org-todo-keywords
        '((sequence
           "☞ TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; An ongoing project that cannot be completed in one step
           "⚔ INPROCESS(s)"  ; A task that is in progress
           "⚑ WAITING(w)"  ; Something is holding up this task; or it is paused
           "|"
           "☟ NEXT(n)"
           "✰ Important(i)"
           "✔ DONE(d)"  ; Task successfully completed
           "✘ CANCELED(c@)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "✍ NOTE(N)"
           "FIXME(f)"
           "☕ BREAK(b)"
           "❤ Love(l)"
           "REVIEW(r)"
           ))) ; Task was completed


(use-package org-starter
  :config
  ;; (add-hook! 'after-init-hook 'org-starter-load-all-files-in-path)
  (org-starter-def "~/Dropbox/org/org-notes"
                   :files
                   ("GTD/gtd.org"                      :agenda t :key "g" :refile (:maxlevel . 5))
                   ("GTD/notes.org"                    :agenda t :key "n" :refile (:maxlevel .5 ))
                   ("GTD/myself.org"                   :agenda t :key "m" :refile (:maxlevel .5 ) )
                   ("GTD/Habit.org"                    :agenda t :key "h" :refile (:maxlevel .5 ))
                   ("post/traveling/traveling.org" :key "t" :refile (:maxlevel .5 ))
                   ("post/myself/love.org"         :key "l" :refile (:maxlevel .5 ))
                   ("post/myself/qing.org"         :key "q" :refile (:maxlevel .5 ))
                   ("post/myself/plan.org"         :key "p" :refile (:maxlevel .5 ))
                   ("GTD/my-books.org"             :agenda t :key "b" :refile (:maxlevel .5 ))
                   ("post/life-thing/life-things.org")
                   ("NSM-GTD/workflow.org"         :agenda t :required t)
                   ("NSM-GTD/NsmOrg.org"           :agenda t :required t)
                   ("art/music.org"                :agenda t :required t)
                   )
  (org-starter-def "~/Dropbox/tmp"
                   :files
                   ("README.org")
                   ("wallpaper.org" :agenda nil)
                   )
)

(after! org
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* [ ] %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)
           ))
)
