(defmodule unit-ljson-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest new-empty
  (is-equal "" (ljson:new)))

(deftest new-data
  (is-equal "" (ljson:new '(""))))
