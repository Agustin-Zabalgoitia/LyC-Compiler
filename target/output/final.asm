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
_2	dd	2.0
_a1_es_igual_a_2	db	"a1 es igual a 2$"	,0
_Estoy_adentro_del_2do_while	db	"Estoy adentro del 2do while$"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _1 
fstp a1 

fld _5 
fstp a2 

INI_6:
fld a1
fld a2
fxch
fcom
fstsw ax
sahf
jae et_46
fld a1
fld _2
fxch
fcom
fstsw ax
sahf
jne et_39
displayString _a1_es_igual_a_2
newLine 
INI_19:
fld a1
fld _2
fxch
fcom
fstsw ax
sahf
jne et_34
displayString _Estoy_adentro_del_2do_while
newLine 
fld a1 
fld _1 
fadd
ffree st(0)
fstp a1 
jmp INI_19
et_34:
fld a1 
fld _1 
fsub
ffree st(0)
fstp a1 
et_39:
fld a1 
fld _1 
fadd
ffree st(0)
fstp a1 
jmp INI_6
et_46:
MOV AX, 4C00h
INT 21h
END START
