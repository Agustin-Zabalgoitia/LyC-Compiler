@echo off
REM No tengo idea si este script funciona o no porque yo uso Linux.
REM Asegúrense de tener instalado JFlex y CUP.
set compDir=src\main\java\lyc\compiler
set flexDir=src\main\jflex
set cupDir=src\main\cup

echo =============
echo Running JFLEX
echo =============
jflex %flexDir%\flexer.jflex
move %flexDir%\Lexer.java %compDir%
echo =============
echo Running CUP
echo =============
cup -dump %cupDir%\parser.cup
move Parser.java %compDir%
move ParserSym.java %compDir%
echo ====================================
echo Finished updating Flexer and Parser
echo ====================================
