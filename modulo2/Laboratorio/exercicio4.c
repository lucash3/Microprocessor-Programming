#include <msp430.h> 

int x, y;
void debounce(void);
int main(void){

    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P2DIR &= ~BIT1; // limpa o direcional
    P2REN |= BIT1; // seta o resistor
    P2OUT |= BIT1; // seta a chave como 1 para não pressionado
    P1DIR &= ~BIT1; // limpa o direcional
    P1REN |= BIT1; // seta o resistor
    P1OUT |= BIT1; // seta a chave como 1 para não pressionado
    P1DIR |= BIT0; // Configura o led
    P1OUT &= ~BIT0; // desliga o led

    while(1){
        if((P2IN & BIT1) != BIT1){
            if(x == 0){
                P1OUT ^= BIT0;
                x = 1;
            }
        }
        else x = 0;
        if((P1IN & BIT1) != BIT1){
            if(y == 0){
                P1OUT ^= BIT0;
                y = 1;
            }
        }
        else y = 0;
        debounce();
    }
}
void debounce(void){
    volatile int atraso = 10000;                     //determina um valor inteiro inicial de 10000
    while(atraso > 0)                      //executa enquanto atraso não for 0
        atraso --;                          //subtrai 1 do valor atual de atraso
}
