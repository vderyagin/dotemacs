;;; -*- lexical-binding: t -*-

(require 'ido)

(custom-set-variables
 '(ido-case-fold t)
 '(ido-save-directory-list-file "~/.emacs.d/ido-history")
 '(ido-completion-buffer nil)
 '(ido-confirm-unique-completion t)
 '(ido-create-new-buffer 'prompt)
 '(ido-default-buffer-method 'selected-window)
 '(ido-enable-flex-matching nil)
 '(ido-enable-last-directory-history t)
 '(ido-use-filename-at-point nil)
 '(ido-use-url-at-point nil)
 '(ido-ubiquitous-command-exceptions '(gnus-topic-move-group
                                       bookmark-set))
 '(ido-decorations '("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]"
                     " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))


(add-hook 'ido-minibuffer-setup-hook
          (lambda ()
            "allow line wrapping in the minibuffer"
            (set (make-local-variable 'truncate-lines) nil)))

(add-hook 'ido-setup-hook
          (lambda ()
            "Set up key bindings for use for `ido-mode' completion"
            (mapc
             (lambda (key) (define-key ido-completion-map key nil))
             '([right] [left] [up] [down]))
            (define-key ido-completion-map (kbd "C-p") 'ido-prev-match)
            (define-key ido-completion-map (kbd "C-n") 'ido-next-match)))

(ido-mode t)
(ido-ubiquitous-mode t)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
