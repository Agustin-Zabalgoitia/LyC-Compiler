package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.SymbolTable;
import lyc.compiler.model.*;

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
WHITESPACES = (\s|\t)

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
//TODO: Añadir cotas para las constantes
{CTE_E}         { 
                  st.add(yytext(), ParserSym.CTE_E);
                  return symbol(ParserSym.CTE_E, yytext()); 
                }
{CTE_F}         { 
                  st.add(yytext(), ParserSym.CTE_F);
                  return symbol(ParserSym.CTE_F, yytext()); 
                }
{CTE_S}         {
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
