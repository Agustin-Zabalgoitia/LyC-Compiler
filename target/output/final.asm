.MODEL LARGE
.386
.STACK 200h

.DATA
a	dd	?
b	dd	?
c	dd	?
d	dd	?
e	dd	?
_2	dd	2.0
_3	dd	3.0
_7	dd	7.0




.CODE

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

fld _2 
fld _3 
fmul
ffree 0
fld b 
fadd
ffree 0
fld _7 
fadd
ffree 0
fld _3 
fld _2 
fmul
ffree 0
fdiv
ffree 0
fstp a 
