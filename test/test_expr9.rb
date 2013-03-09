require 'helper'

class TestExpr_9 < Test::Unit::TestCase

  def test_ints
    assert_equal(123, Vimitator::Parser.new.scan_str('123'))
  end

end
