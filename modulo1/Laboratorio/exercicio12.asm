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
main:
			mov		#vetor, r5				; Inicializa R5 com o vetor
			mov.b	@r5+, r6				; R6 = tamanho do vetor
			mov		r5, r8					; R8 vetor auxiliar sempre apontando pro início
			sub		#1, r6
			mov.b	r6, r7					; R7 = R6 = tamanho - 1
			call				#ordena
			jmp		$
			nop
ordena:
			mov		r7, r6
			mov		r8, r5
			call				#loop
			dec 	r7
			jnz					ordena
			ret
loop:
			mov.b	@r5+, r10
			mov.b	@r5, r11				; R10 e R11 serão os números a serem comparados
			cmp		r10, r11
			jlo					maior
exit:
			mov.b	r10, -1(r5)
			mov.b	r11, 0(r5)
			dec		r6
			jnz					loop
			ret
maior:
			mov.b	r11, r12
			mov.b	r10, r11
			mov.b	r12, r10				; Troca as posições
			jmp					exit
			nop

			.data
vetor:		.byte 15, 3, 4, 1, 8, 3, 6, 7, 1, 5, 9, 1, 6, 7, 3, 5
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