;;; vc-msg-hg.el --- extract Perforce(hg) commit message

;; Copyright (C) 2017  Free Software Foundation, Inc.

;; Author: Chen Bin

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;;

;;; Code:
(require 'vc-msg-sdk)

(defvar vc-msg-hg-program "hg")

(defun vc-msg-hg-generate-cmd (opts)
  (format "HGPLAIN=1 LANG=utf-8 %s %s" vc-msg-hg-program opts))

(defun vc-msg-hg-blame-output (cmd)
  (shell-command-to-string cmd))

(defun vc-msg-hg-changelist-output (id)
  (let* ((cmd (vc-msg-hg-generate-cmd (format "log -r %s" id))))
    (shell-command-to-string cmd)))

;;;###autoload
(defun vc-msg-hg-execute (file line-num &optional extra)
  "Use FILE and LINE-NUM to produce hg command.
Parse the command execution output and return a plist:
'(:id str :author str :date str :message str)."
  ;; there is no one comamnd to get the commit information for current line
  (let* ((cmd (vc-msg-hg-generate-cmd (format "blame -wc %s" file)))
         (output (vc-msg-hg-blame-output cmd))
         id)
    ;; I prefer simpler code:
    ;; if output doesn't match certain text pattern
    ;; we assum the command fail
    (cond
     ((setq id (vc-msg-sdk-extract-id-from-output line-num
                                                  "^\\([0-9a-z]+\\):[ \t]+"
                                                  output))
      (when id
        ;; this command should always be successful
        (setq output (vc-msg-hg-changelist-output id))
        (let* (author
               author-time
               author-tz)

          (if (string-match "^user:[ \t]+\\([^ ].*\\)" output)
              (setq author (match-string 1 output)))
          (when (string-match "^date:[ \t]+\\([^ \t].*\\)" output)
            (setq author-time (match-string 1 output))
            (let* ((tz-end (- (length author-time) 5)))
              (setq author-tz (substring-no-properties author-time tz-end))
              (setq author-time (vc-msg-sdk-trim (substring-no-properties author-time 0 tz-end)))))
          (list :id id
                :author author
                :author-time author-time
                :author-tz author-tz
                :summary (vc-msg-sdk-extract-summary "^summary:" output)))))
     (t
      ;; failed, send back the cmd
      cmd))))

;;;###autoload
(defun vc-msg-hg-format (info)
  (format "Commit: %s\nAuthor: %s\nDate: %s\nTimezone: %s\n\n%s"
          (vc-msg-sdk-format-id (plist-get info :id))
          (plist-get info :author)
          (plist-get info :author-time)
          (vc-msg-sdk-format-timezone (plist-get info :author-tz))
          (plist-get info :summary)))

(provide 'vc-msg-hg)
;;; vc-msg-hg.el ends here

