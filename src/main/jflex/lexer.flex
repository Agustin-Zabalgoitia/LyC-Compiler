package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.SymbolTable;
import lyc.compiler.model.*;
import java.math.BigInteger;
import java.math.BigDecimal;

%%
%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }

  private static String cadenaException(String s, int n) {

    s = s.replace("\n", "\\n").replace("\t","\\t");
    return s.length() <= n ? s : s.substring(0, n-1) + "...";
  }

  private SymbolTable st = SymbolTable.getSymbolTable();

%}

/* Identificador */
ID          = [A-Za-z]+([A-Za-z]|[0-9])*

/* Operadores */
ASIG        = :=
OP_SUMA     = \+
OP_RESTA    = -
OP_MULT     = \*
OP_DIV      = \/

/* Operadores Lógicos */
OPA_MAY     = >
OPA_MEN     = <
OPA_IGUAL   = "=="
OPA_MAIG    = ">="
OPA_MEIG    = "<="

/* Constantes */
CTE_E       = [0-9]+ //Constante entera
CTE_F       = (0"."0|([0-9][0-9]*)?)"."[0-9]* //Constante flotante
CTE_S       = (\"[^\"\n]*\") //Constante string

/* Símbolos */
PAR_ABRE    = \(
PAR_CIER    = \)
LLAV_ABRE   = \{
LLAV_CIER   = \}
COR_ABRE    = \[
COR_CIER    = \]
DOS_PTOS    = :
COMA        = ,


/* Otros */
COMENTARIO  = (#\+.*\+#) //Debería de soportar cualquier nivel de profundidad
LineTerminator = \r|\n|\r\n
Identation =  [ \t\f]
WHITESPACES = {LineTerminator} | {Identation}

%%

{ID}            {
                //En vez de manejar las palabras reservas como tokens del Lexer, las identificamos como ID primero, y después verificamos si son palabras reservadas o no.
                switch(yytext()){
                  /*Lógica*/
                  case "AND":
                    return symbol(ParserSym.OPA_AND);
                  case "OR":
                    return symbol(ParserSym.OPA_OR);
                  case "NOT":
                    return symbol(ParserSym.OPA_NOT);

                  /*Ifelse*/
                  case "if":
                    return symbol(ParserSym.IF);
                  case "else":
                    return symbol(ParserSym.ELSE);

                  /*Bloque de Declaración de Variables*/
                  case "init":
                    return symbol(ParserSym.DECVAR);

                  /*While*/
                  case "while":
                    return symbol(ParserSym.WHILE);

                  /*Entrada y Salida*/
                  case "read":
                    return symbol(ParserSym.ENTRADA);
                  case "write":
                    return symbol(ParserSym.SALIDA);

                  /*Tipo de Datos*/
                  case "Int":
                    return symbol(ParserSym.INT);
                  case "Float":
                    return symbol(ParserSym.FLOAT);
                  case "String":
                    return symbol(ParserSym.STRING);
                  case "Boolean":
                    return symbol(ParserSym.BOOLEAN);

                  /*Identificadores*/
                  default:
                    st.add(yytext(), ParserSym.ID);
                    return symbol(ParserSym.ID, yytext());
                }
              }

/* Operadores */
{ASIG}          { return symbol(ParserSym.ASIG); }
{OP_SUMA}       { return symbol(ParserSym.OP_SUMA); }
{OP_RESTA}      { return symbol(ParserSym.OP_RESTA); }
{OP_MULT}       { return symbol(ParserSym.OP_MULT); }
{OP_DIV}        { return symbol(ParserSym.OP_DIV); }

/* Operadores Lógicos */
{OPA_MAY}       { return symbol(ParserSym.OPA_MAY); }
{OPA_MEN}       { return symbol(ParserSym.OPA_MEN); }
{OPA_IGUAL}     { return symbol(ParserSym.OPA_IGUAL); }
{OPA_MAIG}      { return symbol(ParserSym.OPA_MAIG); }
{OPA_MEIG}      { return symbol(ParserSym.OPA_MEIG); }

/* Constantes */
{CTE_E}         {
                  int maxIntNumberPostive = 32767;
                  int minIntNumberNegative = -32768;
                  java.math.BigInteger num = new java.math.BigInteger(yytext());

                  if(num.compareTo(BigInteger.valueOf(maxIntNumberPostive)) >= 0) {

                      String msg = String.format("error lexico en linea:%d columna:%d => Constante entera numerica (%d) fuera de rango (max %d , min %d)",
                                                  yyline + 1, yycolumn + 1, num, maxIntNumberPostive, minIntNumberNegative);

                      throw new InvalidIntegerException(msg);
                  }

                  else if(num.compareTo(BigInteger.valueOf(minIntNumberNegative)) <= 0) {

                      String msg = String.format("error lexico en linea:%d columna:%d => Constante entera numerica (%d) fuera de rango (max %d , min %d)",
                                                  yyline + 1, yycolumn + 1, num, maxIntNumberPostive, minIntNumberNegative);

                      throw new InvalidIntegerException(msg);

                  }

                  st.add(yytext(), ParserSym.CTE_E);
                  return symbol(ParserSym.CTE_E, yytext());
                }
{CTE_F}         {
                  java.math.BigDecimal maxFloat = BigDecimal.valueOf(Float.MAX_VALUE);
                  java.math.BigDecimal minFloat = BigDecimal.valueOf(Float.MIN_VALUE);
                  java.math.BigDecimal numFloat = new java.math.BigDecimal(yytext());

                  if(numFloat.compareTo(maxFloat) >= 0)  {

                      String msg = String.format("error lexico en linea:%d columna:%d => Constante flotante numerica (%f) fuera de rango (max %f, min %f)",
                                                  yyline + 1, yycolumn + 1, numFloat, maxFloat, minFloat);

                      throw new RuntimeException(msg);
                  }
                  st.add(yytext(), ParserSym.CTE_F);
                  return symbol(ParserSym.CTE_F, yytext());
                }
{CTE_S}         {

                  int maxLength = 50;
                  String cadena = yytext();
                  String c = cadena.substring(1, cadena.length()-1);

                  if(c.length() > maxLength) {
                      String msg = String.format("error lexico en linea:%d columna:%d => Cadena demasiado larga (max %d, llego %d) => \"%s\"",
                                                  yyline + 1, yycolumn + 1, maxLength, c.length(), cadenaException(c, 30));

                      throw new InvalidLengthException(msg);
                  }
                  st.add(yytext(), ParserSym.CTE_S);
                  return symbol(ParserSym.CTE_S, yytext());
                }

/* Símbolos */
{PAR_ABRE}      { return symbol(ParserSym.PAR_ABRE); }
{PAR_CIER}      { return symbol(ParserSym.PAR_CIER); }
{LLAV_ABRE}     { return symbol(ParserSym.LLAV_ABRE); }
{LLAV_CIER}     { return symbol(ParserSym.LLAV_CIER); }
{DOS_PTOS}      { return symbol(ParserSym.DOS_PTOS); }
{COMA}          { return symbol(ParserSym.COMA); }

/*Otros*/
{COMENTARIO}    {/* Acá no pasa nada */}
{WHITESPACES}   {/* Acá tampoco */}

[^]             {
                  String msg = String.format("error lexico en linea:%d columna %d | El caracter '%s' es invalido.", yyline + 1, yycolumn + 1, yytext());
                  throw new UnknownCharacterException(msg);
                }