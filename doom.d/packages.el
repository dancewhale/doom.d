;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

(package! posframe)

(package! rime
 :recipe(:host github :repo "DogLooksGood/emacs-rime"
 :files ("rime-predicates.el" "rime.el")))

(package! notdeft
  :recipe (:host github :repo "hasu/notdeft" :branch "xapian"))

(package! org-starter)
