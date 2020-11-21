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
			mov 	#NUM_ROM, r6
			clr 	r5
			call					#rom_arab
			jmp		$
			nop
rom_arab:
			mov.b	@r6+, r7
			mov.b	@r6, r8
loop1:
			cmp		#0x4D, r7
			jeq						caso_mil
			cmp		#0x43, r7
			jeq						caso_cem
			cmp		#0x4C, r7
			jeq						caso_cinquenta
			cmp		#0x58, r7
			jeq						caso_dez
			cmp		#0x56, r7
			jeq						caso_cinco
			cmp		#0x49, r7
			jeq						caso_um
			cmp		#0x00, r7
			jeq						caso_saida

loop2:
			cmp		#0x4D, r8
			jeq						caso_mil2
			cmp		#0x43, r8
			jeq						caso_cem2
			cmp		#0x4C, r8
			jeq						caso_cinquenta2
			cmp		#0x58, r8
			jeq						caso_dez2
			cmp		#0x56, r8
			jeq						caso_cinco2
			cmp		#0x49, r8
			jeq						caso_um2
			cmp		#0x00, r8
			jeq						caso_saida2

caso_mil:
			mov.w	#1000, r10
			jmp						loop2
caso_mil2:
			mov.w	#1000, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_cem:
			mov.w	#100, r10
			jmp						loop2
caso_cem2:
			mov.w	#100, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_cinquenta:
			mov.w	#50, r10
			jmp						loop2
caso_cinquenta2:
			mov.w	#50, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_dez:
			mov.w	#10, r10
			jmp						loop2
caso_dez2:
			mov.w	#10, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_cinco:
			mov.w	#5, r10
			jmp						loop2
caso_cinco2:
			mov.w	#5, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_um:
			mov.w	#1, r10
			jmp						loop2
caso_um2:
			mov.w	#1, r11
			cmp		r10, r11
			jeq						exit_soma
			jhs						exit_sub
			jlo						exit_soma

caso_saida2:
			add.w	r10, r5
			ret

exit_soma:
			add.w	r10, r5
			jmp						rom_arab
exit_sub:
			sub.w	r10, r5
			jmp						rom_arab
caso_saida:
			ret


            .data							; Especificar o número romano, terminando com ZERO.
NUM_ROM:	.byte "MMXLIV", 0				; 2019
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