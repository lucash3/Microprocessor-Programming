;-------------------------------------------------------------------------------
; Lucas Henrique Santos Souza	140150838
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
; Main loop here - Turma F - Lucas Henrique Santos Souza	140150838
;-------------------------------------------------------------------------------
; Sub-rotina que recebe um algarismo arabico ocidental entre 1 e 3999 e
; retorna, na memória de dados, uma sequencia de letras (mapeadas segundo a tabela ASCII)
; que representam a conversao correspondente para o sistema de algarismo romano
;
; USO DOS RECURSOS
; R5: recebe o numero a ser convertido (NUM)
; R6: ponteiro para escrever a resposta na memoria a partir do endereco apontado
; insrucoes de comparacao (JHS) para fazer loop
;
; IDEIA:
; Construir uma estrutura de selecao organizada em casos comparativos [case das linguagens de alto nivel compiladas]
; Pensando num processo de subtracoes sucessivas onde se diminui uma quantidade prefixada
; do numero a ser convertido tem:
; M = NUM-1000 | CM = NUM-900 | D = NUM-500 | CD = NUM-400 | C = NUM-100
; XC = NUM-90  | L = NUM-50   | XL = NUM-40 | X = NUM-10   | IX = NUM-9
; V = NUM-5    | IV= NUM-4    | I = NUM-1
;
; Percebe-se que existem iteracoes de uma unica etapa, isto e, subtrair e alocar o caractere
; existem iteracoes de duas etapas (2 simbolos), que envolve subtrair,alocar,incrementar,alocar
; onde duas etapas abarca a ideia de consumir duas posicoes na mesma iteracao
; O ponto de retorno e quando nao ha mais o que subtrair de NUM, onde move-se 0 p/ a pos. apontada por R6


NUM:			.equ		2019				;Indicar número a ser convertido
;
				mov 		#NUM, R5 			;R5 = número a ser convertido
				mov 		#RESP, R6			;R6 = ponteiro para escrever a resposta
				call 		#ALG_ROM 			;chamar sub-rotina
				jmp 		$ 					;travar execução
				nop 							;exigido pelo montador
;

ALG_ROM:		cmp.w		#1000, R5			; sentido da comparacao NUM-1000 ----> 'M'
				jhs			CASE_1000			; se for maior, subtrai 1000 e aloca o simbolo 'M'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#900, R5			; sentido da comparacao NUM-900 -----> 'CM'
				jhs			CASE_900			; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#500, R5			; sentido da comparacao NUM-500 ----> 'D'
				jhs			CASE_500			; se for maior, subtrai 500 e aloca o simbolo 'D'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#400, R5			; sentido da comparacao NUM-400 -----> 'CD'
				jhs			CASE_400			; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#100, R5			; sentido da comparacao NUM-100	----> 'C'
				jhs			CASE_100			; se for maior, subtrai 100 e aloca o simbolo 'C'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#90, R5				; sentido da comparacao NUM-90 -----> 'XC'
				jhs			CASE_90				; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#50, R5				; sentido da comparacao NUM-50 ----> 'L'
				jhs			CASE_50				; se for maior, subtrai 50 e aloca o simbolo 'L'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#40, R5				; sentido da comparacao NUM-40 -----> 'XL'
				jhs			CASE_40				; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#10, R5				; sentido da comparacao NUM-10 ----> 'X'
				jhs			CASE_10				; se for maior, subtrai 10 e aloca o simbolo 'X'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#9, R5				; sentido da comparacao NUM-9 -----> 'IX'
				jhs			CASE_9				; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#5, R5				; sentido da comparacao NUM-5 ----> 'V'
				jhs			CASE_5				; se for maior, subtrai 5 e aloca o simbolo 'V'
												; na posicao atual apontada pelo ponteiro de resposta

				cmp.w		#4, R5				; sentido da comparacao NUM-4 -----> 'IV'
				jhs			CASE_4				; notar que e uma alocacao simbolica em duas etapas que consome
												; duas posicoes apontadas por R6

				cmp.w		#1, R5				; sentido da comparacao NUM-1 ----> 'I'
				jhs			CASE_1				; se for maior, subtrai 1 e aloca o simbolo 'I'
												; na posicao atual apontada pelo ponteiro de resposta

; Aqui e necessario um mecanismo de controle de fluxo
; ja que o ultimo salto nao vai acontecer e
; preciso de um ponto de parada/retorno p travar a execucao

				mov.b		#00h, 0(R6)
				ret

;-----------------------------------------------
CASE_1000:		sub.w		#1000, R5			; efetua NUM-1000
				mov.b		#'M', 0(R6)			; copia o simbolo 'M' mapeado como 4Dh na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_900:		sub.w		#900, R5			; efetua NUM-900
				mov.b		#'C', 0(R6)			; copia o simbolo 'C' mapeado como 43h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'M', 0(R6)			; copia o simbolo 'M' mapeado como 4Dh na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_500:		sub.w		#500, R5			; efetua NUM-500
				mov.b		#'D', 0(R6)			; copia o simbolo 'D' mapeado como 44h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_400:		sub.w		#400, R5			; efetua NUM-400
				mov.b		#'C', 0(R6)			; copia o simbolo 'C' mapeado como 43h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'D', 0(R6)			; copia o simbolo 'D' mapeado como 44h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_100:		sub.w		#100, R5			; efetua NUM-100
				mov.b		#'C', 0(R6)			; copia o simbolo 'C' mapeado como 43h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_90:		sub.w		#90, R5				; efetua NUM-90
				mov.b		#'X', 0(R6)			; copia o simbolo 'X' mapeado como 58h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'C', 0(R6)			; copia o simbolo 'C' mapeado como 43h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_50:		sub.w		#50, R5				; efetua NUM-50
				mov.b		#'L', 0(R6)			; copia o simbolo 'L' mapeado como 4Ch na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_40:		sub.w		#40, R5				; efetua NUM-40
				mov.b		#'X', 0(R6)			; copia o simbolo 'X' mapeado como 58h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'L', 0(R6)			; copia o simbolo 'M' mapeado como 4Ch na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_10:		sub.w		#10, R5				; efetua NUM-10
				mov.b		#'X', 0(R6)			; copia o simbolo 'X' mapeado como 58h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_9:			sub.w		#9, R5				; efetua NUM-9
				mov.b		#'I', 0(R6)			; copia o simbolo 'I' mapeado como 49h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'X', 0(R6)			; copia o simbolo 'X' mapeado como 58h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_5:			sub.w		#5, R5				; efetua NUM-5
				mov.b		#'V', 0(R6)			; copia o simbolo 'V' mapeado como 56h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_4:			sub.w		#4, R5				; efetua NUM-4
				mov.b		#'I', 0(R6)			; copia o simbolo 'I' mapeado como 49h na Tabela ASCII no apontamento atual
				inc.w		R6					; avanca o ponteiro para a proxima posicao
				mov.b		#'V', 0(R6)			; copia o simbolo 'M' mapeado como 56h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina

;-----------------------------------------------
CASE_1:			sub.w		#1, R5				; efetua NUM-1
				mov.b		#'I', 0(R6)			; copia o simbolo 'I' mapeado como 49h na Tabela ASCII no apontamento atual
				inc.w		R6					; ja deixa o ponteiro apontando para a proxima posicao
				jmp			ALG_ROM				; retorna incondicionalmente para a subrotina
				nop								; exigido pelo montador
;-----------------------------------------------

				.data

; Local para armazenar a resposta (RESP = 0x2400)
RESP: 			.byte 		"RRRRRRRRRRRRRRRRRR",0

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
            
