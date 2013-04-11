;;; -*- lexical-binding: t -*-

(require 'dired)
(require 'dired-x)
(require 'dired+)
(require 'dired-details+)

(diredp-toggle-find-file-reuse-dir 1)

(defadvice dired-advertised-find-file (around dired-subst-directory activate)
  "Replace current buffer if file is a directory."
  (interactive)
  (let ((orig (current-buffer))
        (filename (dired-get-filename)))
    ad-do-it
    (when (and (file-directory-p filename)
               (not (eq (current-buffer) orig)))
      (kill-buffer orig))))

(defun dired-up-directory (&optional other-window)
  "Run Dired on parent directory of current directory."
  (interactive "P")
  (let* ((dir (dired-current-directory))
         (orig (current-buffer))
         (up (file-name-directory (directory-file-name dir))))
    (or (dired-goto-file (directory-file-name dir))
        ;; Only try dired-goto-subdir if buffer has more than one dir.
        (and (cdr dired-subdir-alist)
             (dired-goto-subdir up))
        (progn
          (kill-buffer orig)
          (dired up)
          (dired-goto-file dir)))))

(define-key dired-mode-map (kbd "M-n") 'dired-next-subdir-of-current-dir-parent)
(define-key dired-mode-map (kbd "M-p") 'dired-previous-subdir-of-current-dir-parent)
(define-key dired-mode-map (kbd "C-?") 'dired-get-size)
(define-key dired-mode-map (kbd ";") 'dired-up-directory)
(define-key dired-mode-map (kbd "p") 'dired-previous-file-line)
(define-key dired-mode-map (kbd "n") 'dired-next-file-line)
(define-key dired-mode-map (kbd "C-w") 'dired-unmark-backward)
(define-key dired-mode-map (kbd "<down>") nil)
(define-key dired-mode-map (kbd "<up>") nil)
(define-key dired-mode-map (kbd "M-=") nil)
(define-key dired-mode-map (kbd "M-b") 'backward-word)
(define-key dired-mode-map (kbd "<SPC>") 'dired-next-file-line)
(define-key dired-mode-map (kbd "TAB") 'dired-hide-subdir)
(define-key dired-mode-map (kbd "q") (lambda () (interactive) (kill-buffer-ask (current-buffer))))

(add-hook 'dired-mode-hook (lambda () (setq truncate-lines t)))


(eval-after-load 'wdired
  '(progn
    (add-hook 'wdired-mode-hook (lambda () (smartparens-mode t)))

    (define-key wdired-mode-map (kbd "<down>") nil)
    (define-key wdired-mode-map (kbd "<up>") nil)))

(defun dired-next-subdir-of-current-dir-parent (&optional jump)
  "Moves to the n-th next directory of the same level"
  (interactive "P")
  (if (and (dired-up-directory)
           (dired-next-dirline
            (if jump (prefix-numeric-value jump) 1)))
      (diredp-find-file-reuse-dir-buffer)))

(defun dired-previous-subdir-of-current-dir-parent (&optional jump)
  "Moves to the n-th previous directory of the same level"
  (interactive "P")
  (if (and (dired-up-directory)
           (dired-prev-dirline
            (if jump (prefix-numeric-value jump) 1)))
      (diredp-find-file-reuse-dir-buffer)))

(defun dired-get-size ()
  "Get size of marked files"
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message "Size of all marked files: %s"
               (progn
                 (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                 (match-string 1))))))

(defun dired-next-file-line ()
  "Moves to the next line in dired buffer that have a file or directory name on it"
  (interactive)
  (call-interactively 'dired-next-line)
  (if (not (or (dired-move-to-filename) (eobp)))
      (dired-next-file-line)))

(defun dired-previous-file-line ()
  "Moves to the previous line in dired buffer that have a file or directory name on it"
  (interactive)
  (call-interactively 'dired-previous-line)
  (if (not (or (dired-move-to-filename) (bobp)))
      (dired-previous-file-line)))

(defun switch-to-dired-buffer ()
  "Switch to one of the Dired buffers or open home directory if none."
  (interactive)
  (let ((dired-buffers (mapcar 'buffer-name (get-buffers-with-major-mode 'dired-mode))))
    (if dired-buffers
        (switch-to-buffer
         (if (equal 1 (length dired-buffers))
             (car dired-buffers)
             (ido-completing-read "Dired buffer: " dired-buffers)))
        (dired (expand-file-name "~")))))


(custom-set-variables
 '(dired-omit-files (rx line-start (or "." "#")))
 '(dired-details-hidden-string "")
 '(directory-free-space-args "-Pkh")
 '(dired-details-hide-extra-lines t)
 '(dired-details-hide-link-targets nil)
 '(dired-dwim-target nil)
 '(dired-isearch-filenames nil)
 '(dired-keep-marker-copy nil)
 '(dired-keep-marker-hardlink nil)
 '(dired-keep-marker-rename nil)
 '(dired-keep-marker-symlink nil)
 '(dired-listing-switches "-lhAF --group-directories-first")
 '(dired-ls-F-marks-symlinks t)
 '(wdired-allow-to-change-permissions 'advanced)
 '(wdired-allow-to-redirect-links t))
