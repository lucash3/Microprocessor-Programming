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
main:		mov			#vetor,R5
			call		#M2M4
			jmp			$

M2M4:		push		R9					;salva contexto
			mov.b		@R5+,R8				;tamanho do vetor
			mov.b		#0,R6				;zera contador
			mov.b		#0,R7				;zera contador
			jmp			M2M4_loop

M2M4_loop:	mov.b		@R5+,R9				;pega elemento do vetor e passa prox
			call		#divb2				;checa divisibilidade por 2
            call		#divb4				;checa divisibilidade por 4
            dec			R8
            jnz			M2M4_loop
            pop			R9					;restaura contexto
            ret

;-------------------------------------------------------------------------------

divb2:		push		R9					;salva contexto
			push		R10
			mov			R9,R10				;retem valor inicial

divb2_proc:	sub			#2,R9				;subtracao
			cmp			#0,R9				;R9 <= 0?
			jeq			divb2_div			;igual -> numero divisivel por 2
			cmp			R10,R9				;R9 > R10?
			jhs			divb2_ndiv			;maior -> overflow -> ndiv por 2
			jlo			divb2_proc			;menor -> continua processo

divb2_div:	inc			R6

divb2_ndiv:	pop			R10					;restaura contexto
			pop			R9
			ret

;-------------------------------------------------------------------------------

divb4:		push		R9					;salva contexto
			push		R10
			mov			R9,R10				;retem valor inicial

divb4_proc:	sub			#4,R9				;subtracao
			cmp			#0,R9				;R9 <= 0?
			jeq			divb4_div			;igual -> numero divisivel por 4
			cmp			R10,R9				;R9 > R10?
			jhs			divb4_ndiv			;maior -> overflow -> ndiv por 4
			jlo			divb4_proc			;menor -> continua processo

divb4_div:	inc			R7

divb4_ndiv:	pop			R10					;restaura contexto
			pop			R9
			ret

;-------------------------------------------------------------------------------

			.data
vetor:		.byte 10,1,2,3,4,5,6,7,8,9,10
                                            

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
            
