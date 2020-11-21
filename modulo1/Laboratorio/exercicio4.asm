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
main:		mov		#vetor,R5				;inicializar R5 com o endereço do vetor
			call	#Extremos				;chama a subrotina
			jmp		$
			nop


Extremos:	push 	R10						;guardando contexto
			mov		#32767,R6				;setando R6 para o maior valor pois ele ira guardar o menor valor
			mov		#-32768,R7				;setando R7 para o menor valor pois ele ira guardar o maior valor
			mov		@R5+,R10				;guardando em R10 o tamanho do vetor

Extremos_Loop:
			cmp		R6,0(R5)				;Comparando @R5 com R6
			jl		Menor					;Pula para o menor se @R5 < R6
continue:	cmp		R7,0(R5)				;Comparando @R5 com R7
			jge		Maior					;Pula para maior se @R5 >= R7
			jmp 	Decisao					;vai para a decisao

Menor:		mov		@R5,R6					;coloando o novo menor valor em R6
			jmp		continue				;voltando para onde parou no loop

Maior:		jeq		Decisao					;Se for igual vai para a decisao
			mov		@R5,R7					;guardando o novo maior valor
			jmp 	Decisao					;indo para a decisao

Decisao:	dec		R10						;Decrementando o contador
			jz		Extremos_Fim			;indo para o final se o contador foi a zero
			incd	R5						;Avançando a poscisao no vetor R5
			jmp		Extremos_Loop			;voltando ao loop

Extremos_Fim:
			pop		R10;
			ret


			.data
vetor:		.word	8, 170, 99, 776, -1998, 170, 146, 367, -2000 		;declaraçao do vetor e seu conteudo
                                            

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
            
