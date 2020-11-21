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
main:
			mov		#Vetor1, R5
			mov		#Vetor2, R6
			call	#SUM_TOT
			jmp		$
			nop

SUM_TOT:
			mov		@R5+, R9				; R9 contador do tamanho
			incd	R6						; Alinha o ponteiro de R6 para o começo do vetor
			clr		R7
			clr		R8
SUM_TOT_loop:
			add		@R5+, R7				; Soma o primeiro vetor
			addc	#0,	R8					; Se tiver carry coloca no registro mais significativo
			add		@R6+, R7				; Soma o primeiro vetor
			addc	#0,	R8					; Se tiver carry coloca no registro mais significativo
			dec		R9						; Decrementa o contador
			cmp		#0, R9
			jne		SUM_TOT_loop
			ret

			.data

Vetor1:		.word		7, 65000, 50054, 26472, 53000, 60606, 814, 41121
Vetor2:		.word		7, 226, 3400, 26472, 470, 1020, 44444, 12345
                                            

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
            
