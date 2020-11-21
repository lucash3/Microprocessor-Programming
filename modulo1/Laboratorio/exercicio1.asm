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
; Recursos:
;R5: ponteiro. ideia: usar como indexador para os caracteres
;R6: menor elemento do vetor
;R7: contador de frequencia do menor elemento
;R8: contador baseado no tamanho do vetor. decrementa a cada comparacao

init:
			mov			#vetor,R5
			call		#menor
			jmp			$

menor:		mov			#1,R7		;seta reg. com freq. para valor inicial
			mov.b		@R5+,R8		;armazena tamanho do vetor para contagem
			mov.b		@R5+,R6		;inclui primeiro valor como val min
			dec			R8			;dec. tam. pois elem. foi incluido

loop:
			cmp.b		R6,0(R5)	;comparacao numerica
			jeq			iguais
			jhs			continua	;v(i) > R6

eleMenor:
			mov.b		@R5,R6		;novo valor encontrado
			mov			#1,R7		;reseta contagem de freq.
			jmp			continua

iguais:
			inc			R7			;incrementa contador de frequencias

continua:
			inc			R5			;proximo elemento do vetor
			dec			R8			;decrementa contador
			jnz			loop
			ret


                                            
				.data
vetor:			.byte		13,'A','N','A','M','A'
				.byte		'R','I','A','B','R','A','G','A'
															;MENOR = R6 = 41h
															;FREQUENCIA = R7 = 6
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
            
