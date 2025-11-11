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
_10	dd	10.0
_papu_bel_tkm	db	"papu bel tkm$"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _10 
fstp a 

fld a
fld _10
fxch
fcom
fstsw ax
sahf
jne et_12
displayString _papu_bel_tkm
jmp et_14
et_12:
displayString e
et_14:
MOV AX, 4C00h
INT 21h
END START
