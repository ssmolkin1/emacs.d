(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
;; frame visuals
(add-to-list 'default-frame-alist '(foreground-color . "white"))
(add-to-list 'default-frame-alist '(background-color . "black"))
(add-to-list 'default-frame-alist '(font . "IBM Plex Mono-18"))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
;; Path
(add-to-list 'exec-path "/home/sam/.node_modules_global/bin")
(add-to-list 'exec-path "/home/sam/.local/bin")
(setenv "PATH"
	(concat
	 "/home/sam/.node_modules_global/bin:"
	 "/home/sam/.local/bin:"
	 (getenv "PATH")))
;; Backup
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs-backups"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
;; Packages
(setq package-enable-at-startup nil)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-dabbrev-code-ignore-case t)
 '(custom-safe-themes
   (quote
    ("065efdd71e6d1502877fd5621b984cded01717930639ded0e569e1724d058af8" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(evil-ex-search-persistent-highlight t)
 '(geiser-mode-eval-last-sexp-to-buffer nil)
 '(geiser-mode-start-repl-p t)
 '(haskell-stylish-on-save t)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(magit-commit-arguments (quote ("--all")))
 '(package-selected-packages
   (quote
    (company-c-headers yasnippet dtrt-indent hlint-refactor helm-ag company-solidity intero haskell-mode helm-company company-tern helm-projectile projectile ox-gfm evil-mc indium paredit solidity-mode magit ace-window geiser flycheck evil-surround company-quickhelp company powerline-evil rainbow-delimiters xresources-theme evil-leader helm evil-visual-mark-mode))))

;; Use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Use C-M-x in middle of statement to install file!

;; ========= Custom Commands ===============
(defun my-insert-line-below ()
  "Insert a line below the current line"
  (interactive)
  (save-excursion
    (end-of-line)
    (newline)))

(defun my-insert-line-above ()
  "Insert a line above the current line"
  (interactive)
  (save-excursion
    (previous-line)
    (end-of-line)
    (newline)))

(defun my-delete-line-above ()
  "Delete a line above the current line"
  (interactive)
  (save-excursion
    (previous-line)
    (kill-whole-line)))

(defun my-delete-line-below ()
  "Delete a line below the current line"
  (interactive)
  (save-excursion
    (next-line)
    (kill-whole-line)))

(defun my-paredit-open-curly-and-newline ()
  "Open a curly brace, insert a newline and then close the brace."
  (interactive)
  (paredit-open-curly)
  (newline)
  (save-excursion
    (newline)
    (indent-according-to-mode))
  (indent-according-to-mode))

(defun my-paredit-open-eslint-inline-curly ()
  "Open a curly brace, and leave a space."
  (interactive)
  (paredit-open-curly)
  (insert " ")
  (save-excursion
    (insert " ")))

(defun my-paredit-no-space-before-delims ()
  "Turn off space before delimiters."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil))))

(defun my-theme-prefs ()
  "Load themre, then set cursor colors."
  (interactive)
  (load-theme 'xresources)
  (set-cursor-color "#3498DB"))

(fset 'macro-intero-insert-type
   "\C-u\C-c\C-t")


;; ========= General Resources ===============

;; Indent with spaces
(setq-default indent-tabs-mode nil)

(use-package xresources-theme
  :ensure t)

;; Any custom visual settings must be below this, otherwise, X settings will override!

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-buffers-list)
	 ("C-x r b" . helm-filtered-bookmarks)
	 ("M-y" . helm-show-kill-ring)
         ([S-f10] . helm-recentf)))
  :config
  (helm-mode 1)

(use-package helm-ag
  :ensure t
  :after (helm))

;; (use-package helm-swoop
;;   :ensure t
;;   :after (helm)
;;   :bind
;;     (("M-i" . helm-swoop)
;;     ("M-I" . helm-swoop-back-to-last-point)
;;     ("C-c M-i" . helm-multi-swoop)
;;     ("C-x M-i" . helm-multi-swoop-all)))

