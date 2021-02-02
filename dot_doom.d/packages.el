;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el

(package! posframe)

(package! rime
 :recipe(:host github :repo "DogLooksGood/emacs-rime"
 :files ("rime-predicates.el" "rime.el")))

(package! notdeft
  :recipe (:host github :repo "hasu/notdeft" :branch "master"))

(package! org-starter)

(package! org-super-agenda)

(package! org-sql)

(package! org-sidebar)

(package! anki-editor
  :recipe (:host github :repo "louietan/anki-editor" :branch "master"))

(package! doom-snippets :ignore t)

(package! yasnippet-snippets)

(package! org-roam-server
  :recipe (:host github :repo "org-roam/org-roam-server" :branch "master"))

(package! org-roam-bibtex
  :recipe (:host github :repo "org-roam/org-roam-bibtex" :branch "master"))

(package! sis)

(package! org-jira
  :recipe (:host github :repo "ahungry/org-jira" :branch "master"))

(package! org-roam :pin "43831c5819...")
