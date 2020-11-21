/* Laboratorio de Sistemas Microprocessados - TURMA F
 * Prof. Dr. Eduardo Peixoto
 *
 * Problema 2: Uso do sensor HCSR-04 para implementacao de uma trena digital
 * Lucas Henrique Santos Sozua 140150838
 *
 * ECHO:    P1.2 --> MODO ENTRADA ---> Divisor Resistivo (10k)/(10k+4k7)
 * TRIGGER: P6.1 --> MODO SAIDA
 *
 * ISR TIMERA0
 * ISR PORTA P2
 * */


#include <intrinsics.h>
#include <stdint.h>
#include <msp430.h>



//Definicao de constantes
volatile int dist = 0;          //inicializacao da variavel global para utilizar o recurso de Refresh all Windows
#define TRIGGER BIT1            //PINO P6.1 COMO TRIGGER
#define ECHO BIT3               //PINO P1.3 COMO ECHO
#define LED_PIN BIT0            // P1.0
#define DISTANCE_THRESHOLD 60   // cm
#define INTERVALO_MEDICAO 2048  // ~250 ms

//Prototipo das funcoes basicas
void io_config(void);
void aciona_trigger();
void ta0_config(void);



int main(void) {

    io_config();
    ta0_config();

    WDTCTL = WDTPW | WDTHOLD;

    // Configuracao do Pino TRIGGER P6.1
    P6DIR |= TRIGGER;
    P6OUT &= ~TRIGGER;


    // Configuracao do pino ECHO P1.3 como entrada de captura em TA0CCR2
    P1DIR &= ~ECHO;
    P1SEL |= ECHO;


    uint16_t captura = 0;
    uint32_t dist = 0;

    for (;;)                        //LACO INFINITO OPERACIONAL
    {
        aciona_trigger();           //ACIONA UM PULSO POSITIVO NA ENTRADA trigger
        __low_power_mode_3();       //AGUARDA RESPOSTA PROPORCIONAL AO TEMPO DE PROPAGACAO NO ECHO

        captura = TA0CCR2;          //UNIDADE DE CAPTURA E COMPARA RECEBE A MEDICAO MAIS RECENTE
        __low_power_mode_3();       //AGUARDA O FIM DO PULSO ECHO

        dist = TA0CCR2 - captura;
        dist = dist*34000;          // ~Velocidade do som 34000cm/s
        dist >>= 14;                // CLOCK A 8192Hz
                                    //mas a onda sonora atinge o objeto e então retorna, o que implica dividir por 16384, ie (2^14)

//------------------------------------------------------------------------------//
// ESTRUTURA CONDICIONAL PARA APRESENTACAO DO RESULTADO VIA LED                 //
//                                                                              //
// ABAIXO DE 20cm------> LED1 APAGADO       LED2 APAGADO                        //
// DE 20cm ATE 40cm----> LED1 APAGADO       LED2 ACESO                          //
// DE 40cm ATE 60cm----> LED1 ACESO         LED2 APAGADO                        //
// ACIMA DE 60cm-------> LED1 ACESO         LED2 ACESO                          //
//------------------------------------------------------------------------------//

        if (dist < 20)
        {

            P1OUT &= ~LED_PIN;
            P4OUT &= ~BIT7;
        }
        else if(dist >= 20 && dist < 40)
        {
            P1OUT &= ~LED_PIN;
            P4OUT |= BIT7;
        }
        else if(dist >= 40 && dist <= 60)
        {
            P1OUT |= LED_PIN;
            P4OUT &= ~BIT7;
        }
        else if( dist > 60)
        {
            P1OUT |= LED_PIN;
            P4OUT |= BIT7;
        }


        // Espera pela proximo ciclo de medicao
        __low_power_mode_3();
    }
}

//-------------------------------------------------------//
//  REFERENCIAMENTO A TABELA DE VETORES DE INTERRUPCAO  //
//  PARA CONFIGURACAO DA isr - TIMER A0 - VETOR 53  //
//------------------------------------------------------//
#pragma vector = TIMER0_A0_VECTOR
__interrupt void isr_ta0_0(void) {              //ciclo de medicao
    __low_power_mode_off_on_exit();
    TA0CCR0 = TA0CCR0 + INTERVALO_MEDICAO;
}


//-------------------------------------------------------//
//  REFERENCIAMENTO A TABELA DE VETORES DE INTERRUPCAO  //
//  PARA CONFIGURACAO DA isr - TIMER A0 - VETOR 52  //
//------------------------------------------------------//
#pragma vector = TIMER0_A1_VECTOR
__interrupt void isr_ta0_1(void) {         //alternancia de estado do pino de ECHO
    __low_power_mode_off_on_exit();
    TA0IV = 0;                            //CONSULTA E APAGA PENDENCIAS
}



//-----------------------------------------------------------------//
//  CONFIGURACAO TIMERA0 - ATUAR COMO UNIDADE DE CAPTURA EM CCR2   //
//  EM AMBOS OS FLANCOS DE P1.3 (PINO ECHO)                        //
//-----------------------------------------------------------------//
void ta0_config(void){

TA0CCTL2 = CM_3 | CCIS_0 | SCS | CAP | CCIE;


TA0CCR0 = INTERVALO_MEDICAO;                                //TA0 COMPARA O INTERVALO DE MEDICAO EM CCR0
TA0CCTL0 = CCIE;                                            //HABILITA INTERRUPCAO LOCAL
TA0CTL = TASSEL__ACLK | ID__4 | MC__CONTINUOUS | TACLR;     //SELECIONA ACLK/4 COM DIVISOR 1/4 NO MODO CONTINUO
}                                                           // TA0 --> ACLK/ 4 = 8192 Hz


//-------------------------------------------------------//
 //  ROTINA DE CONFIGURACAO DO ACIONAMENTO DO trigger    //
 //------------------------------------------------------//
void aciona_trigger() {

    P6OUT |= TRIGGER;       //ACIONA PINO P6.1 MODO SAIDA
    __delay_cycles(10);     // CONSOME TEMPO COM trigger EM LOGICO ALTO > 10us (~10 CICLOS DE MCLK A 1MHz)
    P6OUT &= ~TRIGGER;      // FIM DO PULSO
}


//-------------------------------------------------------//
//         ROTINA DE CONFIGURACAO GPIO                   //
//-------------------------------------------------------//
void io_config(void){

P2DIR &= ~BIT1;     // CHAVE S1 (P2.1) --> MODO ENTRADA
P2REN |=  BIT1;     // HABILITA RESISTOR
P2OUT |=  BIT1;     // PULL UP
P2IES |= BIT1;      //Flanco de descida
P2IFG = 0;          //Apagar possíveis pedidos
P2IE |= BIT1;       //Habilitar interrupção

P1DIR |=  BIT0;     // LED1 VERMELHO (P1.0) --> MODO SAIDA
P1OUT &= ~BIT0;     // LED1 INICIALMENTE APAGADO

P4DIR |=  BIT7;     // LED2 VERDE (P4.7) --> MODO SAIDA
P4OUT &= ~BIT7;     // LED2 INICIALMENTE APAGADO

P6DIR |=  BIT1;     // PINO P6.1 SETADO COMO SAIDA PARA O TRIGGER
P6OUT &= ~BIT1;     // INICIALMENTE DESLIGADO ATE INVOCAVAO DA ROTINA trigger()

P1DIR &= ~BIT2;     // PINO P1.2 SETADO COMO ENTRADA PARA O ECCHO
P1REN |=  BIT2;     //
P1SEL |=  BIT2;     //
P1OUT &= ~BIT2;     //

}
