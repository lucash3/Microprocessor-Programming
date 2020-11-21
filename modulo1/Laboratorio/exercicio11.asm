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
			mov 	#MEMO, r5				; Vetor a ser analisado
			mov.w	#4, r7					; Contador
			mov.w	#0, r6
			call				#asc_nib
			jc					Ok
			jnc					NOk
Ok:
			jc					Ok			; Trava execução em sucesso
NOk:
			jnc					NOk			; Trava execução em falha
asc_nib:
			mov.b	@r5, r11				; Move o conteúdo de R5 para R11
			inc		r5
			sub		#0x30, r11
			cmp		#10, r11
			jhs					letra		; Caso seja maior que 10, é letra
asc_nib2:
			rla		r6						; faz o shift em r8
			rla		r6						; faz o shift em r8
			rla		r6						; faz o shift em r8
			rla		r6						; faz o shift em r8
			add.w	r11, r6					; Bota o resultado em R
			dec 	r7
			jnz 				asc_nib
			setc
			ret
letra:
			sub		#0x07, r11
			cmp		#0x0F, r11
			jhs					error
			jmp					asc_nib2
			nop
error:
			clrc
			ret

			.data
MEMO:		.byte "8","9","A","B"			; Declarar 4 caracteres ASCII (0x38, 0x39, 0x41, 0x42)
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