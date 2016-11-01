(defmodule ljson-util-tests
  (behaviour ltest-unit)
  ;; Note that `(export all)` is used here in order to make the test data
  ;; availale in the REPL.
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

;;; Support Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun test-data ()
  '(#(#"a" 1)
    #(#"b" 2)
    #(#"c" 3)))

(defun nested-test-data ()
  '(#(#"a" (#(#"b" (#(#"c" 123)))))))

;;; Test Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftest get-by-key
  (is-equal 1 (ljson-util:get 'a (test-data)))
  (is-equal 2 (ljson-util:get 'b (test-data)))
  (is-equal 3 (ljson-util:get 'c (test-data)))
  (is-equal 'undefined (ljson-util:get 'no-key (test-data))))

(deftest get-by-index
  (is-equal 1 (ljson-util:get 1 (test-data)))
  (is-equal 2 (ljson-util:get 2 (test-data)))
  (is-equal 3 (ljson-util:get 3 (test-data))))

(deftest get-in-by-key
  (is-equal 1 (ljson-util:get-in (test-data) '(a)))
  (is-equal 2 (ljson-util:get-in (test-data) '(b)))
  (is-equal 3 (ljson-util:get-in (test-data) '(c))))

(deftest get-in-by-index
  (is-equal 1 (ljson-util:get-in (test-data) '(1)))
  (is-equal 2 (ljson-util:get-in (test-data) '(2)))
  (is-equal 3 (ljson-util:get-in (test-data) '(3))))

(deftest get-in-by-nested-key
  (is-equal '(#(#"b" (#(#"c" 123))))
            (ljson-util:get-in (nested-test-data) '(a)))
  (is-equal '(#(#"c" 123))
            (ljson-util:get-in (nested-test-data) '(a b)))
  (is-equal 123
            (ljson-util:get-in (nested-test-data) '(a b c))))

(deftest get-in-by-nested-index
  (is-equal '(#(#"b" (#(#"c" 123))))
            (ljson-util:get-in (nested-test-data) '(1)))
  (is-equal '(#(#"c" 123))
            (ljson-util:get-in (nested-test-data) '(1 1)))
  (is-equal 123
            (ljson-util:get-in (nested-test-data) '(1 1 1))))

(deftest get-in-nested-mixed
  (is-equal '(#(#"c" 123))
            (ljson-util:get-in (nested-test-data) '(a 1)))
  (is-equal 123
            (ljson-util:get-in (nested-test-data) '(a 1 c)))
  (is-equal '(#(#"c" 123))
            (ljson-util:get-in (nested-test-data) '(1 b)))
  (is-equal 123
            (ljson-util:get-in (nested-test-data) '(1 b 1))))

(deftest convert-key-atom
  (is-equal #"a" (ljson-util:convert-key 'a)))

(deftest convert-key-string
  (is-equal #"a" (ljson-util:convert-key "a")))

(deftest convert-key-binary
  (is-equal #"a" (ljson-util:convert-key #"a"))
  (is-equal #"a" (ljson-util:convert-key #b("a"))))

(deftest convert-key-other
  (is-equal 1 (ljson-util:convert-key 1))
  (is-equal #(a b c) (ljson-util:convert-key #(a b c))))
