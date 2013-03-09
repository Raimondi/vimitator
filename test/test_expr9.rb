 require 'helper'

class TestExpr_9 < Test::Unit::TestCase

  def test_scalars
    assert_equal([:expr, [1, :number, 123]],
                 Vimitator::Parser.new.scan_str('123'))

    assert_equal([:expr, [1, :float, 1.23]],
                 Vimitator::Parser.new.scan_str('1.23'))

    assert_equal([:expr, [1, :float, 12.34e+20]],
                 Vimitator::Parser.new.scan_str('12.34e+20'))

    assert_equal([:expr, [1, :float, 12.34e-23]],
                 Vimitator::Parser.new.scan_str('12.34e-23'))

    assert_equal([:expr, [1, :dqstring, '"hi"']],
                 Vimitator::Parser.new.scan_str('"hi"'))

    assert_equal([:expr, [1, :sqstring, "'hi'"]],
                 Vimitator::Parser.new.scan_str("'hi'"))

    assert_equal([:expr, [1, :option, '&textwidth']],
                 Vimitator::Parser.new.scan_str('&textwidth'))

    assert_equal([:expr, [1, :envvar, '$SHELL']],
                 Vimitator::Parser.new.scan_str('$SHELL'))

    assert_equal([:expr, [1, :register, '@a']],
                 Vimitator::Parser.new.scan_str('@a'))
  end

  def test_variables
    assert_equal([:expr, [1, :variable, 'x']],
                 Vimitator::Parser.new.scan_str('x'))

    assert_equal([:expr, [1, :variable, 'abc123']],
                 Vimitator::Parser.new.scan_str('abc123'))

    assert_equal([:expr, [1, :variable, 'a{b}c']],
                 Vimitator::Parser.new.scan_str('a{b}c'))
  end

end
