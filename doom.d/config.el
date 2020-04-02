;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Global Config for Mac
(file-truename "~/.doom.d/")

(when (eq system-type 'darwin)
  (progn
    (setq envpath (file-truename "~/Dropbox/MacForEmacs"))
    (message "config for darwin.")
  )
  (progn
    (message "linux is not in ready.")
  )
)

;;;-------------------------------------------------
;; notdeft配置
;;;-------------------------------------------------
(setq notdeft-xapian-program (concat envpath "/bin/notdeft-xapian"))
(setenv "XAPIAN_CJK_NGRAM" "1")

;;;-------------------------------------------------
;; roam 的配置
;;;-------------------------------------------------
(setq org-directory "~/.deft/")

;;; ----------------------------
;;; global的键位设置
;;; ----------------------------
;;; (define-key org-mode-map (kbd "C-c i") 'org-insert-heading)


;;;-------------------------------------------------
;;; zetteldeft 配置
;;;-------------------------------------------------
;;;防止doom默认配置下zettel-new-file出现双标题.
(set-file-template! 'org-mode :ignore t)
(require 'zetteldeft)
(setq deft-use-filter-string-for-filename nil)

;; zetteldeft的快捷键配置
(global-set-key (kbd "C-c d d") 'deft)
(global-set-key (kbd "C-c d D") 'zetteldeft-deft-new-search)
(global-set-key (kbd "C-c d R") 'deft-refresh)
(global-set-key (kbd "C-c d s") 'zetteldeft-search-at-point)
(global-set-key (kbd "C-c d c") 'zetteldeft-search-current-id)
(global-set-key (kbd "C-c d f") 'zetteldeft-follow-link)
(global-set-key (kbd "C-c d F") 'zetteldeft-avy-file-search-ace-window)
(global-set-key (kbd "C-c d l") 'zetteldeft-avy-link-search)
(global-set-key (kbd "C-c d t") 'zetteldeft-avy-tag-search)
(global-set-key (kbd "C-c d T") 'zetteldeft-tag-buffer)
(global-set-key (kbd "C-c d i") 'zetteldeft-find-file-id-insert)
(global-set-key (kbd "C-c d I") 'zetteldeft-find-file-full-title-insert)
(global-set-key (kbd "C-c d o") 'zetteldeft-find-file)
(global-set-key (kbd "C-c d n") 'zetteldeft-new-file)
(global-set-key (kbd "C-c d N") 'zetteldeft-new-file-and-link)
(global-set-key (kbd "C-c d r") 'zetteldeft-file-rename)
(global-set-key (kbd "C-c d x") 'zetteldeft-count-words)


;;---------------------------------------
;; rime中文输入法设置
;;---------------------------------------
(setq rime-path (concat envpath "/rime"))
(setq liberime-user-data-dir  (concat envpath "/rime/"))
(setq load-path (cons rime-path load-path))
(add-load-path! (file-truename "~/.emacs.d/.local/straight/repos/liberime"))
(require 'liberime-core)
(require 'liberime)

(setq default-input-method "pyim")
(setq pyim-page-tooltip 'posframe)
(setq pyim-page-length 9)

(liberime-start "/Library/Input Methods/Squirrel.app/Contents/SharedSupport" rime-path)
(liberime-select-schema "luna_pinyin_simp")
(setq pyim-default-scheme 'rime-quanpin)

;;自动切换中英文，注释和正文中不输入中文。
(setq-default pyim-english-input-switch-functions
              '(pyim-probe-dynamic-english
                pyim-probe-isearch-mode
                pyim-probe-program-mode
                pyim-probe-org-structure-template))

(setq-default pyim-punctuation-half-width-functions
              '(pyim-probe-punctuation-line-beginning
                pyim-probe-punctuation-after-punctuation))

;强制转换英文为中文，与 pyim-probe-dynamic-english 配合
(global-set-key (kbd "s-j") 'pyim-convert-string-at-point)


;;;-------------------------------------------------
;; org-editor启动
;;;-------------------------------------------------
(require 'anki-editor)


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
;;;my emacs function
;;;-------------------------------------------------

;; I want an easy command for opening new shells:
(defun new-local-shell (name)
  "Opens a new shell buffer with the given name in
asterisks (*name*) in the current directory and changes the
prompt to 'name>'."
  (interactive "sName: ")
  (pop-to-buffer (concat "*" name "*"))
  (unless (eq major-mode 'shell-mode)
    (shell (current-buffer))
    (sleep-for 0 200)
    (delete-region (point-min) (point-max))
    (comint-simple-send (get-buffer-process (current-buffer))
                        (concat "export PS1=\"\033[33m" name "\033[0m:\033[35m\\W\033[0m>\""))))

(global-set-key (kbd "C-c s") 'new-shell)


(setq my-remote-ssh-list `(
                   "/ssh:root@192.168.84.120:/"
                   "/ssh:root@192.168.84.121:/"
                   ,default-directory
                   ))

(defun dfeich/ansi-terminal (&optional name path)
  "Opens an ansi terminal at PATH. If no PATH is given, it uses
the value of `default-directory'. PATH may be a tramp remote path.
The ansi-term buffer is named based on `name' "
  (interactive "sName: ")
  (unless name (setq name "ansi-term"))
  (ansi-term "/bin/bash" name)
  (let* (
         (path (ivy-completing-read "Which host is connecting to?" my-remote-ssh-list))
         (path (replace-regexp-in-string "^file:" "" path))
         (cd-str
          "fn=%s; if test ! -d $fn; then fn=$(dirname $fn); fi; cd $fn;")
         (bufname (concat "*" name "*" )))
    (if (tramp-tramp-file-p path)
        (let ((tstruct (tramp-dissect-file-name path)))
          (cond
           ((equal (tramp-file-name-method tstruct) "ssh")
            (process-send-string bufname (format
                                          (concat  "ssh -t %s '"
                                                   cd-str
                                                   "exec bash'; exec bash; clear\n")
                                          (tramp-file-name-host tstruct)
                                          (tramp-file-name-localname tstruct))))
           (t (error "not implemented for method %s"
                     (tramp-file-name-method tstruct)))))
      (process-send-string bufname (format (concat cd-str " exec bash;clear\n")
                                           path))))
)
