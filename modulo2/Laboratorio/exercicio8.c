#include <msp430.h> 

void counter(void);
int main(void){
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	P1DIR |= BIT0; // Configura o led
    P1OUT &= ~BIT0; // desliga o led
	
    while(1){
        counter();
        counter();
        counter();
        counter();
        counter();

        P1OUT ^= BIT0;
    }
}

void counter(void){
    int contar = 0;
    while(contar != 10000) contar ++;
}
