#!/bin/bash
# Run jflex and cup, and move their respective outputs to src/main/java/compiler

compDir="src/main/java/lyc/compiler/"
flexDir="src/main/jflex"
cupDir="src/main/cup"

echo "============="
echo -e "\033[1;33mRunning JFLEX\033[0m"
echo "============="
jflex $flexDir/flexer.jflex
mv $flexDir/Lexer.java $compDir
echo "============="
echo -e "\033[1;33mRunning CUP\033[0m"
echo "============="
cup -dump $cupDir/parser.cup
mv Parser.java $compDir
mv ParserSym.java $compDir
echo "===================================="
echo -e "\033[1;35mFinished updating Flexer and Parser\033[0m"
echo "===================================="