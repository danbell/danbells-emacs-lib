(fset 'yes-or-no-p 'y-or-n-p)

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist '(("." . "~/.emacs-lib/saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups

(load "nxhtml/autostart.el")
(global-set-key (kbd "C-c C-c") 'nxml-complete)

(global-set-key (kbd "C-x M-r") 'revert-buffer)
(global-set-key (kbd "C-c g") 'goto-line)

(set-variable 'js-indent-level 2)

(require 'jade-mode)

;; javascript lint
(defun jslint-thisfile ()
  (interactive)
  (compile (format "jsl -process %s" (buffer-file-name))))

(require 'flymake-js)
(add-hook 'expresso-mode-hook
          (lambda () (flymake-mode t)))

(add-to-list 'auto-mode-alist '("\\.json" . js-mode))

;;(add-hook 'javascript-mode-hook
;;  '(lambda ()
;;  (local-set-key [f8] 'jslint-thisfile)))

(require 'magit)
(global-set-key (kbd "C-c C-g") 'magit-status)

(add-to-list 'load-path "~/.emacs-lib/yasnippet-0.6.1c")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs-lib/yasnippet-0.6.1c/snippets")

(add-to-list 'load-path "~/.emacs-lib/cucumber")
(load "feature-mode")

;; load bundle snippets
(yas/load-directory "~/.emacs-lib/cucumber/snippets")

(add-to-list 'auto-mode-alist '("\\.feature" . feature-mode))
(add-to-list 'auto-mode-alist '("\\.story" . feature-mode))

(require 'find-file-in-tags)
(global-set-key (kbd "C-c C-f") 'find-file-in-tags)

;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)

;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks 
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))))

;; from http://www.emacswiki.org/emacs/SwitchingBuffers#toc5
(defun switch-buffers-between-frames ()
  "switch-buffers-between-frames switches the buffers between the two last frames"
  (interactive)
  (let ((this-frame-buffer nil)
        (other-frame-buffer nil))
    (setq this-frame-buffer (car (frame-parameter nil 'buffer-list)))
    (other-frame 1)
    (setq other-frame-buffer (car (frame-parameter nil 'buffer-list)))
    (switch-to-buffer this-frame-buffer)
    (other-frame 1)
    (switch-to-buffer other-frame-buffer)))
(global-set-key (kbd "C-c b") 'switch-buffers-between-frames)

;; for creating zip files
(eval-after-load "dired"
  '(define-key dired-mode-map "z" 'dired-zip-files))
(defun dired-zip-files (zip-file)
  "Create an archive containing the marked files."
  (interactive "sEnter name of zip file: ")

  ;; create the zip file
  (let ((zip-file (if (string-match ".zip$" zip-file) zip-file (concat zip-file ".zip"))))
    (shell-command 
     (concat "zip " 
             zip-file
             " "
             (concat-string-list 
              (mapcar
               '(lambda (filename)
                  (file-name-nondirectory filename))
               (dired-get-marked-files))))))

  (revert-buffer)

  ;; remove the mark on all the files  "*" to " "
  ;; (dired-change-marks 42 ?\040)
  ;; mark zip file
  ;; (dired-mark-files-regexp (filename-to-regexp zip-file))
  )

(defun concat-string-list (list) 
   "Return a string which is a concatenation of all elements of the list separated by spaces" 
    (mapconcat '(lambda (obj) (format "%s" obj)) list " "))

(defun find-next-unsafe-char (&optional coding-system)
  "Find the next character in the buffer that cannot be encoded by
coding-system. If coding-system is unspecified, default to the coding
system that would be used to save this buffer. With prefix argument,
prompt the user for a coding system."
  (interactive "Zcoding-system: ")
  (if (stringp coding-system) (setq coding-system (intern coding-system)))
  (if coding-system nil
    (setq coding-system
          (or save-buffer-coding-system buffer-file-coding-system)))
  (let ((found nil) (char nil) (csets nil) (safe nil))
    (setq safe (coding-system-get coding-system 'safe-chars))
    ;; some systems merely specify the charsets as ones they can encode:
    (setq csets (coding-system-get coding-system 'safe-charsets))
    (save-excursion
      ;;(message "zoom to <")
      (let ((end  (point-max))
            (here (point    ))
            (char  nil))
        (while (and (< here end) (not found))
          (setq char (char-after here))
          (if (or (eq safe t)
                  (< char ?\177)
                  (and safe  (aref safe char))
                  (and csets (memq (char-charset char) csets)))
              nil ;; safe char, noop
            (setq found (cons here char)))
          (setq here (1+ here))) ))
    (and found (goto-char (1+ (car found))))
    found))

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!"))

(autoload 'log4j-mode "log4j-mode" "Major mode for viewing log files." t)
(add-to-list 'auto-mode-alist '("\\.log\\'" . log4j-mode))

(autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
(global-set-key "\C-ch" 'hide-lines)

(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
