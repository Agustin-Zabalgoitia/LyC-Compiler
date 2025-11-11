include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
a1	dd	?
a2	dd	?
a3	dd	?
a4	dd	?
a5	dd	?
z	dd	?
c1	dd	?
c2	dd	?
c3	dd	?
c4	dd	?
x	dd	?
continuar	dd	?
b1	dd	?
y	dd	?
_	db	"$"	,0
_Los_mensajes_son_a_modo_de_DE	db	"Los mensajes son a modo de DEBUG$"	,0
_Asignacion_de_Variables_	db	"--- Asignacion de Variables ---$"	,0
_99999_99	dd	99999.99
_Variable_a1_Float_asignada_co	db	"Variable 'a1' -> Float asignada con 99999.99$"	,0
_3_5	dd	3.5
_4_2	dd	4.2
_Variable_a2_Float_asignada_co	db	"Variable 'a2' -> Float asignada con expresion$"	,0
_La_expresion_es_3_5_4_2	db	"La expresion es: 3.5 + 4.2$"	,0
_1_9999	dd	1.9999
_Variable_a3_Float_asignada_co	db	"Variable 'a3' -> Float asignada con 1.9999$"	,0
_Enter_para_continuar_	db	"Enter para continuar.$"	,0
_Asignacion_a_Variables_Entera	db	"--- Asignacion a Variables Enteras ---$"	,0
_300	dd	300.0
_La_variable_c1_Int_asignada_c	db	"La variable 'c1' -> Int asignada con 300$"	,0
_72	dd	72.0
_La_variable_c2_Int_asignada_c	db	"La variable 'c2' -> Int asignada con 72$"	,0
_Operaciones_Aritmeticas_	db	"--- Operaciones Aritmeticas ---$"	,0
_33	dd	33.0
_La_variable_x_tiene_el_result	db	"La variable 'x' tiene el resultado de la expresion$"	,0
_El_resultado_es_	db	"El resultado es: $"	,0
_1	dd	1.0
_2	dd	2.0
_3	dd	3.0
_6	dd	6.0
_7	dd	7.0
_Condicionales_	db	"--- Condicionales ---$"	,0
_Las_variables_a_usar_son_c1_c	db	"Las variables a usar son c1, c2, c3 y c4$"	,0
_If_Else_	db	"--- If/Else ---$"	,0
_Comparamos_c1_c2	db	"Comparamos c1 > c2$"	,0
_Ingrese_el_valor_de_c1_	db	"Ingrese el valor de c1: $"	,0
_Ingrese_el_valor_de_c2_	db	"Ingrese el valor de c2: $"	,0
_El_valor_de_c1_es_mayor_al_de	db	"El valor de c1 es mayor al de c2$"	,0
_El_valor_de_c1_es_menor_al_de	db	"El valor de c1 es menor al de c2$"	,0
_If_con_AND_	db	"--- If con AND ---$"	,0
_Vamos_a_comparar_si_c1_c2_AND	db	"Vamos a comparar si c1 > c2 AND c3 < c4$"	,0
_Ingrese_el_valor_de_c3_	db	"Ingrese el valor de c3: $"	,0
_Ingrese_el_valor_de_c4_	db	"Ingrese el valor de c4: $"	,0
_c1_es_a_c2_y_c3_es_a_c4_Parte	db	"c1 es > a c2 y c3 es < a c4 -> Parte true$"	,0
_If_con_OR_	db	"--- If con OR ---$"	,0
_Vamos_a_comparar_si_c1_c2_OR_	db	"Vamos a comparar si c1 > c2 OR c3 < c4$"	,0
_Se_cumplio_c1_c2_o_c3_c4_Part	db	"Se cumplio c1 > c2 o c3 < c4 -> Parte true$"	,0
_Ciclo_while_	db	"--- Ciclo while ---$"	,0
_Ingrese_un_valor_para_c2_lim_	db	"Ingrese un valor para 'c2', lim. sup. bucle: $"	,0
_Estoy_adentro_del_while	db	"Estoy adentro del while$"	,0
_Prueba_funcion_isZero_	db	"--- Prueba funcion isZero() ---$"	,0
_Se_evaluara_c1_la_cual_contie	db	"Se evaluara 'c1' la cual contiene 2 - 2$"	,0
_0	dd	0.0
_La_expresion_es_0	db	"La expresion es 0$"	,0
_Se_evaluara_c2_la_cual_contie	db	"Se evaluara 'c2' la cual contiene 1 + 3$"	,0
_La_expresion_no_es_0	db	"La expresion no es 0$"	,0




.CODE

START: 

MOV AX, @DATA
MOV DS, AX
MOV ES, AX

displayString _
newLine 
displayString _Los_mensajes_son_a_modo_de_DE
newLine 
displayString _
newLine 
displayString _Asignacion_de_Variables_
newLine 
fld _99999_99 
fstp a1 

displayString _Variable_a1_Float_asignada_co
newLine 
DisplayFloat a1, 2
newLine 
fld _3_5 
fld _4_2 
fadd
ffree st(0)
fstp a2 
displayString _Variable_a2_Float_asignada_co
newLine 
displayString _La_expresion_es_3_5_4_2
newLine 
DisplayFloat a2, 2
newLine 
fld _1_9999 
fstp a3 

