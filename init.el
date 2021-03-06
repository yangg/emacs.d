
(dolist (filename (directory-files user-emacs-directory))
  (let ((file (concat user-emacs-directory filename)))
    (if (equal filename "tomorrow-theme")
        (setq file (concat file "/GNU Emacs")))
    (and (not (member filename '("." ".." ".git" "auto-save-list" "eshell")))
         (file-directory-p file)
         (add-to-list 'load-path file))))

(prefer-coding-system 'utf-8-unix)
;; (set-default-font "Consolas-12")
(require 'linum)
(global-linum-mode t)
;; (setq linum-format "%4d ")
;; (if window-system
;;     (tool-bar-mode nil))
(when (functionp 'tool-bar-mode)
  (tool-bar-mode 0))
;; (menu-bar-mode 0)
(column-number-mode t)
(size-indication-mode t)
(cua-mode 0)
(transient-mark-mode t)
(which-function-mode t)
;; (ido-mode t)
;; (desktop-save-mode t)
(global-auto-revert-mode t)
(pending-delete-mode t)
(setq appt-issue-message t)
(setq auto-save-default nil)
(setq vc-follow-symlinks nil)
(setq x-select-enable-clipboard t)
(setq mouse-drag-copy-region nil)

;; delete moving to trash
(setq delete-by-moving-to-trash t)
(defmacro bypass-trash-in-function (fun)
  `(defadvice ,fun (around no-trash activate)
     "Ignore `delete-by-moving-to-trash' inside this function"
     (let (delete-by-moving-to-trash)
       ad-do-it)))
;; Any server function that may delete the server file should never
;; move it to trash.
(mapc (lambda (fun) (eval `(bypass-trash-in-function ,fun)))
      '(server-start server-sentinel server-force-delete))

;; (setq show-paren-style 'parenthesis)
;; (setq show-paren-delay 0)
(show-paren-mode t)
(set-face-bold-p 'show-paren-match t)
(set-face-foreground 'show-paren-match "red")
(set-face-background 'show-paren-match nil)
(setq line-move-visual nil)
;; (setq frame-title-format "%b - %F")
(setq frame-title-format '(buffer-file-name "%f"))
(setq default-frame-alist '((height . 45) (width . 130)))
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)  ; for aquamacs
(setq default-major-mode 'text-mode)
(setq-default make-backup-files nil)
(setq require-final-newline t)
(setq-default indicate-buffer-boundaries 'left)
(setq-default cursor-type 'bar)
;; (customize-set-variable 'scroll-bar-mode 'left)
;; at begin of line, `kill-line` kills the whole line
;; (setq-default kill-whole-line t)
(setq-default tab-width 4)
(setq tab-stop-list (mapcar (lambda (x) (* x tab-width))
                            (number-sequence 1 40)))
(setq-default indent-tabs-mode nil)
(setq c-basic-offset tab-width
      sgml-basic-offset tab-width)
(fset 'yes-or-no-p 'y-or-n-p)
;; (mouse-avoidance-mode 'animate)
(setq-default line-spacing 3)
;; (setq display-time-24hr-format t)
;; (setq display-time-day-and-date t)
(display-time-mode t)
(windmove-default-keybindings 'meta)
(setq scroll-margin 2
      scroll-conservatively 9999)


(put 'narrow-to-region 'disabled nil)   ; C-x n n / C-x n w
                                        ; C-x n d   narrow-to-defun
(put 'upcase-region 'disabled nil)      ; C-x C-u
(put 'downcase-region 'disabled nil)    ; C-x C-l


;; set keys
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key "\M-g" 'goto-line)      ; override M-g n / M-g p
;; (global-set-key (kbd "C-x k") 'kill-this-buffer)
;; kills text before point on current line
(global-set-key (kbd "C-S-k") '(lambda () (interactive) (kill-line 0)))


;; hooks
(add-hook 'before-save-hook 'time-stamp)


;; eshell
(setq eshell-directory-name (concat user-emacs-directory "eshell"))
;; open file in emacs
(defalias 'eshell/em 'find-file)


(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

(require 'saveplace)
(setq-default save-place t)

(require 'ibuffer)
(global-set-key [remap list-buffers] 'ibuffer)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; redo+
(require 'redo+)
(global-set-key (kbd "C-?") 'redo)

(require 'editorconfig)

(require 'vim-modeline)
(add-to-list 'find-file-hook 'vim-modeline/do)

;; recent
;; (require 'recentf)
(recentf-mode t)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(autoload 'emmet-mode "emmet-mode" "Unflod CSS-selector-like expressions to markup" t)
(add-hook 'sgml-mode-hook 'emmet-mode)

(autoload 'gfm-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.\\(md\\|mkd\\|markdown\\)\\'" . gfm-mode))

(autoload 'less-css-mode "less-css-mode" "Major mode for editing Less files" t)
(add-to-list 'auto-mode-alist '("\\.less\\'" . less-css-mode))

(autoload 'scss-mode "scss-mode" "Major mode for editing SCSS files" t)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(autoload 'js2-mode "js2-mode" "Improved JavaScript editing mode" t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

(autoload 'web-mode "web-mode"
  "An autonomous emacs major-mode for editing web templates: HTML documents embedding CSS / JavaScript and Server blocks" t)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-markup-indent-offset tab-width
      web-mode-css-indent-offset tab-width
      web-mode-code-indent-offset tab-width)
(setq web-mode-style-padding 0
      web-mode-script-padding 0)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-block-face t)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'web-mode-hook '(lambda()
                            (set-face-attribute 'web-mode-current-element-highlight-face nil :background "#222222")
                            (set-face-attribute 'web-mode-block-face nil :background "#393939")))

(autoload 'php-mode "php-mode" "Major mode for editing PHP code" t)
(add-hook 'php-mode-hook '(lambda ()
                            (setq comment-start "//" comment-end "")))
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("/views/.*\\.php\\'" . web-mode))

(when (file-exists-p "/usr/local/go/misc/emacs")
  (add-to-list 'load-path "/usr/local/go/misc/emacs")
  (require 'go-mode-load))

(autoload 'finder-mode "finder-mode" "Find files in project" t)
(global-set-key "\C-xf" 'finder-mode)

;; theme
(require 'tomorrow-night-eighties-theme nil t)

(require 'server)
(unless (server-running-p)
  (server-start))


(defun my-comment-dwim (&optional arg)
  "toogles the comment state of lines (default to current line)"
  (interactive "*P")
  (comment-normalize-vars)
  (if (or mark-active
          (and (looking-at "[ \t]*$")
               (or (= (preceding-char) 10) (= (preceding-char) ?\x20))))
      (comment-dwim arg)
    (comment-or-uncomment-region (line-beginning-position) (line-end-position arg))))
;; (global-set-key (kbd "M-;") 'my-comment-dwim) ; (kbd "M-;") = "\M-;"
(global-set-key [remap comment-dwim] 'my-comment-dwim)

(defun begin-new-line (&optional args)
  "begin a new line below the cursor"
  (interactive "p")
  (end-of-line args)
  (newline-and-indent))
(global-set-key [C-return] 'begin-new-line)
(global-set-key [M-return] '(lambda ()(interactive)(begin-new-line 0)))

(defun kill-other-buffers()
  (interactive)
  (dolist (buf (cdr (buffer-list)))
    (kill-buffer buf)))
(defalias 'only 'kill-other-buffers)

(defun kill-thing (&optional arg)
   (interactive)
   (let ((text (or arg (symbol-at-point))))
     (if (not text)
         (message "no symbol at point")
       (message "`%s' yanked" text)
       (kill-new (format "%s" text)))))
;; copy symbol at point
(global-set-key (kbd "M-W") 'kill-thing)
;; copy filename
(global-set-key (kbd "C-M-w") '(lambda () (interactive) (kill-thing (buffer-file-name))))

(defun goto-matching-sexp ()
  " goto matched pair ([{\"''\"}])"
  (interactive)
  (cond ((looking-at "\\s\(\\|\\s\"")
         (forward-sexp 1))
        ((save-excursion (backward-char 1) (looking-at "\\s\)\\|\\s\""))
         (backward-sexp 1))
        (t (backward-sexp 1))))
(global-set-key [(control ?5)] 'goto-matching-sexp)
;; C-M-k        kill-sexp

(defadvice kill-ring-save (before slickcopy activate compile)
  "copy current line if no region active"
  (interactive
   (if mark-active
       (progn (message "range yanked") (list (region-beginning) (region-end)))
     (message "%s line(s) yanked" 1)
     (list (line-beginning-position) (line-beginning-position 2)))))

(unless (fboundp 'cl-flet)
  (require 'cl)
  (defalias 'cl-flet 'flet))
(defadvice save-buffers-kill-emacs (around no-y-or-n activate)
  "prevent emacs asking 'Modified buffers exists; exit anyway?'"
  (cl-flet ((yes-or-no-p (&rest args) t)
            (y-or-n-p (&rest args) t))
           ad-do-it))


(if (file-readable-p "~/.emacs.local")
    (load "~/.emacs.local"))

;; vim: ft=lisp
