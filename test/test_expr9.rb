require 'helper'

class TestExpr_9 < Test::Unit::TestCase

  def test_ints
    assert_equal([1, 123], Vimitator::Parser.new.scan_str('123'))
    assert_equal([1, [[1, "+"], [[1, 123], [1, 456]]]], Vimitator::Parser.new.scan_str('123 + 456'))
  end

end
