;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Global Config for Mac
(file-truename "~/.doom.d/")
(setq my_base_path (file-truename "~/Dropbox/emacs"))

(when (eq system-type 'darwin)
  (progn
    (setq envpath (concat my_base_path "/mac"))
    (setq system_font "Kai")
    (setq org-roam-graph-viewer "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
    (message "config for darwin.")
  )
)

(when (eq system-type 'gnu/linux)
  (progn
    (setq envpath (concat my_base_path "/linux"))
    (setq system_font "WenQuanYi Micro Hei Mono-14")
    (setq org-roam-graph-viewer "")
    (message "config for darwin.")
  )
)

(load-file (concat doom-private-dir "/function.el"))


;;;-------------------------------------------------
;; 增加全局快捷键
;;;-------------------------------------------------
;;;跳转gtd文件
(define-prefix-command 'key-cao-map)
(global-set-key (kbd "s-u") 'key-cao-map)
(define-key key-cao-map (kbd "s-j") 'org-starter-find-file-by-key)

;; 暂时取消gpg的使用
;; ~/.authinfo.gpg文件使用明文
;; machine gitlab.kylincloud.org/api/v4 login dancewhale^forge  password  testpass

(epa-file-disable)
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

(use-package org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :bind (:map org-mode-map
         (("C-c n a" . orb-note-actions))))

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))


;;;-------------------------------------------------
;; org-editor启动
;;;-------------------------------------------------
(require 'anki-editor)


;;;-------------------------------------------------
;; rime input-method
;; rime的输入法在doom中的配置的编译失败可以手工介入
;; 在repos中的emacs-rime目录中执行make lib后
;; 把编译好的so和.c文件放入build/rime目录之下。
;;;-------------------------------------------------
(require 'rime)
(setq rime-user-data-dir (concat my_base_path "/chinese/rime"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-journal-date-format "%A, %d %B %Y")
 '(org-journal-date-prefix "#+title: ")
 '(org-journal-dir "~/Dropbox/roam/")
 '(org-journal-file-format "%Y-%m-%d.org")
 '(package-selected-packages (quote (docker org-roam-server)))
 '(rime-librime-root (concat my_base_path "/lib/librime")))

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

(use-package org-journal
  :bind
  ("C-c n j" . org-journal-new-date-entry)
  :custom
  (org-journal-date-prefix  "#+title: ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-dir "~/Dropbox/roam/")
  (org-journal-date-format "%A, %d %B %Y")
 )


;;;-------------------------------------------------
;;; org的个人配置,如何记录、如何作笔记。
;;;-------------------------------------------------
(setq org-directory "~/Dropbox/org")

(setq org-log-into-drawer t)
(setq org-clock-into-drawer t)

(setq org-todo-keywords
        '((sequence
           "PROJ(p)"  ; An ongoing project that cannot be completed in one step
           "TODO(t)"  ; A task that plan todo.
           "WEEKLY(w)"  ; Something that is plan todo this week.
           "STARTED(s!)"  ; Something that is start todo tody.
           "WAIT(W@/!)"  ; Task should wait for some condition for ready.
           "DELAYED(D!)"  ; Task can't complete today delay to reset to STARTED tomorrow.
           "|"
           "DONE(d!)"  ; Task successfully completed
           "CANCELED(c@/!)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "QUESTION(v)"
           "EVENT(e)"
           "NOTE(N)"
           ))) ; Task was completed

;; follow mode in another buffer show tree.
(advice-add 'org-agenda-goto :after
            (lambda (&rest args)
              (org-narrow-to-subtree)))

(setq hl-todo-keyword-faces
      `(("TODO"  . ,(face-foreground 'warning))
        ("STARTED" . ,(face-foreground 'error))
        ("NOTE"  . ,(face-foreground 'success))))


;;;-------------------------------------------------
;;; org-starter的个人配置
;;;-------------------------------------------------
(use-package org-starter
  :config
  (org-starter-def "~/Dropbox/org"
                   :files
                   ("GTD/gtd.org"         :agenda t :key "g" :refile (:maxlevel . 5))
                   ("GTD/notes.org"       :agenda t :key "n" :refile (:maxlevel . 5))
                   ("GTD/thoughts.org"    :agenda t :key "v" :refile (:maxlevel . 5))
                   ("GTD/myself.org"      :agenda t :key "m" :refile (:maxlevel . 5))
                   ("GTD/Habit.org"       :agenda t :key "H" :refile (:maxlevel . 5))
                   ("GTD/events.org"      :agenda t :key "e" :refile (:maxlevel . 5))))

(org-starter-def "~/.org-jira"
                   :files
                   ("CLOUD.org"           :agenda t :key "c" :refile (:maxlevel . 5))
                   ("CON.org"             :agenda t :key "o" :refile (:maxlevel . 5)))

(after! org (setq org-capture-templates nil))

(org-starter-define-file "gtd.org" :directory "~/Dropbox/org/GTD" :agenda t)
(org-starter-define-file "notes.org" :directory "~/Dropbox/org/GTD" :agenda t)
(org-starter-def-capture "w" "Things plan to do." entry
              (file+headline "gtd.org" "Inbox")
                 "* TODO  %?    \t  %^g" :prepend t)
(org-starter-def-capture "v" "清除大脑杂念，纯净心灵." entry
              (file+olp+datetree "thoughts.org" "Inbox")
                 "*  %?    :THOUGHTS:\n %T")
(org-starter-def-capture "m" "My things plan to do." entry
              (file+headline "myself.org" "Inbox")
                 "* TODO  %?    \t  %^g" :prepend t)
(org-starter-def-capture "n" "Notes of think need to write down." entry
              (file+olp+datetree "notes.org" "Inbox")
                 "* NOTE  %?  \n%T" :prepend t)
(org-starter-def-capture "e" "Event happend need to write down." entry
              (file+olp+datetree "events.org" "Inbox")
                 "*  %?    :EVENT:\n %T")
(org-starter-def-capture "h" "Habit" entry (file+headline "Habit.org" "Inbox")
               "* TODO %?  \t %^g\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\") \
                \n:PROPERTIES:\n:STYLE: habit\n:END:\n")


;;;-------------------------------------------------
;;; super-agenda的个人配置
;;;-------------------------------------------------
(use-package! org-super-agenda
  :config
  (add-hook! 'after-init-hook 'org-super-agenda-mode)
  (require 'org-habit)
  (setq
   org-agenda-skip-scheduled-if-done t
   org-agenda-skip-deadline-if-done t
   org-agenda-include-deadlines t
   org-agenda-include-diary nil
   org-agenda-block-separator nil
   org-agenda-compact-blocks t
   org-agenda-start-with-log-mode t)
)

(setq org-journal-enable-agenda-integration t)
(require 'org-super-agenda)
(setq org-agenda-custom-commands
      '(("p" "Plan work of week."
         ((alltodo "" ((org-super-agenda-groups
                        '(
                          (:name "clear."
                                 :file-path "thoughts\\.org"
                                 :order 33)
                          (:name "Things asign to other persion."
                                 :and (:tag  "other"  :file-path "gtd\\.org")
                                 :order 11)
                          (:name "TODAY"
                                 :and (:todo  "STARTED"  :file-path "gtd\\.org")
                                 :order 1)
                          (:name "TOMORROW DELAYED"
                                 :and (:todo  "DELAYED"  :file-path "gtd\\.org")
                                 :order 2)
                          (:name "WEEKLY"
                                 :and (:todo  "WEEKLY"  :file-path "gtd\\.org")
                                 :order 3)
                          (:name "INBOX"
                                 :and (:todo  "TODO"  :file-path "gtd\\.org")
                                 :order 4)
                          (:name "PROJECT"
                                 :and (:todo  "PROJ"  :file-path "gtd\\.org"
                                       :children ( "TODO" "WEEKLY" "STARTED" "DELAYED" "WAIT"))
                                 :order 5)
                          (:name "WAITING"
                                 :and (:todo  "WAIT"  :file-path "gtd\\.org")
                                 :order 6)
                          (:discard (:anything))))))))
        ("j" "work in jira todo.kylincloud.org."
         ((alltodo "" ((org-super-agenda-groups
                        '(
                          (:name "My Work of jira."
                                 :file-path "org-jira"
                                 :order 1)
                          (:discard (:anything))))))))
        ("m" "Plan thing of myself."
         ((alltodo "" ((org-super-agenda-groups
                        '(
                          (:name "clear."
                                 :file-path "thoughts\\.org"
                                 :order 33)
                          (:name "Things is started right now."
                                 :and (:todo "STARTED" :tag "myself")
                                 :order 2)
                          (:name "Things this week plan todo."
                                 :and (:todo "WEEKLY"  :tag "myself")
                                 :order 3)
                          (:name "Things plan todo."
                                 :and (:todo "TODO" :tag "myself")
                                 :order 4)
                          (:name "HABBIT should do for long time."
                                 :and (:todo ("TODO" "PROJ") :file-path "Habit\\.org")
                                 :order 7)
                          (:name "LONG Project that long should to do."
                                 :and (:todo "PROJ" :tag "long" :file-path "myself\\.org")
                                 :order 8)
                          (:name "MIDDLE Project that short should to do."
                                 :and (:todo "PROJ" :tag "middle" :file-path "myself\\.org")
                                 :order 10)
                          (:name "SHORT Project should to do."
                                 :and (:todo "PROJ" :tag "short" :file-path "myself\\.org")
                                 :order 12)
                          (:discard (:anything))))))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "#1E2029")))))
