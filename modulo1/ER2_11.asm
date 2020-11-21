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

			mov.w		#VETOR, R5			;passar de forma indireta o vetor na memoria de dados para R5-->ponteiro
			mov.w		@R5+, R6			;primeiro elemento(tamanho do vetor) em R6-->contador
            call		#SUM16
			jmp			$

SUM16:		clr			R10

LOOP:		add.w		@R5+, R10
			dec.w		R6					; ??? esse decremento vai funcionar ??
			jnz			LOOP
			ret


			.data
VETOR:		.word		0x05, 0x04, 0x07, 0x03, 0x09, 0x02 	;[4 7 3 9 2]

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
            
