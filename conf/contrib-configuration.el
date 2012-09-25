(setq irfc-directory "~/doc/RFC")


(define-key global-map (kbd "C-c d") 'drag-stuff-mode)
(define-key global-map (kbd "C-;") 'iedit-mode)
(define-key global-map (kbd "<f7>")
  (lambda (&optional arg)
    (interactive "P")
    (let ((current-prefix-arg (not arg)))
      (scratch))))


(setq ac-comphist-file "~/.emacs.d/ac-comphist.dat"
      ac-auto-show-menu nil
      ac-auto-start nil
      ac-quick-help-delay 0.8)
(eval-after-load 'auto-complete-config
  '(progn
    (add-to-list 'ac-dictionary-directories (expand-file-name "auto-complete/dict" el-get-dir))

    (ac-config-default)

    (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
    (define-key ac-complete-mode-map (kbd "C-n") 'ac-next)
    (define-key ac-complete-mode-map (kbd "C-p") 'ac-previous)
    (define-key ac-complete-mode-map (kbd "C-g") 'ac-stop)
    (define-key ac-complete-mode-map (kbd "<return>") 'ac-expand)))


(setq multi-term-program "/bin/zsh")


(setq paren-delay 0.2
      paren-highlight-offscreen t)
(eval-after-load 'mic-paren
  '(paren-activate))


(setq autopair-skip-whitespace 'chomp)
(autopair-global-mode)


(eval-after-load 'doc-mode
  '(add-hook 'doc-mode-hook
    '(lambda ()
      (turn-on-auto-fill)
      (require 'asciidoc))))


(setq
 ;; display-buffer-function 'popwin:display-buffer
 popwin:popup-window-height 20
 special-display-function 'popwin:special-display-popup-window)
(setq popwin:special-display-config
      '(("*Help*")
        ("*Completions*" :noselect nil)
        ("*Compile-Log*" :noselect t)
        ("*Occur*" :noselect t)
        ("*Async Shell Command*")
        ("*Shell Command Output*")))

(setq special-display-buffer-names
      '("*Help*"
        "*Occur*"
        "*Compile-Log*"
        "*Async Shell Command*"
        "*twittering-edit*"
        "*magit-edit-log*"
        "*Shell Command Output*"
        "*rspec*"
        "*rake*"
        "*ack*"
        "*grep*"
        "*compilation*"
        "*ert*"
        "*ERT list of should forms*"
        "*ERT timings*"
        "*ERT Backtrace*"
        "*ERT Messages*"))
(define-key global-map (kbd "C-h e") 'popwin:messages)
(define-key global-map (kbd "C-z") popwin:keymap)



(defun my-markdown-mode-hook ()
  (setq fill-column 78)
  (turn-on-auto-fill)
  (turn-on-orgtbl))
(eval-after-load 'markdown-mode
  '(add-hook 'markdown-mode-hook 'my-markdown-mode-hook))
(mapc
 (lambda (extension)
   (add-to-list 'auto-mode-alist `(,extension . markdown-mode)))
 '("\\.text\\'" "\\.markdown\\'" "\\.mdo?wn\\'" "\\.mk?dt?\\'"))


(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("nginx.conf\\'" . nginx-mode))


(eval-after-load 'feature-mode
  '(define-key feature-mode-map (kbd "<return>") 'newline-and-indent))
