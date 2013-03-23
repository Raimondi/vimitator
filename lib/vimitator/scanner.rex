module Vimitator
class Parser
macro
  HEAD      [a-zA-Z_][a-zA-Z_]
  IDENT     [a-zA-Z_][a-zA-Z0-9_]*
  DIGIT     \d+
  REGISTERS [-a-zA-Z0-9"_:.%=*+~\/]
rule
  let\b                  { [:LET, text] }
  \d+\.\d+(e[-+]?\d+)?   { [:FLOAT, text.to_f] }
  {DIGIT}                { [:NUMBER, text.to_i] }
  (0[xX]?)?\d+           { [:NUMBER, text] }
  \(                     { [:LPAREN, text] }
  \)                     { [:RPAREN, text] }
  \[                     { [:LSQUARE, text] }
  \]                     { [:RSQUARE, text] }
  {                      { [:LCURLY, text] }
  }                      { [:RCURLY, text] }
  ,                      { [:COMMA, text] }
  :                      { [:COLON, text] }
  ;                      { [:SEMICOLON, text] }
  #                      { [:HASH, text] }
  ([!=<>]~|\bis(not)?\b|[<>])[#?]?  { [:CMPOP, text] }
  =                      { [:ASSIGN, text] }
  \+=                    { [:PLUSASSIGN, text] }
  -=                     { [:MINUSASSIGN, text] }
  \.=                    { [:DOTASSIGN, text] }
  (?<!\s)\.(?!\s)        { [:DICDOT, text] }
  \.                     { [:CATDOT, text] }
  \+                     { [:PLUS, text] }
  \*                     { [:STAR, text] }
  \?                     { [:QUESTION, text] }
  -                      { [:MINUS, text] }
  \/                     { [:SLASH, text] }
  %                      { [:MODULUS, text] }
  !                      { [:NOT, text] }
  &&                     { [:AND, text] }
  \|\|                   { [:OR, text] }
  "(\\.|[^"])*"          { [:DQSTRING, text] }
  '(''|[^'])*'           { [:SQSTRING, text] }
  [sbwt]:                { [:SCOPE, text] }
  [a-zA-Z_]+             { [:HEAD, text] }
  @{REGISTERS}           { [:REGISTER, text] }
  &{HEAD}{IDENT}         { [:OPTION, text] }
  \${IDENT}              { [:ENVVAR, text] }
  \s+                    # ignore
end
end
