(require 'flymake)

(defun flymake-js-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                    'flymake-create-temp-inplace))
         (local-file (file-relative-name
                     temp-file
                     (file-name-directory buffer-file-name))))
         (list "jscheck" (list local-file))))

(setq flymake-allowed-file-name-masks
      (cons '(".+\\.js$"
              flymake-js-init
              flymake-simple-cleanup
              flymake-get-real-file-name)
              flymake-allowed-file-name-masks))

(setq flymake-err-line-patterns
      (cons '("^.+, line=\\([[:digit:]]+\\), column=\\([[:digit:]]+\\), \\(.+\\)$" nil 1 2 3)
            flymake-err-line-patterns))
(setq flymake-err-line-patterns
      (cons '("^.+: line \\([[:digit:]]+\\), col \\([[:digit:]]+\\), \\(.+\\)$" nil 1 2 3)
            flymake-err-line-patterns))

(add-hook 'find-file-hook 'flymake-find-file-hook)

(provide 'flymake-js)

