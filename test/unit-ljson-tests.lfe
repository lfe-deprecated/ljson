(defmodule unit-ljson-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest encode-atom
  (is-equal #b("\"a\"") (ljson:encode 'a)))

(deftest encode-string
  (is-equal #b("[97]") (ljson:encode "a")))

(deftest encode-integer
  (is-equal #b("1") (ljson:encode 1)))

(deftest encode-float
  (is-equal #b("3.14") (ljson:encode 3.14)))

(deftest encode-simple-list
  (is-equal #b("[\"a\",\"b\",\"c\",42]") (ljson:encode '(a b c 42))))

(deftest encode-pairs
  (is-equal #b("{\"a\":\"b\"}") (ljson:encode #(a b)))
  (is-equal #b("{\"a\":[98]}") (ljson:encode #(a "b")))
  (is-equal #b("{\"a\":\"b\"}") (ljson:encode #("a" b)))
  (is-equal #b("{\"a\":\"b\",\"c\":\"d\"}") (ljson:encode '(#(a b) #(c d)))))

(deftest encode-complex-list
  (is-equal
    #b("[\"a\",\"b\",[99],[\"d\",[\"e\",[\"f\",\"g\"]]],42,{\"h\":1,\"i\":2.4}]")
    (ljson:encode
      '(a b "c" (d (e (f g))) 42 (#(h 1) #("i" 2.4))))))

(deftest decode-atom
  (is-equal #b("a") (ljson:decode #b("\"a\""))))

(deftest decode-string
  (is-equal "a" (ljson:decode #b("[97]"))))

(deftest decode-integer
  (is-equal 1 (ljson:decode #b("1"))))

(deftest decode-float
  (is-equal 3.14 (ljson:decode #b("3.14"))))

(deftest decode-simple-list
  (is-equal '(#b(97) #b(98) #b(99) 42)
            (ljson:decode #b("[\"a\",\"b\",\"c\",42]"))))

(deftest decode-pairs
  (is-equal #(#b("a") #b("b")) (ljson:decode #b("{\"a\":\"b\"}")))
  (is-equal #(#b(97) "b") (ljson:decode #b("{\"a\":[98]}")))
  (is-equal '(#(#b(97) #b(98)) #(#b(99) #b(100)))
            (ljson:decode #b("{\"a\":\"b\",\"c\":\"d\"}"))))

(deftest decode-complex-list
  (is-equal
    '(#b(97)
      #b(98)
      "c"
      (#b(100) (#b(101) (#b(102) #b(103))))
      42
      #((#(#b(104) 1) #(#b(105) 2.4))))
    (ljson:decode
      #b("[\"a\",\"b\",[99],[\"d\",[\"e\",[\"f\",\"g\"]]],42,{\"h\":1,\"i\":2.4}]"))))
