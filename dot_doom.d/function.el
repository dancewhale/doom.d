;;; function.el -*- lexical-binding: t; -*-

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
