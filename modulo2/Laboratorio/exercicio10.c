#include <msp430.h> 

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    TA0CTL = (TACLR | TASSEL__ACLK | MC__UP);
    TA0CCR0 = 16385;
    TA0CCTL0 |= CCIE; // Habilita interrupção do TA0.0
    P1DIR |= BIT0;                // Seta led vermelho
    P1OUT &=~ BIT0;               // apaga led vermelho

    __enable_interrupt();
    while(1);
}

#pragma vector= 53 //Interrupção do TA0.0
__interrupt void TA0_CCR0_ISR() {
    P1OUT ^= BIT0;                  // Alterna o led vermelho
}
