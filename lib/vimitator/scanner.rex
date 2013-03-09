module Vimitator
class Parser
macro
  IDENT [a-zA-Z_][a-zA-Z0-9_]*
  DIGIT \d+
  REGISTERS [-a-zA-Z0-9"_:.%=*+~\/]
rule
  {DIGIT} { [:NUMBER, text.to_i] }
  \d+\.\d+(e[-+]?\d+)? { [:FLOAT, text] }
  (0[xX]?)?\d+ { [:NUMBER, text] }
  \( { [:LPAREN, text] }
  \) { [:RPAREN, text] }
  \[ { [:LSQUARE, text] }
  \] { [:RSQUARE, text] }
  { { [:LCURLY, text] }
  } { [:RCURLY, text] }
  , { [:COMMA, text] }
  : { [:COLON, text] }
  ; { [:SEMICOLON, text] }
  # { [:HASH, text] }
  (?<!\s)\.(?!\s) { [:DICDOT, text] }
  \. { [:CATDOT, text] }
  \+ { [:PLUS, text] }
  \* { [:STAR, text] }
  \? { [:QUESTION, text] }
  - { [:MINUS, text] }
  \/ { [:SLASH, text] }
  % { [:MODULUS, text] }
  ! { [:NOT, text] }
  && { [:AND, text] }
  \|\| { [:OR, text] }
  [+-.]= { [:ASSIGN, text] }
  ([!=<>]~|\bis(not)?\b|[<>])[#?]? { [:CMPOP, text] }
  "(\\.|[^"])*" { [:DQSTRING, text] }
  '(''|[^'])*' { [:SQSTRING, text] }
  (\b[sbwt]:)?[a-zA-Z_] { [:HEAD, text] }
  @{REGISTERS} { [:REGISTER, text] }
  &{IDENT} { [:OPTION, text] }
  ${IDENT} { [:ENVVAR, text] }
  {IDENT} { [:IDENTIFIER, text] }
  \s+
inner
end
end