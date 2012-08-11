(setq yas/trigger-key "M-["
      yas/skip-and-clear-key '("C-d")
      yas/also-auto-indent-first-line nil
      yas/good-grace nil
      yas/choose-tables-first t)

(setq yas/prompt-functions
      '(yas/ido-prompt
        yas/dropdown-prompt
        yas/x-prompt
        yas/completing-prompt
        yas/no-prompt))


(eval-after-load 'yasnippet
  '(progn
    (setq yas/snippet-dirs '("~/.emacs.d/yasnippets"))
    (yas/load-snippet-dirs)
    (add-hook 'snippet-mode-hook 'dont-require-final-newline)))

(defun dont-require-final-newline ()
  (setq require-final-newline nil))

;; hook for automatic reloading of changed snippets
(defun yasnippets-recompile-and-reload-on-save ()
  (when (eq major-mode 'snippet-mode)
    (let ((compiled
           (expand-file-name ".yas-compiled-snippets.el"
                             (file-name-directory buffer-file-name))))
      (delete-file compiled))
    (yas/recompile-all)
    (yas/reload-all)))

(add-hook 'after-save-hook 'yasnippets-recompile-and-reload-on-save)

(add-to-list 'auto-mode-alist '("\\.yasnippet\\'" . snippet-mode))

(yas/global-mode t)
