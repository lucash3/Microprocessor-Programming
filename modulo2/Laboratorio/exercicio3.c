#include <msp430.h> 

void debounce(void);
int x;

int main(void){
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P2DIR &= ~BIT1; // limpa o direcional
    P2REN |= BIT1; // seta o resistor
    P2OUT |= BIT1; // seta a chave como 1 para não pressionado
    P1DIR |= BIT0; // Configura o led
    P1OUT &= ~BIT0; // desliga o led

    while(1){
        if((P2IN & BIT1) != BIT1){ //se o botão for pressionado fazer
            if(x == 0){
            P1OUT ^= BIT0;
            x = 1;
            debounce();
            }
        }
        else x = 0;
    }
}

void debounce(void){
    volatile int atraso = 10000;                     //determina um valor inteiro inicial de 10000
    while(atraso > 0)                      //executa enquanto atraso não for 0
        atraso --;                          //subtrai 1 do valor atual de atraso
}
