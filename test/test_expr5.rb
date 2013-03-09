require 'helper'

class TestExpr_5 < Test::Unit::TestCase

  def test_add_and_mul

    assert_equal([:expr, [1, :add, [[1, :number, 123],
                 [1, :number, 456]]]],
                 Vimitator::Parser.new.scan_str('123 + 456'))

    assert_equal([:expr, [1, :add, [[1, :number, 1],
                 [1, :mul, [[1, :number, 2], [1, :number, 3]]]]]],
                 Vimitator::Parser.new.scan_str('1 + 2 * 3'))

    assert_equal([:expr, [1, :add, [[1, :number, 123],
                 [1, :mul, [[1, :number, 456], [1, :number, 789]]]]]],
                 Vimitator::Parser.new.scan_str('123 + 456 * 789'))

    assert_equal([:expr, [1, :add,
                 [[1, :mul, [[1, :number, 1], [1, :number, 2]]],
                 [1, :number, 3]]]],
                 Vimitator::Parser.new.scan_str('1 * 2 + 3'))

  end

end
