require File.dirname(__FILE__) + "/helper"

class TokenizerTest < Test::Unit::TestCase
  def setup
    @tokenizer = Vimitator::Parser.new
  end

  def test_string_single_quote
    tokens = @tokenizer.tokenize("let foo = 'hello world'")
    assert_tokens([
                 [:LET, 'let'],
                 [:HEAD, 'foo'],
                 [:ASSIGN, '='],
                 [:SQSTRING, "'hello world'"],
    ], tokens)
  end

  def test_string_double_quote
    tokens = @tokenizer.tokenize('let foo = "hello world"')
    assert_tokens([
                 [:LET, 'let'],
                 [:HEAD, 'foo'],
                 [:ASSIGN, '='],
                 [:DQSTRING, '"hello world"'],
    ], tokens)
  end

  def test_float
    tokens = @tokenizer.tokenize('3.0')
    assert_tokens([[:FLOAT, 3.0]], tokens)

    tokens = @tokenizer.tokenize('3.0e1')
    assert_tokens([[:FLOAT, 30]], tokens)

    tokens = @tokenizer.tokenize('3.0e+1')
    assert_tokens([[:FLOAT, 30]], tokens)

    tokens = @tokenizer.tokenize('0.001')
    assert_tokens([[:FLOAT, 0.001]], tokens)

    tokens = @tokenizer.tokenize('3.0e-1')
    assert_tokens([[:FLOAT, 0.30]], tokens)
  end

  def test_number
    tokens = @tokenizer.tokenize('3')
    assert_tokens([[:NUMBER, 3]], tokens)

    tokens = @tokenizer.tokenize('34')
    assert_tokens([[:NUMBER, 34]], tokens)

    tokens = @tokenizer.tokenize('034')
    assert_tokens([[:NUMBER, 34]], tokens)
  end

  def test_identifier
    tokens = @tokenizer.tokenize("foo")
    assert_tokens([[:HEAD, 'foo']], tokens)
  end

  def test_ignore_identifier
    tokens = @tokenizer.tokenize("0foo")
    assert_tokens([[:NUMBER, 0], [:HEAD, 'foo']], tokens)
  end

  def test_increment
    tokens = @tokenizer.tokenize("let foo += 1")
    assert_tokens([
                 [:LET, 'let'],
                 [:HEAD, 'foo'],
                 [:PLUSASSIGN, '+='],
                 [:NUMBER, 1],
    ], tokens)
  end

  def assert_tokens(expected, actual)
    assert_equal(expected, actual.select { |x| x[0] != :S })
  end

  %w{
    let
  }.each do |kw|
    define_method(:"test_keyword_#{kw}") do
      tokens = @tokenizer.tokenize(kw)
      assert_equal 1, tokens.length
      assert_equal([[kw.upcase.to_sym, kw]], tokens)
    end
  end
  {
    '=~'  => :CMPOP,
    '=~?'  => :CMPOP,
    '=~#'  => :CMPOP,
    '!~'  => :CMPOP,
    '!~?'  => :CMPOP,
    '!~#'  => :CMPOP,
    '=='  => :CMPOP,
    '==?'  => :CMPOP,
    '==#'  => :CMPOP,
    '!='  => :CMPOP,
    '!=?'  => :CMPOP,
    '!=#'  => :CMPOP,
    '<='   => :CMPOP,
    '<=?'   => :CMPOP,
    '<=#'   => :CMPOP,
    '>='   => :CMPOP,
    '>=?'   => :CMPOP,
    '>=#'   => :CMPOP,
    'is'   => :CMPOP,
    'is?'   => :CMPOP,
    'is#'   => :CMPOP,
    'isnot'   => :CMPOP,
    'isnot?'   => :CMPOP,
    'isnot#'   => :CMPOP,
    '||'  => :OR,
    '&&'  => :AND,
    '+='  => :PLUSASSIGN,
    '-='  => :MINUSASSIGN,
    '.='  => :DOTASSIGN,
  }.each do |punctuator, sym|
    define_method(:"test_punctuator_#{sym}") do
      tokens = @tokenizer.tokenize(punctuator)
      assert_equal 1, tokens.length
      assert_equal([[sym, punctuator]], tokens)
    end
  end
end
