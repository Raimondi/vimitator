 require 'helper'

class TestExpr_1 < Test::Unit::TestCase

  def test_ternary

    assert_equal([:expr,
                 [1, :ternq, [[1, :number, 1],
                   [1, :terns, [[1, :number, 2], [1, :number, 3]]]]]],
                   Vimitator::Parser.new.scan_str('1 ? 2 : 3'))

    assert_equal([:expr,
                 [1, :ternq, [[1, :number, 123],
                   [1, :terns, [[1, :number, 456], [1, :number, 789]]]]]],
                   Vimitator::Parser.new.scan_str('123 ? 456 : 789'))

    assert_equal([:expr,
               [1, :ternq, [[1, :variable, 'ready'],
                 [1, :terns, [[1, :variable, 'go'], [1, :variable, 'wait']]]]]],
                 Vimitator::Parser.new.scan_str('ready ? go : wait'))

    assert_equal([:expr,
                 [1, :ternq, [[1, :add,
                   [[1, :number, 1],
                     [1, :mul, [[1, :number, 2], [1, :number, 3]]]]],
                   [1, :terns, [[1, :add, [[1, :number, 4],
                     [1, :mul, [[1, :number, 5], [1, :number, 6]]]]],
                     [1, :add, [[1, :number, 7],
                       [1, :mul, [[1, :number, 8], [1, :number, 9]]]]]]]]]],
                 Vimitator::Parser.new.scan_str(
                   '1 + 2 * 3 ? 4 + 5 * 6 : 7 + 8 * 9'))

  end

end
