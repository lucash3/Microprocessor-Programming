#include <msp430.h> 

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	P2DIR &= ~BIT1; // limpa o direcional
	P2REN |= BIT1; // seta o resistor
	P2OUT |= BIT1; // seta a chave como 1 para não pressionado
	P4DIR |= BIT7; // Configura o led
	P4OUT &= ~BIT7; // desliga o led

	while(1){
	        while((P2IN & BIT1) == BIT1) P4OUT &= ~BIT7;
	        while((P2IN & BIT1) != BIT1) P4OUT |= BIT7;
	    }
/*	while(1){
	    if((P2IN & BIT1) == BIT1) P1OUT &= ~BIT0;
	    else P1OUT |= BIT0;
                            // outro jeito de realizar o programa
	}*/
}
