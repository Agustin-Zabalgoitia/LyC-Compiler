include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
a2	dd	?
_1	dd	1.0
_5	dd	5.0
_10	dd	10.0
_Sali_del_while_ahora_a1_vale_	db	"Sali del while, ahora 'a1' vale: $"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _1 
fstp a1 

fld _5 
fstp a2 

fld a1
fld _1
fxch
fcom
fstsw ax
sahf
jne et_28
INI:
fld a1
fld _10
fxch
fcom
fstsw ax
sahf
jae et_24
fld a1 
fld _1 
fadd
ffree st(0)
fstp a1 
jmp INI
et_24:
displayString _Sali_del_while_ahora_a1_vale_
newLine 
DisplayFloat a1, 2
newLine 
et_28:
MOV AX, 4C00h
INT 21h
END START
