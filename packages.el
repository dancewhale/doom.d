;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

(package! org-journal)

(package! posframe)

(package! liberime
  :recipe (:host github :repo "merrickluo/liberime" :files ("liberime.el" "liberime-config.el")))
(unpin! pyim)
(package! zetteldeft
  :recipe (:host github :repo "EFLS/zetteldeft" :files ("zetteldeft.el")))

(package! org-roam
  :recipe (:host github :repo "jethrokuan/org-roam" :branch "master"))

(package! anki-editor
  :recipe (:host github :repo "louietan/anki-editor" :branch "master"))

(package! xah-fly-keys
  :recipe (:host github :repo "xahlee/xah-fly-keys" :branch "master"))

;; https://github.com/railwaycat/homebrew-emacsmacport/issues/52
;; 解决mac下的emacs-mac包 lacks multi-tty support 的问题.
;; (package! mac-pseudo-daemon
;;  :recipe (:host github :repo "DarwinAwardWinner/mac-pseudo-daemon" ))

(package! notdeft
  :recipe (:host github :repo "hasu/notdeft" :branch "xapian"))
