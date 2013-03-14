class Vimitator::Parser

prechigh
  nonassoc UNOT UMINUS UPLUS
  left STAR SLASH
  left PLUS MINUS
  right ASSIGN
preclow

rule

  SourceElements:
    /* nothing */        { result = SourceElementsNode.new([]) }
  | SourceElementList   { result = SourceElementsNode.new([val].flatten) }
  ;

  SourceElementList:
    SourceElement
  | SourceElementList SourceElement {result = val.flatten}
  ;

  SourceElement:
    Statement
  ;

  Statement:
    VariableStatement
  ;

  VariableStatement:
    AssignmentExpression {
      result = ExpressionStatementNode.new(val.first)
      # debug(result)
    }
  ;

  AssignmentExpression:
    LET Variable AssignmentOperator VimExpr {
    result = val[2].new(val[1], val.last)
    }
  ;

  AssignmentOperator:
    ASSIGN      { result = OpEqualNode      }
  | PLUSASSIGN  { result = OpPlusEqualNode  }
  | MINUSASSIGN { result = OpMinusEqualNode }
  | DOTASSIGN   { result = OpDotEqualNode   }
  ;

  VimExpr:
    Expr1 { result = val.first }
  ;

  Expr1:
    Expr2
  | Expr2 QUESTION Expr1 COLON Expr1   {
            result = ConditionalNode.new(val[0], val[2], val[4])
          }
  ;

  Expr2:
    Expr3
  | Expr2 OR Expr3          {result = val}
  ;

  Expr3:
    Expr4
  | Expr3 AND Expr4         {result = val}
  ;

  Expr4:
    Expr5
  | Expr4 CMPOP Expr5       {result = val}
  ;

  Expr5:
    Expr6
  | Expr5 CATDOT Expr6     { result = CatenateNode.new(val[0],val[2])}
  | Expr5 MINUS Expr6      { result = SubtractNode.new(val[0],val[2])}
  | Expr5 PLUS Expr6       { result = AddNode.new(val[0],val[2])}
  ;


  Expr6:
    Expr7
  | Expr6 MODULUS Expr7    { result = ModulusNode.new(val[0],val[2])}
  | Expr6 SLASH Expr7      { result = DivideNode.new(val[0],val[2])}
  | Expr6 STAR Expr7       { result = MultiplyNode.new(val[0],val[2])}
  ;

  Expr7:
    Expr8
  | NOT Expr7     =UNOT     {result = val}
  | MINUS Expr7   =UMINUS   {result = val}
  | PLUS Expr7    =UPLUS    {result = val}
  ;

  Expr8:
    Expr9
  | FuncRefCall
  | DictDot
  | IdxRange
  | Index
  ;

  Index:
    Expr8 LSQUARE Expr1 RSQUARE              {result = val}
  ;

  IdxRange:
    Expr8 LSQUARE Expr1 COLON Expr1 RSQUARE  {result = val}
  | Expr8 LSQUARE COLON Expr1 RSQUARE        {result = val}
  | Expr8 LSQUARE Expr1 COLON RSQUARE        {result = val}
  | Expr8 LSQUARE COLON RSQUARE              {result = val}
  ;

  DictDot:
    Expr8 DICDOT Word                        {result = val}
  ;

  FuncRefCall:
    Expr8 LPAREN ArgList RPAREN             {result = val}
  | Expr8 LPAREN RPAREN                      {result = val}
  ;

  Expr9:
  | REGISTER {result = RegisterNode.new(val.first)}
  | ENVVAR   {result = EnvVarNode.new(val.first)}
  | OPTION   {result = OptionNode.new(val.first)}
  | SQSTRING {result = StringNode.new(val.first)}
  | DQSTRING {result = StringNode.new(val.first)}
  | List
  | Dictionary
  | Nested
  | FuncCall
  | Variable
  | FLOAT     { result = NumberNode.new(val.first) }
  | NUMBER    { result = NumberNode.new(val.first) }
  ;

  Nested:
    LPAREN Expr1 RPAREN             {result = val}
  ;

  Dictionary:
    LCURLY DictList RCURLY          {result = ObjectLiteralNode.new(val[1])}
  | LCURLY RCURLY                   {result = ObjectLiteralNode.new([])}
  ;

  DictList:
    DictItem                        {result = val}
  | DictList COMMA DictItem         {result = [val.first, val.last].flatten}
  ;

  DictItem:
    DictName COLON Expr1            {result = PropertyNode.new(val.first, val.last)}
  ;

  DictName:
    SQSTRING
  | DQSTRING
  | Integer
  ;

  List:
    LSQUARE ExprList RSQUARE        {result = ArrayNode.new(val[1])}
  | LSQUARE RSQUARE                 {result = ArrayNode.new([])}
  ;

  ExprList:
    Expr1                        {result = ElementNode.new(val.first)}
  | ExprList COMMA Expr1         {result = [val.first, ElementNode.new(val[2])].flatten}
  ;

  FuncCall:
    Variable LPAREN ArgList RPAREN {
      result = FunctionCallNode.new(val.first, ArgumentsNode.new(val[2]))
    }
  | Variable LPAREN RPAREN          {
      result = FunctionCallNode.new(val.first, ArgumentsNode.new([]))
    }
  ;

  ArgList:
    Expr1                        {result = val}
  | ArgList COMMA Expr1         {result = [val.first, val[2]].flatten}
  ;

  Variable:
    Ident                           {result = ResolveNode.new(val.join)}
  ;

  Ident:
    StartOfIdent                    {result = val.first}
  | Ident NUMBER                    {result = val[0] + val[1].to_s}
  | Ident NameSpace                 {result = val[0] + val[1]}
  | Ident StartOfIdent              {result = val[0] + val[1]}
  ;

  NameSpace:
    HASH WordChar
  | HASH BraceIdent
  ;

  Word:
    WordChar                              {result = val}
  | Word WordChar                         {result = val}
  ;

  Wordchar:
    NUMBER
  | HEAD
  ;

  StartOfIdent:
    BraceIdent
  | HEAD
  ;

  Integer:
    NUMBER
  | Integer NUMBER
  ;

  BraceIdent:
    LCURLY Variable RCURLY             {result = val.join}
  ;

end

---- header
  require "vimitator/nodes"

---- inner
  include Vimitator::Nodes

