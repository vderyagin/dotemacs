;;; -*- lexical-binding: t -*-

(custom-set-variables
 '(package-enable-at-startup nil)
 '(package-archives '(
                      ("gnu" . "http://elpa.gnu.org/packages/")
                      ("marmalade" . "http://marmalade-repo.org/packages/")
                      ("melpa" . "http://melpa.org/packages/")
                      ("org" . "http://orgmode.org/elpa/")
                      ))
 )

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(mapc
 (lambda (package)
   (unless (package-installed-p package)
     (package-install package)))
 '(
   ac-cider-compliment
   adoc-mode
   auto-complete
   bookmark+
   cider
   clojure-mode
   coffee-mode
   dart-mode
   dired+
   dockerfile-mode
   drag-stuff
   elixir-mode
   emmet-mode
   ensime
   erc-hl-nicks
   fancy-narrow
   git-commit-mode
   go-autocomplete
   go-eldoc
   go-mode
   graphviz-dot-mode
   haml-mode
   helm
   helm-descbinds
   highlight
   iedit
   ledger-mode
   lexbind-mode
   lua-mode
   macrostep
   markdown-mode
   org-plus-contrib
   paredit
   php-mode
   popup
   project-explorer
   rainbow-mode
   rust-mode
   s
   sass-mode
   scala-mode2
   scratch
   slim-mode
   slime
   smart-mode-line
   smartparens
   smex
   textile-mode
   tuareg
   twittering-mode
   web-mode
   yaml-mode
   yari
   yasnippet
   ))

(require 'smart-mode-line)

(sml/setup)
(sml/apply-theme 'respectful)

(setq bookmark-default-file "~/.emacs.d/bookmarks/default")
(require 'bookmark+)

(require 'iedit)
