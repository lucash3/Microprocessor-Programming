#include <msp430.h> 

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    TA0CTL = (TACLR | TASSEL__ACLK | MC__UP);
    TA0CCR0 = 16385;
    TA0CCR1 = 6553;
    TA0CCTL1 |= CCIE;// Habilita interrupção do TA0.0
    TA0CCTL2 |= CCIE;// Habilita interrupção do TA0.1
    P4DIR |= BIT7;                // Seta led verde
    P4OUT &=~ BIT7;               // apaga led verde
    P1DIR |= BIT0;                //seta led vermelho
    P1OUT &= ~BIT0;               //desliga led vermelho

    __enable_interrupt();
    while(1);
}

#pragma vector= 53 //Interrupção do TA0.0
__interrupt void TA0_CCR1_ISR(){
    P1OUT ^= BIT0; // Alterna o led vermelho
}
#pragma vector= 52 // Interrupção do TA0.1
__interrupt void TA0_CCR2_ISR(){
    P4OUT ^= BIT7; // Alterna o led verde
}
