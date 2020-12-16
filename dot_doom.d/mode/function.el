;;; ~/.doom.d/mode/function.el -*- lexical-binding: t; -*-
;;; 个人代码未解之谜。
;;; code of my self.

(defun openssl-enc (data)
  (let* ((cmd (concat  "echo  -n  " data " | openssl rsautl -encrypt -pubin -oaep "
                        "-inkey ~/.ssh/id_rsa.pub.pem | openssl enc -A -base64")))
    (prog1  (shell-command-to-string cmd)
      ;;(delete-file tmpfile))
    )
  )
)


(defun openssl-dec (data)
  (let* ((cmd (concat "echo -n  " data " | openssl enc -A -base64 -d"
                       " | openssl rsautl -decrypt -oaep -inkey ~/.ssh/id_rsa"))
    (prog1  (shell-command-to-string cmd))
  )
)

