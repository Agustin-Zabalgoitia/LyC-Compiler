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
_5	dd	5.0
_"Chau"	db	"Chau"	$6	dup(?)




.CODE

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _5 
fstp a 

fld d 
fstp c 

lea si, msj_1
lea si, e
mov cx, 6
rep movsb
mov al, 0
stosb

