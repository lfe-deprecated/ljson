(defmodule ljson
  (export all)
  (import
    (from lutil-type
          (binary? 1)
          (dict? 1)
          (string? 1)
          (tuple? 1))))

(defun pairs ()
  (dict:new))

(defun pairs (data)
  (dict:from_list data))

(defun encode (data)
  (unicode:characters_to_binary
    (mochijson2:encode (convert data))))

(defun decode (data)
  (deconvert (jiffy:decode data)))

(defun convert (data)
  (cond
    ((pairs? data)
      (pairs->list data))
    ((tuple? data)
      (list data))
    ('true data)))

(defun deconvert
  ((data) (when (is_tuple data))
    (cond
      ((== 1 (tuple_size data))
        (deconvert (element 1 data)))
      ('true data)))
  ((data) (when (is_list data))
    (let ((len (length data))
          (first (lists:nth 1 data)))
      (cond
        ((and (== 1 len) (is_tuple first))
          first)
        ('true data))))
  ((data)
    data))

(defun pairs? (data)
  (dict? data))

(defun pairs->list (pairs)
  (dict:to_list pairs))

(defun get (keys data options)
  (cond
    ((orelse (string? data) (binary? data) (== options #(json)))
      (encode
        (ej:get keys (decode data))))
    ('true
      (ej:get keys data))))

(defun get (keys data)
  (get keys data #()))

(defun prettify (data)
  (print-str (jsx:prettify data)))

(defun minify (data)
  (jsx:minify data))

(defun print (data)
  (io:format "~tp~n" (list data)))

(defun print-str (data)
  (io:format "~ts~n" (list data)))
