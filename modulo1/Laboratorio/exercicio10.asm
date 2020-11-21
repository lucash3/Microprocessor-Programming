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

MATR 		.set 	35243

main:
			mov		#MATR, r5				; R5 = número a ser analisado
			mov.w	#0x2400, r13			; Inicializa o vetor R13 - resposta
			mov		#0xF000, r10			; Número de controle AND
			call 				#loop
			jmp		$
			nop
loop:
			mov		r10, r11
			and		r5, r11					; R11 será o nibble a ser avaliado
			mov		#12, r6
			call				#shift_four
			call				#contador
			call				#nib_asc

			mov		r10, r11
			and		r5, r11					; R11 será o nibble a ser avaliado
			mov		#8, r6
			call				#shift_four
			call				#contador
			call				#nib_asc

			mov		r10, r11
			and		r5, r11					; R11 será o nibble a ser avaliado
			mov		#4, r6
			call				#shift_four
			call				#contador
			call				#nib_asc

			mov		r10, r11
			and		r5, r11					; R11 será o nibble a ser avaliado
			call				#nib_asc
			ret
nib_asc:
			add		#0x30, r11				; Somar 0x30
			cmp		#0x03A, r11
			jlo					exit		; Se for um número, vai direto pro exit
			add		#0x07, r11				; Se não for um número, adiciona mais 0x07
exit:
			mov.w	r11, 0(r13)
			incd	r13
			ret
shift_four:
			clrc
			rrc		r11 					; Atualiza R11
			dec 	r6
			jnz					shift_four
			ret
contador:
			clrc
			rrc		r10						; Atualiza R10
			rrc		r10
			rrc		r10
			rrc		r10						; 0x00F0 -> 0x000F
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