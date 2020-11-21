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

			mov.w		#VETOR, R5		;copia de forma imediata R5--> ponteiro
			mov.b		@R5+, R6		;1o elemento(tamanho) define o contador
			call		#MAIOR8
			jmp			$

MAIOR8:		clr.b 		R10				;zera R10. Deixa R10 com o menor valor possivel

LOOPC:		cmp.b		@R5, R10		;R10 - @R5 = 0 - 4
			jhs			LB
			mov.b		@R5, R10

LB:			inc.w		R5
			dec.b		R6
			jnz			LOOPC
			ret

			.data
VETOR:		.byte		0x05, 0x04, 0x07, 0x03, 0x09, 0x02 		;[4 7 3 9 2]

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
            
