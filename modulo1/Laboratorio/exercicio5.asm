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
;BAAZZ
;Sub-Rotina  SUM16 armazena a soma (elemento a elemento) de dois vetores de mesmo tamanho
; Como verificar que os vetores sao do mesmo tamanho?
;Recursos:
; R5 = 0x2400 --> Endereco do VETOR1
; R6 = 0x2410 --> Endereco do VETOR2
; R7 = 0x2420 --> Endereco do VETOR_SOMA


main:		mov 	#Vetor1, r13			; R3 recebe o vetor1
			mov 	#Vetor2, r4				; R4 recebe o vetor2
			mov.w	@r13+, r8				; R8 recebe o tamanho do vetor
			mov.w	r4, r5					; R5 recebe o tamanho do vetor
			incd	r4
			add.w	r8, r5					; R5 recebe o endereço do último elemento
			add.w	r8, r5					; R5 recebe o endereço do último elemento
			call 				#SUM16		; Chama a função de comparação
			jmp 	$
			nop

SUM16:
			mov		@r4+, r6				; Pega o valor que irá ser somado
			mov 	@r13+, r7				; Pega o valor que irá ser somado
			add 	r6, r7					; Guarda em R7 o valor da soma
			incd 	r5						; Incrementa ponteiro do vetor3
			mov		r7,0(r5) 				; Escrever R7 no vetor3

exit:
			dec		r8
			jnz					SUM16
			ret



 			.data							; Declarar os vetores com 7 elementos
Vetor1:		.word 7, 1, 1, 1, 1, 1, 1, 1
Vetor2:		.word 7, 1, 2, 3, 4, 5, 6, 7

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
            
