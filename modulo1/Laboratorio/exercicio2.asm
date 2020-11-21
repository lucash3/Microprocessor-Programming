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
init:
			mov			#VETOR2,R5
			call		#maior16
			jmp			$

maior16:	mov			#1,R7		;seta reg. com freq. para valor inicial
			mov.w		@R5+,R8		;armazena tamanho do vetor para contagem
			mov.w		@R5+,R6		;inclui primeiro valor como val max
			dec			R8			;dec. tam. pois elem. foi incluido

loop:
			cmp.w		R6,0(R5)	;comparacao numerica
			jeq			iguais
			jlo			continua	;v(i) < R6

eleMaior:
			mov.w		@R5,R6		;novo valor encontrado
			mov			#1,R7		;reseta contagem de freq.
			jmp			continua

iguais:
			inc			R7			;incrementa contagem de freq.

continua:
			add			#2,R5		;proximo elemento do vetor
			dec			R8			;decrementa contador
			jnz			loop
			ret


			.data
;vetor:		.byte 6,0,"PEDROVICTOR",0

VETOR2:		.byte	7,0,"LUCASHENRIQUE",0

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
            
