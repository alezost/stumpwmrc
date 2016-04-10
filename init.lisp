;;; init.lisp --- Vital settings and loading other files

;; Author: Alex Kost <alezost@gmail.com>
;; Created: 28 Jun 2013

;;; Commentary:

;; This file should be symlinked by "~/.stumpwmrc".
;; I compile stumpwm with swank, so i don't need to load it.

;;; Code:

(in-package :stumpwm)

(defvar al/display-number
  (multiple-value-bind (_ array)
      (cl-ppcre:scan-to-strings ":([0-9]+)" (getenv "DISPLAY"))
    (declare (ignore _))
    (if (vectorp array)
        (parse-integer (aref array 0))
        0))
  "The number of the current DISPLAY.")

(swank:create-server
 :dont-close t
 :port (+ swank::default-server-port al/display-number))


;;; Loading additional rc files

(defvar al/init-directory
  (directory-namestring
   (truename (merge-pathnames (user-homedir-pathname)
                              ".stumpwmrc")))
  "A directory with initially loaded files.")

(defun al/load (filename)
  "Load a file FILENAME (without extension) from `al/init-directory'."
  (let ((file (merge-pathnames (concat filename ".lisp")
                               al/init-directory)))
    (if (probe-file file)
        (load file)
        (format *error-output* "File '~a' doesn't exist." file))))

(set-module-dir
 (pathname-as-directory (concat (getenv "HOME")
                                "/src/stumpwm-contrib")))
(al/load "keys")
(al/load "utils")
(al/load "layouts")
(al/load "mana")
(al/load "setaudio")
(al/load "settings")
(al/load "visual")

;;; init.lisp ends here
