#include <msp430.h> 

int x,y,z;
void counter(void);
void debounce(void);
void inc();
void dec();

int main(void){
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	P2DIR &= ~BIT1; // limpa o direcional
	P2REN |= BIT1; // seta o resistor
	P2OUT |= BIT1; // seta a chave como 1 para não pressionado
	P1DIR &= ~BIT1; // limpa o direcional
	P1REN |= BIT1; // seta o resistor
	P1OUT |= BIT1; // seta a chave como 1 para não pressionado
	P1DIR |= BIT0; // Configura o led vermelho
	P1OUT &= ~BIT0; // desliga o led vermelho
	P4DIR |= BIT7; // configura o led verde
	P4OUT &= ~BIT7; // desliga o led verde
	
	while(1){
	    if((P2IN & BIT1) != BIT1 && (P1IN & BIT1) != BIT1){
        if(x == 0 && y == 0){
        P1OUT &= ~BIT0;
        P4OUT &= ~BIT7;
        x = 1;
        y = 1;
        }
    }
    if((P2IN & BIT1) != BIT1){
        if(x == 0){
            inc();
            counter();
            x = 1;
        }
    }
    else x = 0;
       if((P1IN & BIT1) != BIT1){
            if(y == 0){
                dec();
                counter();
                y = 1;
            }
        }
        else y = 0;
    debounce();
	}
}

void inc(){
    z = z + 1;
    if(z == 4) z = 0;
}
void dec(){
    z = z - 1;
    if(z == -1) z = 3;
}
void counter(void){
    if(z == 0){
    P1OUT &= ~BIT0;
    P4OUT &= ~BIT7;
    }
    else if(z == 1){
        P1OUT &= ~BIT0;
        P4OUT |= BIT7;
    }
    else if(z == 2){
        P1OUT |= BIT0;
        P4OUT &= ~BIT7;
    }
    else{
        P1OUT |= BIT0;
        P4OUT |= BIT7;
    }
}
void debounce(void){
    volatile int atraso = 10000;                     //determina um valor inteiro inicial de 10000
    while(atraso > 0)                      //executa enquanto atraso não for 0
        atraso --;                          //subtrai 1 do valor atual de atraso
}

