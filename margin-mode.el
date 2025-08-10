;;; margin-mode.el --- Set margins for windows containing buffers in different major modes, respectively. -*- lexical-binding: t; -*-

;; Author: Kinney Zhang - kinneyzhang666@gmail.com
;; URL: https://github.com/Kinneyzhang/margin-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "26.1"))
;; Keywords: convenience
;;
;;; Commentary:
;; Margin-mode is designed to set left/right margins for windows
;; displaying buffers in different major modes. As is well-known,
;; window margins reset when switching buffers in the current window.

;; Margin-mode ensures margins persist consistently across all scenarios.
;; Beyond maintaining margins, margin-mode supports configurable left/right
;; margins for different major modes (and all their derived modes).

;; When the margin-work-modesvariable is configured, window margins
;; dynamically change without reloading the major mode.
;;
;;; Code:

(defvar margin-left-width 2
  "Default width of left margin.")

(defvar margin-right-width 2
  "Default width of right margin.")

(defcustom margin-work-modes nil
  "A list of Major modes that `margin-mode' would works in.
This variable also supports to set the width of left and \
right margin in multiple formats:
e.g.
1. '(org-mode markdown-mode) means set margin of org-mode\
 and markdown-mode to `margin-left-width' and `margin-right-width'.
2. '((org-mode 2) markdown-mode) means set margin of org-mode\
 to 2, and markdown-mode keep the default.
3. '((org-mode 2 0) markdown-mode) means set left margin of\
 org-mode to 2 and right margin to 0, and markdown-mode keep\
 the default.")

(defun margin-buffer-major-mode (&optional buffer)
  "Return the marjor mode of buffer BUFFER"
  (cdr (assoc 'major-mode
              (buffer-local-variables
               (or buffer (current-buffer))))))

(defun margin-major-mode-chain (mode)
  "A list of major modes which MODE is derived from."
  (let* ((chain (list mode))
         (parent-mode mode))
    (while (setq parent-mode
                 (get parent-mode 'derived-mode-parent))
      (push parent-mode chain))
    (push 'fundamental-mode chain)))

(defun margin-major-mode-derived-p (derived-mode
                                    &optional current-mode)
  "Determine whether CURRENT-MODE is derived from DERIVED-MODE.
If CURRENT-MODE is nil, defaults to major mode of current buffer.
It returns which generation of the parent major mode of current
major mode."
  (when-let* ((modes (major-mode-chain
                      (or current-mode major-mode)))
              (parents (member derived-mode modes)))
    (length parents)))

(defun margin-mode-work-p (&optional buffer)
  "Return the major mode or derived major mode of BUFFER
in `margin-work-modes'."
  (seq-find (lambda (work-mode)
              (let ((mode (if (consp work-mode)
                              (car work-mode)
                            work-mode)))
                (margin-major-mode-derived-p
                 mode (margin-buffer-major-mode buffer))))
            (mapcar (lambda (mode)
                      (if (consp mode)
                          (car mode)
                        mode))
                    margin-work-modes)))

(defun margin-preserve ()
  "Preserve pages' window margin."
  (dolist (window (window-list))
    (if-let*
        ((mode (margin-mode-work-p (window-buffer window)))
         (widths
          (or
           (if-let (width (cdr (assoc mode margin-work-modes)))
               (if (= (length width) 1)
                   (list (car width) (car width))
                 width)
             (list margin-left-width margin-right-width)))))
        (set-window-margins
         window (car widths) (cadr widths))
      (set-window-margins window 0 0))))

(defun margin-watcher (&optional symbol newval operation where)
  "Watcher function when set `margin-work-modes'."
  (unless (equal (symbol-value symbol) newval)
    (set symbol newval)
    (margin-preserve)))

(defun margin-restore ()
  "Set all margins to zero when `margin-mode' is turned off."
  (dolist (window (window-list))
    (when (margin-mode-work-p (window-buffer window))
      (set-window-margins window 0 0))))

(define-minor-mode margin-mode
  "Minor mode for preserving windows margins."
  :lighter " Margin"
  :global t
  (if margin-mode
      (progn
        (margin-preserve)
        (add-hook 'window-configuration-change-hook
                  'margin-preserve)
        (add-variable-watcher 'margin-work-modes
                              'margin-watcher))
    (margin-restore)
    (remove-hook 'window-configuration-change-hook
                 'margin-preserve)
    (remove-variable-watcher 'margin-work-modes
                             'margin-watcher)))

(provide 'margin-mode)
