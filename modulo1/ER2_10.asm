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

			mov.w		#VETOR1, R5			;copia de forma imediata para R5 - atua como ponteiro/o proprio VETOR1 ja informa seu tamanho
			call		#SUM8				;chama subrotina
			jmp			$

SUM8:		clr.w		R10					;zera somatorio
			mov.b		@R5+, R6			;copiando em bytes de foma indireta via registrador em R6
											;essa instrucao incrementa o ponteiro e informa a R6 o tamanho do vetor
											;na ordem copia e incrementa
											;MANOBRA: transformei R6 em um contador a partir do tamanho do vetor

LOOP:		add.b		@R5+, R10			;copia o conteudo da 2º posicao para R10
			dec.b		R6					;decrementa R6 - procedural
			jnz			LOOP
			ret

			.data
VETOR1:		.byte		0x05, 0x04, 0x07, 0x03, 0x09, 0x02 		;[4 7 3 9 2]
																;[1 2 3 4 5 6 7]
																;[1 2 3 4 5 5 -4 -3 -2 -1]
                                            

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
            
