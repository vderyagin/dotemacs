;;; -*- lexical-binding: t -*-

(custom-set-variables
 '(savehist-file "~/.emacs.d/savehist")
 '(savehist-save-minibuffer-history t)
 '(savehist-additional-variables '(global-mark-ring
                                   ido-work-directory-list
                                   kill-ring
                                   kmacro-ring
                                   projectur-history
                                   regexp-search-ring
                                   register-alist
                                   search-ring)))

(savehist-mode)

(add-hook 'savehist-save-hook
          (lambda ()
            "Remove duplicates in saved variables."
            (mapc
             (lambda (var)
               (when (boundp var)
                 (setq var (delete-dups (symbol-value var)))))
             (append savehist-additional-variables
                     savehist-minibuffer-history-variables))))


(custom-set-variables
 '(recentf-save-file "~/.emacs.d/recentf")
 '(recentf-max-saved-items 3000)
 '(recentf-exclude
   (list
    (rx not-newline "." (or (and "jp" (optional "e") "g")
                            (and "tif" (optional "f"))
                            (and "x" (char "bp") "m")
                            "gif" "bmp" "ico" "png"
                            "zip" "tar" "rar" "xpi" "crx" "oex" "elc" "rbc" "pyc" "class")
     string-end)
    (rx (or "Thumbs.db" "~") string-end))))

(recentf-mode t)
(add-hook 'kill-emacs-hook 'recentf-cleanup)


(custom-set-variables
 '(desktop-path '("~/.emacs.d/"))
 '(desktop-load-locked-desktop t)
 '(desktop-save t)
 '(desktop-save-mode t)
 '(desktop-globals-to-save nil)      ; not needed, `savehist' does the thing
 '(desktop-files-not-to-save
   (rx (or
        (regexp "^/[^/:]*:")
        (regexp "(ftp)$")
        (and ".gpg" string-end)
        "/.emacs.d/recentf"
        (and "loaddefs.el" string-end)
        (and "/" (or "org-clock-save.el" "bmk-bmenu-state.el" "ido-history" "newsrc-dribble") string-end)
        (eval (expand-file-name "~/repos/"))
        (eval (expand-file-name "~/org/")))))
 '(desktop-locals-to-save
   '(desktop-locals-to-save
     truncate-lines
     case-fold-search
     case-replace
     fill-column
     overwrite-mode
     change-log-default-name
     size-indication-mode
     buffer-file-coding-system
     indent-tabs-mode
     show-trailing-whitespace)))

(desktop-save-mode t)
