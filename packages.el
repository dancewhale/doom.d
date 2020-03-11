;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

(package! org-journal)
(package! posframe)
(package! zetteldeft
  :recipe (:host github :repo "EFLS/zetteldeft" :files ("zetteldeft.el")))
(unpin! pyim)

(package! org-roam
  :recipe (:host github :repo "jethrokuan/org-roam" :branch "develop"))
