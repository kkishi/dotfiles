; Assign C-h to backspace.
(global-set-key "\C-h" 'delete-backward-char)

; Do not use the backup functionalities.
(setq make-backup-files nil)
(setq auto-save-default nil)

; Do not use abbrevs.
(setq save-abbrevs nil)
(setq-default abbrev-mode nil)

; Set scroll step to 1.
(setq scroll-step 1)

; No startup message.
(setq inhibit-startup-message t)

; No scratch message.
(setq initial-scratch-message "")

; No menu bar.
(menu-bar-mode 0)

; For iswitch.
; (iswitchb-mode 1)
; (add-hook 'iswitchb-define-mode-map-hook
;           (lambda ()
;             (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
;             (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
;             (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
;             (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))

; Do not truncate lines.
(setq truncate-lines t)
(add-hook 'find-file-hook
          (lambda ()
            (setq truncate-lines t)))

; Highlight trailing spaces and tabs.
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (if (buffer-file-name)   ; Enable only when editing files.
      (font-lock-add-keywords
       major-mode
       '(
         ("　" 0 my-face-b-1 append)
         ("\t" 0 my-face-b-2 append)
         ("[ ]+$" 0 my-face-u-1 append)
         ))))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
                              (if font-lock-mode
                                  nil
                                (font-lock-mode t))) t)

; Do not use tabs for indentation.
(setq-default indent-tabs-mode nil)

; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(defun maybe-install-package (package)
  "Install PACKAGE if not done already."
  (unless (package-installed-p package)
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install package)))

; For golang
(maybe-install-package 'go-mode)
(setq-default tab-width 2)
(global-set-key "\C-xo" (lambda () (interactive) (other-window 1)))
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))

; Use python-mode for bazel files
(add-to-list 'auto-mode-alist '("BUILD" . (lambda () (python-mode))))
(add-to-list 'auto-mode-alist '("WORKSPACE" . (lambda () (python-mode))))

; 2 spaces indentation for JS code
(setq js-indent-level 2)

; https://github.com/bazelbuild/buildtools/wiki/Setting-up-buildifier-with-emacs
(add-hook 'after-save-hook
          (lambda()
            (if (string-match "BUILD" (file-name-base (buffer-file-name)))
                (progn
                  (shell-command (concat "buildifier " (buffer-file-name)))
                  (find-alternate-file (buffer-file-name))))))

; For sh
(setq sh-basic-offset 2)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(gnu-elpa-keyring-update gptel use-package impatient-mode company lsp-mode markdown-mode magit flycheck clang-format color-theme go-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; For Atcoder
(defun clip ()
  "Expand the solution and save it to the clipboard."
  (if (executable-find "clip.exe")
      (shell-command (concat "preprocess --file=" (buffer-file-name (current-buffer)) " | clip.exe")))
  (if (executable-find "xsel")
      (shell-command (concat "preprocess --file=" (buffer-file-name (current-buffer)) " | xsel --clipboard > /dev/null"))))
(defun kill-async-shell-command ()
  "Kill the ongoing async shell command."
  (let ((buf (get-buffer "*Async Shell Command*")))
    (when buf
      (let ((proc (get-buffer-process buf)))
        (when proc (kill-process proc))))))
(defun atcoder (opts)
  "Run atcoder command with the commandline options given as OPTS."
  (save-buffer)
  (clip)
  (kill-async-shell-command)
  (async-shell-command (concat "atcoder " opts " " (buffer-file-name (current-buffer)))))
(defun ojt ()
  "Run oj -t."
  (interactive) (atcoder "-t"))
(defun ojd ()
  "Run oj -t with dbg build."
  (interactive) (atcoder "-t -c dbg"))
(defun ojp ()
  "Run oj -t with prof build."
  (interactive) (atcoder "-t -c prof"))
(defun ojs ()
  "Run oj -t, then oj -submit if the test passes."
  (interactive) (atcoder "-t -s -use_oj_submit"))
(defun ojf ()
  "Run oj -submit without test."
  (interactive)
  (if (y-or-n-p "Force-submit? ") (atcoder "-s -use_oj_submit")))
(define-prefix-command 'oj-map)
(global-set-key "\C-o" 'oj-map)
(define-key 'oj-map "\C-t" 'ojt)
(define-key 'oj-map "\C-d" 'ojd)
(define-key 'oj-map "\C-p" 'ojp)
(define-key 'oj-map "\C-s" 'ojs)
(define-key 'oj-map "\C-f" 'ojf)

; For Codeforces
(defun cff ()
  "Run codeforces submit with the currently edited file."
  (interactive)
  (async-shell-command (concat "codeforces submit " (buffer-file-name (current-buffer)))))

; By default, async-shell-command asks if I want to rename buffer, when multiple
; commands are to run. This skips the confirmation.
(setq async-shell-command-buffer 'rename-buffer)

; Force splitting windows vertically for new buffers (WIP).
(setq split-height-threshold nil)
(setq split-width-threshold 160)

; For clang-format
(add-hook 'c++-mode-hook
          (function (lambda ()
                      (add-hook 'before-save-hook
                                'clang-format-buffer nil t))))

; For Flycheck
(maybe-install-package 'flycheck)
(global-flycheck-mode)

; Open .h files with c++-mode.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; Color theme
(maybe-install-package 'color-theme-modern)
(load-theme 'dark-laptop t t)
(enable-theme 'dark-laptop)

; Do not blink cursor (always on)
(setq visible-cursor nil)

; Process ansi color escape in the shell output. From:
; https://stackoverflow.com/questions/5819719/emacs-shell-command-output-not-showing-ansi-colors-but-the-code?rq=1
; It's said to be a hack, but it works nicely.
(defadvice display-message-or-buffer (before ansi-color activate)
  "Process ANSI color codes in shell output."
  (let ((buf (ad-get-arg 0)))
    (and (bufferp buf)
         (string= (buffer-name buf) "*Shell Command Output*")
         (with-current-buffer buf
                      (ansi-color-apply-on-region (point-min) (point-max))))))

; For ~/dotfiles. Recent Ubuntu versions complain when dot files are symlinked.
(setq vc-follow-symlinks t)

; company
(maybe-install-package 'company)

; https://github.com/golang/tools/blob/master/gopls/doc/emacs.md#loading-lsp-mode-in-emacs
(maybe-install-package 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
     (add-hook 'before-save-hook #'lsp-format-buffer t t)
     (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

; Without these lines, Flycheck complains.
(provide 'emacs)
;;; .emacs ends here

; https://github.com/karthink/gptel
(gptel-make-gemini "Gemini" :key (auth-source-pick-first-password :host "generativelanguage.googleapis.com") :stream t)
