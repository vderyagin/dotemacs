;;; -*- lexical-binding: t -*-

(define-key global-map (kbd "C-c f") 'projectur-find-file)

(custom-set-variables
 '(pe/omit-regex (rx (or (and string-start "#")
                         (and "~" string-end)
                         (and ".elc" string-end)
                         (and string-start
                              (or (and ".git" (optional "keep"))
                                  "dist"
                                  "node_modules"
                                  "tmp"
                                  "vendor"
                                  )
                              string-end)))))
