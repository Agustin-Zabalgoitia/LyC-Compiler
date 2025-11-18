include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
a2	dd	?
_4	dd	4.0
auxEE1	dd	?
_2	dd	2.0
auxEE2	dd	?
_Habian_como_minimo_2_expresio	db	"Habian como minimo 2 expresiones iguales$"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _4 
fstp auxEE1 

fld _2 
fld _2 
fadd
ffree st(0)
fstp auxEE2 
fld auxEE2
fld auxEE1
fxch
fcom
fstsw ax
sahf
jne et_15
displayString _Habian_como_minimo_2_expresio
newLine 
et_15:
MOV AX, 4C00h
INT 21h
END START
