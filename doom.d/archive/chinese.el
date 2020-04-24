;;; /opt/cao-emacs/doom.d/archive/chinese.el -*- lexical-binding: t; -*-

;;---------------------------------------
;; liberime中文输入法设置
;;---------------------------------------
(setq rime-path (concat envpath "/libForBuild/lib"))
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

;;强制转换英文为中文，与 pyim-probe-dynamic-english 配合
(global-set-key (kbd "s-j") 'pyim-convert-string-at-point)
