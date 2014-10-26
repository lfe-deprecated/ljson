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

(defun test-data ()
  `(#(#b("First Name") ,(binary ("Jón" utf8)))
    #(#b("Last Name") ,(binary ("Þórson" utf8)))
    #(#b("Is Alive?") true)
    #(#b("Age") 25)
    #(#b("Height_cm") 167.6)
    #(#b("Address")
     #((#(#b("Street Address") ,(binary ("í Gongini 5 Postsmoga 108" utf8)))
       #(#b("City") ,(binary ("Tórshavn" utf8)))
       #(#b("Country") #b("Faroe Islands"))
       #(#b("Postal Code") #b("100")))))
    #(#b("Phone Numbers")
     (#((#(#b("Type") #b("home")) #(#b("Number") #b("20 60 30"))))
      #((#(#b("Type") #b("office")) #(#b("Number") #b("+298 20 60 20"))))))
    #(#b("Children") ())
    #(#b("Spouse") null)))

(defun test-json-data ()
  (ljson:encode (test-data)))

(deftest get-top-level-data
  (is-equal (binary ("Jón" utf8)) (ljson:get #("First Name") (test-data))))

(deftest get-nested-data
  (is-equal (binary ("Tórshavn" utf8)) (ljson:get #("Address" "City") (test-data))))

(deftest get-nested-data-with-index
  (is-equal #b("home")
            (ljson:get #(("Phone Numbers") first "Type") (test-data))))

(deftest get-top-level-json-data
  (is-equal #b("\"J\\u00c3\\u00b3n\"")
            (ljson:get #("First Name") (test-json-data) #(json))))

(deftest get-nested-json-data
  (is-equal #b("\"T\\u00c3\\u00b3rshavn\"")
            (ljson:get #("Address" "City") (test-json-data) #(json))))

(deftest get-nested-json-data-with-index
  (is-equal #b("\"home\"")
            (ljson:get #(("Phone Numbers") first "Type")
                       (test-json-data)
                       #(json))))
