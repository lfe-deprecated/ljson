(defmodule ljson-util
  (export all))

(defun get-ljson-version ()
  (lutil:get-app-src-version "src/ljson.app.src"))

(defun get-versions ()
  (++ (lutil:get-version)
      `(#(ljson ,(get-ljson-version)))))

(defun get
  ((index data) (when (is_integer index))
   (case (lists:nth index data)
     (`#(,value) value)
     (value value)))
  ((key data)
   (case (lists:keyfind (convert-key key) 1 data)
     ('false 'undefined)
     (`#(,_key #(,value)) value)
     (`#(,_key ,value) value))))

(defun get-in (keys data)
  (lists:foldl #'get/2 data keys))

(defun convert-key
  ((key) (when (is_atom key))
   (list_to_binary (atom_to_list key)))
  ((key) (when (is_list key))
   (list_to_binary key))
  ((key)
   key))