displayString _Variable_a3_Float_asignada_co
newLine 
DisplayFloat a3, 2
newLine 
displayString _Enter_para_continuar_
newLine 
GetFloat continuar
displayString _Asignacion_a_Variables_Entera
newLine 
fld _300 
fstp c1 

displayString _La_variable_c1_Int_asignada_c
newLine 
DisplayFloat c1, 2
newLine 
fld _72 
fstp c2 

displayString _La_variable_c2_Int_asignada_c
newLine 
DisplayFloat c2, 2
newLine 
displayString _Enter_para_continuar_
newLine 
GetFloat continuar
displayString _Operaciones_Aritmeticas_
newLine 
fld _33 
fld c2 
fadd
ffree st(0)
fld c1 
fadd
ffree st(0)
fstp x 
displayString _La_variable_x_tiene_el_result
newLine 
displayString _El_resultado_es_
newLine 
DisplayFloat x, 2
newLine 
fld _2 
fld _3 
fmul
ffree st(0)
fld _1 
fadd
ffree st(0)
fld c1 
fadd
ffree st(0)
fstp x 
displayString _La_variable_x_tiene_el_result
newLine 
displayString _El_resultado_es_
newLine 
DisplayFloat x, 2
newLine 
fld _6 
fld _3 
fdiv
ffree st(0)
fld _2 
fld _7 
fmul
ffree st(0)
fadd
ffree st(0)
fstp x 
displayString _La_variable_x_tiene_el_result
newLine 
displayString _El_resultado_es_
newLine 
DisplayFloat x, 2
newLine 
displayString _Enter_para_continuar_
newLine 
GetFloat continuar
displayString _Condicionales_
newLine 
displayString _Las_variables_a_usar_son_c1_c
newLine 
displayString _
newLine 
displayString _If_Else_
newLine 
displayString _
newLine 
displayString _Comparamos_c1_c2
newLine 
displayString _Ingrese_el_valor_de_c1_
newLine 
GetFloat c1
displayString _Ingrese_el_valor_de_c2_
newLine 
GetFloat c2
fld c1
fld c2
fxch
fcom
fstsw ax
sahf
jna et_135
displayString _El_valor_de_c1_es_mayor_al_de
newLine 
jmp et_137
et_135:
displayString _El_valor_de_c1_es_menor_al_de
newLine 
et_137:
displayString _
newLine 
displayString _If_con_AND_
newLine 
displayString _Vamos_a_comparar_si_c1_c2_AND
newLine 
displayString _Ingrese_el_valor_de_c1_
newLine 
GetFloat c1
displayString _Ingrese_el_valor_de_c2_
newLine 
GetFloat c2
displayString _Ingrese_el_valor_de_c3_
newLine 
GetFloat c3
displayString _Ingrese_el_valor_de_c4_
newLine 
GetFloat c4
fld c1
fld c2
fxch
fcom
fstsw ax
sahf
jna et_171
fld c3
fld c4
fxch
fcom
fstsw ax
sahf
jae et_171
displayString _c1_es_a_c2_y_c3_es_a_c4_Parte
newLine 
et_171:
displayString _
newLine 
displayString _If_con_OR_
newLine 
displayString _Vamos_a_comparar_si_c1_c2_OR_
newLine 
displayString _Ingrese_el_valor_de_c1_
newLine 
GetFloat c1
displayString _Ingrese_el_valor_de_c2_
newLine 
GetFloat c2
displayString _Ingrese_el_valor_de_c3_
newLine 
GetFloat c3
displayString _Ingrese_el_valor_de_c4_
newLine 
GetFloat c4
fld c1
fld c2
fxch
fcom
fstsw ax
sahf
ja et_203
fld c3
fld c4
fxch
fcom
fstsw ax
sahf
jae et_205
et_203:
displayString _Se_cumplio_c1_c2_o_c3_c4_Part
newLine 
et_205:
displayString _Enter_para_continuar_
newLine 
GetFloat continuar
displayString _
newLine 
displayString _Ciclo_while_
newLine 
fld _1 
fstp c1 

displayString _Ingrese_un_valor_para_c2_lim_
newLine 
GetFloat c2
INI:
fld c1
fld c2
fxch
fcom
fstsw ax
sahf
jae et_235
displayString _Estoy_adentro_del_while
newLine 
fld c1 
fld _1 
fadd
ffree st(0)
fstp c1 
jmp INI
et_235:
displayString _Enter_para_continuar_
newLine 
GetFloat continuar
displayString _
newLine 
displayString _Prueba_funcion_isZero_
newLine 
displayString _Se_evaluara_c1_la_cual_contie
newLine 
fld _2 
fld _2 
fsub
ffree st(0)
fstp c1 
fld c1
fld _0
fxch
fcom
fstsw ax
sahf
jne et_257
displayString _La_expresion_es_0
newLine 
et_257:
displayString _
newLine 
displayString _Se_evaluara_c2_la_cual_contie
newLine 
fld c2
fld _0
fxch
fcom
fstsw ax
sahf
jne et_270
displayString _La_expresion_es_0
newLine 
jmp et_272
et_270:
displayString _La_expresion_no_es_0
newLine 
et_272:
MOV AX, 4C00h
INT 21h
END START
