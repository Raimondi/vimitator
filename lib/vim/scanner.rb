require 'rubygems'
require 'lexr'

module Vim
  module Scanner
    def self.scan(source)
      tokens = []
      expr = Lexr.that {
        ident = /[a-zA-Z_][a-zA-Z0-9_]*/
        registers = /[-a-zA-Z0-9"_:.%#=*+~\/]/
        matches /\d+\.\d+(e[-+]?\d+)?/ => :FLOAT
        matches /(0[xX]?)?\d+/               => :NUMBER
        matches /\(/                          => :LPAREN
        matches /\)/                          => :RPAREN
        matches /\[/                          => :LSQUARE
        matches /\]/                          => :RSQUARE
        matches /{/                           => :LCURLY
        matches /}/                           => :RCURLY
        matches /,/                           => :COMMA
        matches /:/                           => :COLON
        matches /;/                           => :SEMICOLON
        matches /#/                           => :HASH
        matches /\./                          => :DOT
        matches /\+/                          => :PLUS
        matches /\*/                          => :STAR
        matches /\?/                          => :QUESTION
        matches /-/                           => :MINUS
        matches /\//                          => :SLASH
        matches /%/                           => :MODULE
        matches /!/                           => :NOT
        matches /&&/                          => :AND
        matches /\|\|/                        => :OR
        matches /[+-.]=/                      => :ASIGN
        matches /([!=<>]~|\bis(not)?\b|[<>])[#?]?/=> :COMPARE
        matches /"(\\.|[^"])*"/               => :DQSTRING
        matches /'(''|[^'])*'/                => :SQSTRING
        matches /(\b[sbwt]:)?[a-zA-Z_]/       => :HEAD
        matches /@#{registers}/               => :REGISTER
        matches /&#{ident}/                   => :OPTION
        matches /$#{ident}/                   => :ENVVAR
        matches /#{ident}#/                   => :NAMESPACE
        matches /[ \t]+/                      => :WHITE
        ignores /\s*/                         => :EOL
      }
      source.each_line {|line|
        lexer = expr.new(line)
        until lexer.end?
          token = lexer.next
          #puts token.inspect
          tokens << token unless token.value.nil?
        end
      }
      # wrap as [id, value] tokens for racc
      # trailing   end   token recast as   END   for racc
      tokens.map {|x| [x.type.upcase, x.value] } << [:END, nil]
    end
  end
end
