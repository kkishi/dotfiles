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
(iswitchb-mode 1)
(add-hook 'iswitchb-define-mode-map-hook
          (lambda ()
            (define-key iswitchb-mode-map "\C-n" 'iswitchb-next-match)
            (define-key iswitchb-mode-map "\C-p" 'iswitchb-prev-match)
            (define-key iswitchb-mode-map "\C-f" 'iswitchb-next-match)
            (define-key iswitchb-mode-map "\C-b" 'iswitchb-prev-match)))

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

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
  (package-initialize)
  )

; For golang
(setq-default tab-width 2)
(global-set-key "\C-xo" (lambda () (interactive) (other-window 1)))
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))
(add-hook 'before-save-hook #'gofmt-before-save)

; For goimports
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

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
   (quote
    (magit flycheck clang-format yasnippet color-theme go-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; For Atcoder
(defun ojt ()
  (interactive)
  (save-buffer)
  (shell-command (concat "go run ../../../oj/oj.go -t --file=" (buffer-file-name (current-buffer)))))
(defun ojd ()
  (interactive)
  (save-buffer)
  (shell-command (concat "go run ../../../oj/oj.go -t -dbg --file=" (buffer-file-name (current-buffer)))))
(defun ojs ()
  (interactive)
  (save-buffer)
  (shell-command (concat "go run ../../../oj/oj.go -t -s --file=" (buffer-file-name (current-buffer)))))
(defun ojf ()
  (interactive)
  (save-buffer)
  (shell-command (concat "go run ../../../oj/oj.go -s --file=" (buffer-file-name (current-buffer)))))

; For Yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-indent-line 'fixed)

; For clang-format
(add-hook 'c++-mode-hook
          (function (lambda ()
                      (add-hook 'before-save-hook
                                'clang-format-buffer nil t))))

; For Flycheck
(global-flycheck-mode)

; Open .h files with c++-mode.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; Color theme
(load-theme 'dark-laptop t t)
(enable-theme 'dark-laptop)

; Without these lines, Flycheck complains.
(provide 'emacs)
;;; .emacs ends here
