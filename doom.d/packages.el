;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

(package! org-journal)

(package! posframe)

(package! rime
 :recipe(:host github :repo "DogLooksGood/emacs-rime"
	 :files ("rime-predicates.el" "rime.el")))

(package! zetteldeft
  :recipe (:host github :repo "EFLS/zetteldeft" :files ("zetteldeft.el")))

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
