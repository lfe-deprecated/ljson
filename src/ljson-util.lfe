(defmodule ljson-util
  (export all))

(defun get-version ()
  (lr3-ver-util:get-app-version 'ljson))

(defun get-versions ()
  (++ (lr3-ver-util:get-versions)
      `(#(ljson ,(get-version)))))

(defun get-value (data)
   (case data
     ('false 'undefined)
     (`#(,_key #(,value)) value)
     (`#(,_key ,value) value)
     (`#(,value) value)
     (value value)))

(defun get
  ((index data) (when (is_integer index))
   (get-value (lists:nth index data)))
  ((key data)
   (get-value (lists:keyfind (convert-key key) 1 data))))

(defun get-in (data keys)
  (lists:foldl #'get/2 data keys))
  ; (clj:get-in data (lists:map #'convert-key/1 keys))

(defun convert-key
  ((key) (when (is_atom key))
   (list_to_binary (atom_to_list key)))
  ((key) (when (is_list key))
   (list_to_binary key))
  ((key)
   key))
