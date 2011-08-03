(dolist (f '("\\.\\(rb\\|ru\\|rake\\|thor\\|gemspec\\)\\'"
             "\\(rake\\|thor\\|guard\\|gem\\|cap\\|vagrant\\)file\\'"))
  (add-to-list 'auto-mode-alist `(,f . ruby-mode)))

(setq ruby-electric-matching-delimeter-alist nil
      ruby-electric-expand-delimiters-list '(124))

;; Flymake setup
(defun flymake-ruby-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    ;; Invoke ruby with '-c' to get syntax checking
    (list "ruby" (list "-c" local-file))))

(defun flymake-ruby-enable ()
  (when (and buffer-file-name
             (file-writable-p
              (file-name-directory buffer-file-name))
             (file-writable-p buffer-file-name)
             (if (fboundp 'tramp-list-remote-buffers)
                 (not (subsetp
                       (list (current-buffer))
                       (tramp-list-remote-buffers)))
                 t))
    (local-set-key (kbd "C-c e")
                   'flymake-display-err-menu-for-current-line)
    (flymake-mode t)))

(defun my-ruby-mode-hook ()
  (ruby-electric-mode t)
  (turn-on-drag-stuff-mode)
  (setq comment-column 42)
  (flymake-ruby-enable))

(eval-after-load 'ruby-mode
  '(progn
    (require 'ruby-electric)
    (require 'inf-ruby)

    (inf-ruby-keys)
    (define-key inf-ruby-mode-map (kbd "<f1>") 'yari)
    (define-key inf-ruby-mode-map (kbd "C-l") 'recenter-top)

    ;; enable flymake
    (require 'flymake)
    (dolist (f '(".+\\.\\(rb\\|ru\\|rake\\|thor\\|gemspec\\)\\'"
                 "\\([Rr]ake\\|[Tt]hor\\|[Gg]\\(uard\\|em\\)\\|[Cc]ap\\|[Vv]agrant\\)file\\'"))
      (push `(,f flymake-ruby-init) flymake-allowed-file-name-masks))
    (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

    (define-key ruby-mode-map (kbd "<f1>") 'yari)
    (define-key ruby-mode-map (kbd "<return>") 'reindent-then-newline-and-indent)
    (define-key ruby-mode-map (kbd "C-<return>")
     (lambda () (interactive) (move-end-of-line 1) (reindent-then-newline-and-indent)))
    (define-key ruby-mode-map (kbd "M-<return>")
     (lambda () (interactive) (previous-line 1) (move-end-of-line 1) (reindent-then-newline-and-indent)))

    (add-hook 'ruby-mode-hook 'my-ruby-mode-hook)))

;; Clear the compilation buffer between test runs.
(eval-after-load 'ruby-compilation
  '(progn
    (defadvice ruby-do-run-w/compilation
     (before kill-buffer (name cmdlist))
     (let ((comp-buffer-name (format "*%s*" name)))
       (when (get-buffer comp-buffer-name)
         (with-current-buffer comp-buffer-name
           (delete-region (point-min) (point-max))))))
    (ad-activate 'ruby-do-run-w/compilation)))

(eval-after-load 'yari
  '(define-key yari-mode-map (kbd "<f1>") 'yari))


(setq rinari-minor-mode-prefixes '("r")) ; must be set before rinari loading
(require 'rinari)