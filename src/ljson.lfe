(defmodule ljson
  (export all))

(include-lib "clj/include/compose.lfe")
(include-lib "clj/include/predicates.lfe")

(defun pairs ()
  (dict:new))

(defun pairs (data)
  (dict:from_list data))

(defun encode (data)
  (-> data
      (convert)
      (mochijson2:encode)
      (unicode:characters_to_binary)))

(defun decode (data)
  (-> data
      (unicode:characters_to_binary)
      (jsx:decode)
      (deconvert)))

(defun convert (data)
  (cond
    ((pairs? data)
      (pairs->list data))
    ((tuple? data)
      (list data))
    ('true data)))

(defun deconvert
  ((`(,data)) (when (is_tuple data))
   data)
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
        (ljson-util:get-in keys (decode data))))
    ('true
      (ljson-util:get-in keys data))))

(defun get (keys data)
  (get keys data ()))

(defun prettify (data)
  (print-str (jsx:prettify data)))

(defun minify (data)
  (jsx:minify data))

(defun print (data)
  (lfe_io:format "~p~n" (list data)))

(defun print-str (data)
  (lfe_io:format "~s~n" (list data)))

(defun read (filename)
  (case (file:read_file filename)
    (`#(ok ,data) (decode data))
    (err err)))

