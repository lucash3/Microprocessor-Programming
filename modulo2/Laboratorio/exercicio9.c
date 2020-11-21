#include <msp430.h> 

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    TA0CTL = (TACLR | TASSEL__ACLK | MC__UP);
    TA0CCR0 = 16385;
    P1DIR |= BIT0;                // Seta led vermelho
    P1OUT &=~ BIT0;               // apaga led vermelho

    while(1){
        while(!(TA0CCTL0 & CCIFG));
        P1OUT ^= BIT0;                  // Alterna o led vermelho
            TA0CCTL0 &=~ CCIFG;             // Limpa flag
    }
}
