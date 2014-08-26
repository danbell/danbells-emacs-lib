# My Emacs lib

Use with a .emacs similar to:

    (setq exec-path (append exec-path '("/home/daniel/local/bin" "/home/daniel/.nvm/v0.8.11/bin")))
    (setenv "PATH" (concat (getenv "PATH") ":/home/daniel/.nvm/v0.8.11/bin"))
        
    (add-to-list 'load-path "~/.emacs-lib")
        
    (load "local/common.el")
        
    (custom-set-variables
      ;; custom-set-variables was added by Custom.
      ;; If you edit it by hand, you could mess it up, so be careful.
      ;; Your init file should contain only one such instance.
      ;; If there is more than one, they won't work right.
    )
    (custom-set-faces
      ;; custom-set-faces was added by Custom.
      ;; If you edit it by hand, you could mess it up, so be careful.
      ;; Your init file should contain only one such instance.
      ;; If there is more than one, they won't work right.
      '(default ((t (:inherit nil :stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))


## Installed packages

ag
flycheck
hide-lines
jade-mode
magit
markdown-mode
