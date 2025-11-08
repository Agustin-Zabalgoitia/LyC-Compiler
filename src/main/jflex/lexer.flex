package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.Parser;import lyc.compiler.ParserSym;
import lyc.compiler.main.SymbolTable;
import lyc.compiler.model.*;
import java.math.BigDecimal;
import java.math.BigInteger;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return tok(ParserSym.EOF, null);
%eofval}

%{
private java_cup.runtime.Symbol tok(int id, Object val) {
  System.err.printf("LEX %-18s '%s' @%d:%d%n",
      ParserSym.terminalNames[id], yytext(), yyline+1, yycolumn+1);
  return new java_cup.runtime.Symbol(id, yyline+1, yycolumn+1, val);
}

SymbolTable st = SymbolTable.getSymbolTable();

%}

/*
%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}
*/

// Config de exceptions

%{
    private static String cadenaException(String s, int n) {

      s = s.replace("\n", "\\n").replace("\t","\\t");
      return s.length() <= n ? s : s.substring(0, n-1) + "...";
    }

%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = "="
LE = "<="
GE = ">="
G = ">"
L = "<"
Eq = "=="
Neq = "!="
Colon = ":"
Semicolon = ";"
Coma = ","
OpenBracket = "("
CloseBracket = ")"
Letter = [a-zA-Z]
Digit = [0-9]
CTE_S = (\"([^\n\"])*\")
CurlyBracketOpn = "{"
CurlyBracketClsd = "}"
SquareBracketOpn = "["
SquareBracketClsd = "]"


WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+
CuerpoComentario = ([^\+] | \+[^\#] | \+\#\+)*
Comentario = \#\+ {CuerpoComentario} \+\#
FloatConstant = 0?\.([0-9])* | [1-9]([0-9])* \. ([0-9])*

// 0?\.([0-9])* | [1-9]([0-9])* \. ([0-9])*

%%


/* keywords */

   "Int"                                   { return tok(ParserSym.INT, null); }
   "public"                                { return tok(ParserSym.PUBLIC, null); }
   "class"                                 { return tok(ParserSym.CLASS, null); }
   "static"                                { return tok(ParserSym.STATIC, null); }
   "main"                                  { return tok(ParserSym.MAIN, null); }
   "void"                                  { return tok(ParserSym.VOID, null); }
   "String"                                { return tok(ParserSym.STRING, null); }
   "Float"                                 { return tok(ParserSym.FLOAT, null); }
   "init"                                  { return tok(ParserSym.INIT, null); }
   "if"                                    { return tok(ParserSym.IF, null); }
   "else"                                  { return tok(ParserSym.ELSE, null); }
   "AND"                                   { return tok(ParserSym.AND, null); }
   "NOT"                                   { return tok(ParserSym.NOT, null); }
   "OR"                                    { return tok(ParserSym.OR, null); }
   "read"                                  { return tok(ParserSym.READ, null); }
   "write"                                 { return tok(ParserSym.WRITE, null); }
   "while"                                 { return tok(ParserSym.WHILE, null); }
   "isZero"                                { return tok(ParserSym.IS_ZERO, null); }
   "equalExpressions"                      { return tok(ParserSym.EQUAL_EXPR, null); }

<YYINITIAL> {
  /* identifiers */
  {Identifier}                             {
                                                st.addSymbol(yytext(), ParserSym.IDENTIFIER);
                                                return tok(ParserSym.IDENTIFIER, yytext());
                                           }
  /* Constants */
  {IntegerConstant}                        {
                                             int maxIntNumberPostive = 32767;
                                             java.math.BigInteger num = new java.math.BigInteger(yytext());

                                             if(num.compareTo(BigInteger.valueOf(maxIntNumberPostive)) > 0) {

                                                String msg = String.format("error lexico en linea:%d columna:%d => Constante entera numerica positiva (%d) fuera de rango (max %d)",
                                                                            yyline + 1, yycolumn + 1, num, maxIntNumberPostive);

                                                throw new InvalidIntegerException(msg);
                                             }

                                             st.addSymbol(yytext(), ParserSym.INTEGER_CONSTANT);
                                             return tok(ParserSym.INTEGER_CONSTANT, Integer.valueOf(yytext()));
                                            }

    {FloatConstant}                         {
                                                    java.math.BigDecimal maxFloat = BigDecimal.valueOf(Float.MAX_VALUE);
                                                    java.math.BigDecimal minFloat = BigDecimal.valueOf(Float.MIN_VALUE);
                                                    java.math.BigDecimal numFloat = new java.math.BigDecimal(yytext());

                                                    if(numFloat.compareTo(maxFloat) >= 0)  {

                                                        String msg = String.format("error lexico en linea:%d columna:%d => Constante flotante numerica (%f) fuera de rango (max %f, min %f)",
                                                                                   yyline + 1, yycolumn + 1, numFloat, maxFloat, minFloat);

                                                        throw new RuntimeException(msg);
                                                    }

                                                    st.addSymbol(yytext(), ParserSym.FLOAT_CONSTANT);
                                                    return tok(ParserSym.FLOAT_CONSTANT, Float.valueOf(yytext()));
                                             }

    /*{NegativeConstant}                         {
                                                    int minIntNumberNegative = -32768;
                                                    java.math.BigInteger num = new java.math.BigInteger(yytext());

                                                    if(num.compareTo(BigInteger.valueOf(minIntNumberNegative)) < 0) {

                                                        String msg = String.format("error lexico en linea:%d columna:%d => Constante entera numerica negativa (%d) fuera de rango (min %d)",
                                                                                   yyline + 1, yycolumn + 1, num, minIntNumberNegative);

                                                        throw new InvalidIntegerException(msg);

                                                    }

                                                    st.addSymbol(yytext(), ParserSym.NEGATIVE_CONSTANT);
                                                    return tok(ParserSym.NEGATIVE_CONSTANT, yytext());
                                               }*/

  /* Nuestro OwO */

  {CTE_S}                                  {
                                              int maxLength = 50;
                                              String cadena = yytext();
                                              String c = cadena.substring(1, cadena.length()-1);

                                              if(c.length() > maxLength) {
                                                  String msg = String.format("error lexico en linea:%d columna:%d => Cadena demasiado larga (max %d, llego %d) => \"%s\"",
                                                                             yyline + 1, yycolumn + 1, maxLength, c.length(), cadenaException(c, 30));

                                                  throw new InvalidLengthException(msg);
                                              }

                                               st.addSymbol(yytext(), ParserSym.CTE_S);
                                               return tok(ParserSym.CTE_S, c);
                                            }

  {CurlyBracketOpn}                       { return tok(ParserSym.CURLY_BRACKET_OPN, yytext()); }
  {CurlyBracketClsd}                      { return tok(ParserSym.CURLY_BRACKET_CLSD, yytext()); }
  {Semicolon}                             { return tok(ParserSym.SEMICOLON, null); }
  {SquareBracketOpn}                      { return tok(ParserSym.SQUARE_BRACKET_OPN, null); }
  {SquareBracketClsd}                     { return tok(ParserSym.SQUARE_BRACKET_CLSD, null); }
  {Colon}                                 { return tok(ParserSym.COLON, null); }
  {Coma}                                  { return tok(ParserSym.COMA, null); }

  /* operators */
  {Plus}                                    { return tok(ParserSym.PLUS, null); }
  {Sub}                                     { return tok(ParserSym.SUB, null); }
  {Mult}                                    { return tok(ParserSym.MULT, null); }
  {Div}                                     { return tok(ParserSym.DIV, null); }
  {Assig}                                   { return tok(ParserSym.ASSIG, null); }
  {OpenBracket}                             { return tok(ParserSym.OPEN_BRACKET, null); }
  {CloseBracket}                            { return tok(ParserSym.CLOSE_BRACKET, null); }
  {LE}                                      { return tok(ParserSym.LE, null); }
  {GE}                                      { return tok(ParserSym.GE, null); }
  {G}                                       { return tok(ParserSym.G, null); }
  {L}                                       { return tok(ParserSym.L, null); }
  {Eq}                                      { return tok(ParserSym.EQ, null); }
  {Neq}                                     { return tok(ParserSym.NEQ, null); }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
  {Comentario}                   { /* ignore */ }

}


/* error fallback */
[^]                              {
                                    String msg = String.format("error lexico en linea:%d columna %d | El caracter '%s' es invalido.", yyline + 1, yycolumn + 1, yytext());
                                    throw new UnknownCharacterException(msg);
                                 }
