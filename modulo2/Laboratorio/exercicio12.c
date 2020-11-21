#include <msp430.h>

void main(void){
    WDTCTL = WDTPW + WDTHOLD; //
    P1DIR |= BIT0;
    P1OUT &= ~BIT0;
    TA0CTL = TASSEL_1 | MC_1|TAIE;//Aclk, Modo de contagem up, habilitar interrupção
    TA0CCR0 = 654; // 50Hz
    TA0CCR1 = 327; // 50% duty cycle
    TA0CCTL1 |= CCIE;// Habilita interrupção do TA0.1
    __enable_interrupt();
    while(1);
}

#pragma vector= 52 // Interrupção do TA0.1
__interrupt void TA0_A1_ISR(){
    switch(TA0IV){
    case 0x2: P1OUT &= ~BIT0; // desliga o led vermelho
    break;
    case 0xE: P1OUT |= BIT0; //liga o led vermelho
    break;
    default: break;
    }
}
