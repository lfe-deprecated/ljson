(defmodule ljson
  (export all)
  (import
    (from lutil-type
          (dict? 1)
          (tuple? 1))))

(defun pairs ()
  (dict:new))

(defun pairs (data)
  (dict:from_list data))

(defun encode (data)
  (list_to_binary
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

(defun print (data)
  (io:format "~p~n" (list data)))

(defun prettify (data)
  (io:format "~s~n" (list (jsx:prettify data))))

(defun minify (data)
  (jsx:minify data))
