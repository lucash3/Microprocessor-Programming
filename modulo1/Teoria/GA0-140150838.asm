;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
;
;
A0: 		mov 	#COVID_MAR, R5
			mov.b	#31, R13			;R13: contador que decresce no numero de dias do mes de Marco
			call 	#MAR_MM7
			jmp 	$
			NOP




MAR_MM7:   	mov.w	#0x005, R12			;legacy dos casos do mes de fevereiro (simplificacao)
			add.w	@R5, R12			;R12 contem a soma de uma janela de 7 dias
			call	#DIV7

CONTINUA:	dec.b	R13					;R13 zerar sinaliza o final do mes de Marco
			add		1(R5), R12
			incd	R5
			call	#DIV7



;---------------SUBROTINA-DIVISAO-(via subtracoes sucessivas)-------------------
;Recursos:
;R4: dividendo
;R7: divisor
;R11: quociente
;R10: resto
;R6: auxiliar
;R4 / R7 = R11

DIV7:				mov.w		R12, R4				;dividendo
					mov.w		#0x007, R7			;divisor = 7 (janela de 7 dias)
					mov.w		#00, R6				;aux
					mov.w		#00, R11			;resultado da divisao
					clrc

SUB_SUCESSIVA:		mov.w		R4, R10				;R10 resto da divisao
					sub.w		R7, R4
					jnc			LB1
					inc.w		R11					; R11 retorna o resultado da divisao

LOOP:				cmp.w		R6, R4
					jnz			SUB_SUCESSIVA

LB1:				jmp			CONTINUA			;ao final de 1 iteracao o resultado do
													;calculo da media movel para os primeiro 7 dias
													;estara em R11
													;volta e faz mais uma iteracao


;-----------------------------------------------------------------------------------






             		.data
; Casos nos últimos 6 dias de fevereiro
COVID_FEV:   		.word     0,    0,    1,    1,    1,    2
;
; Casos durante os 31 dias se março
COVID_MAR:   		.word     2,    2,    2,    3,    7,   13,   19,   25,  25,    34
             		.word    52,   77,   98,  121,  200,  234,  291,  428,  621,  904
             		.word  1128, 1546, 1891, 2201, 2433, 2915, 3417, 3903, 4256, 4579, 5717
;
; Média móvel de março (sua resposta)
COVID_MM7:  		 .word    1,     0,    0,    0,    0,    0,    0,    0,    0,    0
            		 .word    0,     0,    0,    0,    0,    0,    0,    0,    0,    0
            		 .word    0,     0,    0,    0,    0,    0,    0,    0,    0,    0,    0









;---------------------------------------------------

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