(use-package projectile
  :ensure t
  :init
    (setq projectile-completion-system 'helm)
  :config
  (projectile-mode t))

(use-package helm-projectile
  :ensure t
  :config
    (helm-projectile-on))

(use-package ace-window
  :ensure t
  :config
    (global-set-key (kbd "M-o") 'ace-window))

(use-package powerline
  :ensure t)

(use-package powerline-evil
  :ensure t
  :after (powerline)
  :config
  (powerline-evil-vim-color-theme))

;; ========= Evil Mode ===============

(use-package evil-leader
  :ensure t
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    "ia" 'my-insert-line-above
    "ib" 'my-insert-line-below
    "da" 'my-delete-line-above
    "db" 'my-delete-line-below
    "/" 'helm-ag-this-file
    "b" 'my-paredit-open-eslint-inline-curly
    "o" 'helm-projectile
    "c" 'comment-line
    "n" 'linum-mode
    "t" 'my-theme-prefs)
  (evil-leader/set-key-for-mode 'org-mode
    "l" 'org-insert-link)
  (evil-leader/set-key-for-mode 'haskell-mode
    "h" 'hlint-refactor-refactor-at-point
    "H" 'hlint-refactor-refactor-buffer
    "t" 'macro-intero-insert-type
    "j" 'intero-goto-definition
    "g" 'intero-apply-suggestions
    "e" 'intero-repl-eval-region
    "r" 'intero-repl
    "i" 'intero-info)
  (evil-leader/set-key-for-mode 'geiser-mode
    "r" 'geiser-eval-buffer
    "e" 'geiser-eval-region))

(use-package evil
  :ensure t
  :init
  (setq evil-shift-width 2)
  (setq evil-want-fine-undo 1)
  :config
  (evil-mode 1))

(use-package evil-easymotion
  :ensure t
  :config
  (evilem-default-keybindings "SPC"))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-mc
  :ensure t
  :config
    (global-evil-mc-mode 1))

;; (use-package evil-paredit
;;   :ensure t
;;   :config
;;   (add-hook 'prog-mode-hook 'evil-paredit-mode))

;; ========= Completion, Syntax Check, Etc. ===============

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-quickhelp
  :ensure t
  :after (company)
  :config
    (company-quickhelp-mode 1))

(use-package helm-company
  :ensure t
  :after (company)
  :config
    (define-key company-mode-map (kbd "C-:") 'helm-company)
    (define-key company-active-map (kbd "C-:") 'helm-company))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package paredit
  :ensure t
  :config
  (define-key paredit-mode-map (kbd "{") 'my-paredit-open-curly-and-newline)
  (define-key paredit-mode-map (kbd "}") 'paredit-close-curly)
  (add-hook 'prog-mode-hook 'enable-paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; Snippets for many languages, with more installable
(use-package yasnippet
  :ensure t
  :config (yas-global-mode 1))

;; Matches indent setting to that of source file (easy edit foreign files)
(use-package dtrt-indent
  :ensure t
  :config
  (dtrt-indent-mode 1)
  (setq dtrt-indent-mode 1))

;; code folding
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ========= Org mode ===============

;; Github-flavoured markdown export backend
(use-package ox-gfm
  :ensure t)

;; Use visual line mode
(add-hook 'org-mode-hook 'visual-line-mode)

;; Turn on flyspell
(add-hook 'org-mode-hook 'turn-on-flyspell)
;; ... but don't check within embedded snippets
(defadvice org-mode-flyspell-verify (after org-mode-flyspell-verify-hack activate)
  (let* ((rlt ad-return-value)
         (begin-regexp "^[ \t]*#\\+begin_\\(src\\|html\\|latex\\|example\\|quote\\)")
         (end-regexp "^[ \t]*#\\+end_\\(src\\|html\\|latex\\|example\\|quote\\)")
         (case-fold-search t)
         b e)
    (when ad-return-value
      (save-excursion
        (setq b (re-search-backward begin-regexp nil t))
        (if b (setq e (re-search-forward end-regexp nil t))))
      (if (and b e (< (point) e)) (setq rlt nil)))
    (setq ad-return-value rlt)))


;; ========= Scheme ===============
(use-package geiser
  :ensure t)

;; (use-package quack
;;   :ensure t
;;   :after (geiser))

;; ========= Haskell ===============

(use-package haskell-mode
  :ensure t
  :config
  (define-key haskell-mode-map (kbd "C-c h") 'hoogle)
 (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation))

(use-package intero
  :ensure t
  ;; :init (require 'cl)
  :config
  (add-hook 'haskell-mode-hook 'intero-mode)
        (flycheck-add-next-checker 'intero
                                   '(warning . haskell-hlint))
        (define-key intero-mode-map (kbd "M-.") 'intero-goto-definition))
;; had to add eval-when-compile cl to make this work

(add-to-list 'auto-mode-alist '("\\.ghci\\'" . haskell-mode))

(use-package hlint-refactor
  :ensure t)

;; ========= Solidity ===============

(use-package solidity-mode
  :ensure t
  :init
  (setq solidity-solc-path "/usr/bin/solc")
  (setq solidity-solium-path "/home/sam/.node_modules_global/bin/solium")
  ;; (setq flycheck-solidity-solc-addstd-contracts t)
  (setq flycheck-solidity-solium-soliumrcfile "/home/sam/projects/.global_soliumrc/.soliumrc.json")
  (setq solidity-flycheck-solc-checker-active t)
  (setq solidity-flycheck-solium-checker-active t)
  (setq solidity-comment-style 'slash)
  :config
  (add-hook 'solidity-mode-hook 'my-paredit-no-space-before-delims)
  (add-hook 'solidity-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends)
                   (append '((company-solidity company-capf company-dabbrev-code))
                           company-backends)))))

;; ========= JavaScript ===============

;; js2-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-to-list 'load-path "/home/sam/.node_modules_global/lib/node_modules/tern/emacs")
(autoload 'tern-mode "tern.el" nil t)
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))

;; Go to definition binding
;; (define-key js2-mode-map (kbd "M-.") 'js2-jump-to-definition);

(use-package company-tern
  :ensure t
  :config
  (add-to-list 'company-backends 'company-tern))

;;; Using eslint

;; Turn off js2 mode errors & warnings
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(use-package indium
  :ensure t
  :config
  (add-hook 'js2-mode-hook #'indium-interaction-mode)
  (add-hook 'js-mode-hook #'indium-interaction-mode))

;; No line-up indentation

(defun js--proper-indentation-custom (parse-status)
  "Return the proper indentation for the current line."
  (save-excursion
    (back-to-indentation)
    (cond ((nth 4 parse-status)    ; inside comment
           (js--get-c-offset 'c (nth 8 parse-status)))
          ((nth 3 parse-status) 0) ; inside string
          ((eq (char-after) ?#) 0)
          ((save-excursion (js--beginning-of-macro)) 4)
          ;; Indent array comprehension continuation lines specially.
          ((let ((bracket (nth 1 parse-status))
                 beg)
             (and bracket
                  (not (js--same-line bracket))
                  (setq beg (js--indent-in-array-comp bracket))
                  ;; At or after the first loop?
                  (>= (point) beg)
                  (js--array-comp-indentation bracket beg))))
          ((js--ctrl-statement-indentation))
          ((nth 1 parse-status)
           ;; A single closing paren/bracket should be indented at the
           ;; same level as the opening statement. Same goes for
           ;; "case" and "default".
           (let ((same-indent-p (looking-at "[]})]"))
                 (switch-keyword-p (looking-at "default\\_>\\|case\\_>[^:]"))
                 (continued-expr-p (js--continued-expression-p))
                 (original-point (point))
                 (open-symbol (nth 1 parse-status)))
             (goto-char (nth 1 parse-status)) ; go to the opening char
             (skip-syntax-backward " ")
             (when (eq (char-before) ?\)) (backward-list))
             (back-to-indentation)
             (js--maybe-goto-declaration-keyword-end parse-status)
             (let* ((in-switch-p (unless same-indent-p
                                   (looking-at "\\_<switch\\_>")))
                    (same-indent-p (or same-indent-p
                                       (and switch-keyword-p
                                            in-switch-p)))
                    (indent
                     (cond (same-indent-p
                            (current-column))
                           (continued-expr-p
                            (goto-char original-point)
                            ;; Go to beginning line of continued expression.
                            (while (js--continued-expression-p)
                              (forward-line -1))
                            ;; Go to the open symbol if it appears later.
                            (when (> open-symbol (point))
                              (goto-char open-symbol))
                            (back-to-indentation)
                            (+ (current-column)
                               js-indent-level
                               js-expr-indent-offset))
                           (t
                            (+ (current-column) js-indent-level
                               (pcase (char-after (nth 1 parse-status))
                                 (?\( js-paren-indent-offset)
                                 (?\[ js-square-indent-offset)
                                 (?\{ js-curly-indent-offset)))))))
               (if in-switch-p
                   (+ indent js-switch-indent-offset)
                 indent))))
          ((js--continued-expression-p)
           (+ js-indent-level js-expr-indent-offset))
          (t 0))))

(advice-add 'js--proper-indentation :override 'js--proper-indentation-custom)

;; ========= C ===============
;;; Note to self -- I use CC-mode for C

; No space before delimiters
(add-hook 'c-mode-hook 'my-paredit-no-space-before-delims)

; Set indent to 4 spaces
(setq-default c-basic-offset 4)

;; Use a C style
(setq c-default-style "k&r")

;; Use Clang instead of Semantic for completion with company-mode
;; (add-hook 'c-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'company-backends)
;;                  (delete 'company-semantic company-backends))))

;; header file completion with company-mode
(use-package company-c-headers
  :ensure t
  :after (company)
  :config (add-to-list 'company-backends 'company-c-headers))

;; GDB frontend
(setq gdb-many-windows t)
(setq gdb-show-main t)

;; ========= Key Bindings ===============
;; Esc works like in Vim
(global-set-key (kbd "<escape>")      'keyboard-escape-quit)

;; Window resizing
(global-set-key (kbd "S-C-h") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-l") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-j") 'shrink-window)
(global-set-key (kbd "S-C-k") 'enlarge-window)

;; Insert/Delete lines
;; (global-set-key (kbd "C-j") 'my-insert-line-below)
;; (global-set-key (kbd "C-k") 'my-insert-line-above)
;; (global-set-key (kbd "M-j") 'my-delete-line-below)
;; (global-set-key (kbd "M-k") 'my-delete-line-above)

;; ========= Options and visuals ===============

;; Functional visuals
;; ;; Line numbers
(global-linum-mode t)
;; Visuals
(set-face-attribute 'default t :font "IBM Plex Mono-18")
(set-background-color "black")
(set-foreground-color "white")
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode 0)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:background "black" :foreground "gray"))))
 '(company-preview-common ((t (:foreground "gray"))))
 '(company-tooltip-common-selection ((t (:background "white smoke" :foreground "#4B64A0"))))
 '(evil-mc-cursor-bar-face ((t (:foreground "white" :height 1))))
 '(evil-mc-cursor-default-face ((t (:foreground "black" :background "white" :inverse-video nil))))
 '(flycheck-error ((t (:underline (:color "red" :style wave)))))
 '(flycheck-info ((t (:underline (:color "deep sky blue" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "green" :style wave)))))
 '(powerline-active0 ((t (:background "white smoke" :foreground "royal blue"))))
 '(powerline-evil-base-face ((t (:inherit mode-line :foreground "white"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "orange"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "violet"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "orange")))))
