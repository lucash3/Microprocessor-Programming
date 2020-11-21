#include <msp430.h>

int x,y,z,inc, sair;
unsigned char rand();
void debounce();
void valid();
int main(void)
{
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
        z = rand();
        P1OUT &= ~BIT0;
        P4OUT &= ~BIT7;
        inc = 0;
        sair = 0;
        while(sair == 0){
            if((P2IN & BIT1) != BIT1 && (P1IN & BIT1) != BIT1){
                while((P2IN & BIT1) != BIT1 || (P1IN & BIT1) != BIT1){
                    P1OUT ^= BIT0;
                    P4OUT ^= BIT7;
                    __delay_cycles(1000000);
                }
                P1OUT &= ~BIT0;
                P4OUT &= ~BIT7;
                debounce();
            }
            if((P2IN & BIT1) != BIT1){
                if(x == 0){
                    inc ++;
                    x = 1;
                    debounce();
                }
            }
            else x = 0;
               if((P1IN & BIT1) != BIT1){
                    if(y == 0){
                        y = 1;
                        valid();
                        P1OUT &= ~BIT0;
                        P4OUT &= ~BIT7;
                    }
                }
                else y = 0;
            debounce();
        }
    }
}

unsigned char rand(){
    static unsigned char num = 6;
    num = (num * 17) % 7;
    while(num == 0){
        num = (num * 17) % 7;
    }
    return num;
}

void valid(){
    int i = 0;
    if(inc == 0){
        while(i < 4){
            P1OUT ^= BIT0;
            P4OUT ^= BIT7;
            i++;
            __delay_cycles(1000000);
        }
        sair = 1;
        return;
    }
    else if(inc == z){
        P4OUT |= BIT7;
        __delay_cycles(3000000);
    }
    else{
        P1OUT |= BIT0;
        __delay_cycles(3000000);
    }
    sair = 1;
}
void debounce(void){
    int contar = 0;
    while(contar != 10000)
            contar ++;
}
