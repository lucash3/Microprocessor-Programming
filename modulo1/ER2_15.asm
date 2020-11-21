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
; subrotina FIBn gera os n primeiros numeros da seq. de Fibonacci
; armazenando-os na RAM a partir da posicao indicado por R5
;
;			FIBONACCI	a[n] = a[n-1] + a[n-2]
;				com a[1] = 0 e a[2] = 1   --> 0, 1, 1, 2, 3, 5, 8, 13, 21, 34
;Recursos
;R6: quantidade de elementos da sequencia - contagem de operacoes de soma
;R5: endereco para armazenar a sequencia - ponteiro indicando onde se deve armazenar os elementos


; Ambiente para testar a subrotina FIBn


				mov.w		#0x2410, R5			;ponteiro = endereco do vetor
				mov			#10, R6				;testar com 10 elementos
				call		#FIBn
				jmp			$

FIBn:			mov.b		#0, 0(R5)
				inc.w		R5
				mov.b		#1, 0(R5)
				inc.w		R5
				sub.b		#2, R6

LOOP:			mov.b		-2(R5), 0(R5)		;copiar antepenultimo
				add.b		-1(R5), 0(R5)		;somar com o ultimo
				inc.w		R5					;avancar ponteiro
				dec.b		R6					;decrementar contador
				jnz			LOOP
				ret
                                            

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
            
