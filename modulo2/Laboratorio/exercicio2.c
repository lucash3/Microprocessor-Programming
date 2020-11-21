#include <msp430.h> 

int x;

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	P2DIR &= ~BIT1; // limpa o direcional
	P2REN |= BIT1; // seta o resistor
	P2OUT |= BIT1; // seta a chave como 1 para não pressionado
	P1DIR |= BIT0; // Configura o led
	P1OUT &= ~BIT0; // desliga o led

	while(1){
	    if((P2IN & BIT1) != BIT1){ //se o botão for pressionado fazer
	        if(x = 0){
	        P1OUT ^= BIT0;
	        x = 1;
	        }
	    }
	    else x = 0;
	}
}
