include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a	dd	?
b	dd	?
c	dd	?
d	dd	?
e	dd	?
_3	dd	3.0
_5	dd	5.0
_El_valor_de_a_es_al_de_b_	db	"El valor de 'a' es > al de 'b'$"	,0
_El_valor_de_a_no_es_al_de_b	db	"El valor de 'a' no es > al de 'b$"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _3 
fstp a 

fld _5 
fstp b 

fld a
fld b
fxch
fcom
fstsw ax
sahf
jna et_15
displayString _El_valor_de_a_es_al_de_b_
newLine 
jmp et_17
et_15:
displayString _El_valor_de_a_no_es_al_de_b
newLine 
et_17:
MOV AX, 4C00h
INT 21h
END START
