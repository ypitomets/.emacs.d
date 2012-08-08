;; setting Super ＆ Hyper keys for the Mac keyboard, for emacs running in OS X
;(setq mac-option-modifier 'super) ; sets the Option(Alt) key as Super
;(setq mac-command-modifier 'meta) ; sets the Command key as Meta

(require 'package)
(add-to-list 'package-archives
             '("ELPA" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("gnu" . "http://marmalade-repo.org/packages/" ) t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("sunrise" . "http://joseito.republika.pl/sunrise-commander/") t)
(package-initialize)

;;bookmarks
(setq 
  bookmark-default-file "~/.emacs.d/bookmarks" ;; keep my ~/ clean
  bookmark-save-flag 1)                        ;; autosave each change


;; list of required packages:
(when (not package-archive-contents)
  (package-refresh-contents))

;; packages to install 
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings starter-kit-eshell tabbar sunrise-commander) "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; font size (set-face-font 'default "7x14")

;;go to last edit point
(require 'goto-last-change)
(global-set-key  (kbd "C-q") 'goto-last-change)

;; Esc-Esc combinations
(global-set-key (kbd "\e\el") 'goto-line)

;;environment variables
(setenv "PATH"
     (concat (getenv "PATH")  ":/bin:/usr/local/bin:/usr/usr/texbin/latex:/usr/texbin/xdvi"))

;;AUCTex
(require 'tex-site)

;;Octave
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;;aspell
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;;tabbar
(require 'tabbar)
(tabbar-mode t)

;;cua
(cua-mode t)

(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
This function is a custom function for tabbar-mode's tabbar-buffer-groups.
This function group all buffers into 3 groups:
Those Dired, those user buffer, and those emacs buffer.
Emacs buffer are those starting with “*”."
  (list
   (cond
    ((string-equal "*" (substring (buffer-name) 0 1))
     "Emacs Buffer"
     )
    ((eq major-mode 'dired-mode)
     "Dired"
     )
    (t
     "User Buffer"
     )
    ))) 
(setq tabbar-buffer-groups-function 'tabbar-buffer-groups)
;; 
(global-set-key (kbd "s-}") 'tabbar-forward)
(global-set-key (kbd "s-{") 'tabbar-backward)

;; Esc-Esc combinations
(global-set-key (kbd "\e\el") 'goto-line)

;; (global-set-key (kbd "C-x C-<left>") 'tabbar-backward-group)

;; duplicate line - with undo and hookers
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")
  
  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

  ;; put the point in the lowest line and return
  (next-line arg))
(global-set-key (kbd "s-d") 'duplicate-line)

;;copy line (copy whole line)
(defun jao-copy-line ()
  "Copy current line in the kill ring"
  (interactive)
  (kill-ring-save (line-beginning-position) 
                  (line-beginning-position 2))
  (message "Line copied"))
(global-set-key (kbd "s-e") 'jao-copy-line)



;;TRAMP settings - for ssh
;;(add-to-list 'tramp-default-proxies-alist '(".*" "\`root\'" "/ssh:%h:"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column 80))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
