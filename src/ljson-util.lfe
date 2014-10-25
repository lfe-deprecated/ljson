(defmodule ljson-util
  (export all))

(defun get-ljson-version ()
  (lutil:get-app-src-version "src/ljson.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(ljson ,(get-ljson-version)))))
