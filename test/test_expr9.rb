require 'helper'

class TestExpr_9 < Test::Unit::TestCase

  def test_ints
    tokens = Vimitator::Scanner.scan('123')
    ast = Vimitator::Parser.new.parse(tokens)
    assert_equal("123", ast)
  end

end
