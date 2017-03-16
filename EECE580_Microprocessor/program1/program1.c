/*************************************************************************
assignment: program1
Author: Xu Ronghua 
mail:	rxu22@binghamton.edu
date:	 2016-10-7
Function:
toggles the green LED when the left pushbutton is pressed
toggle the red LED when the rightmost pushbutton is pressed 
truns off both LEDs when the middle pushbutton is
pressed.
***************************************************************************/

#include <avr/io.h>
#include <util/delay.h>

int main()
{
	/******************initialize port setting*************************/
	/*define direction for port pin: PD1-red LED and PD7-green LED*/
	DDRD|=(1<<DDD1)|(1<<DDD7);
		
	/*PB1-left button, PB4-middle button and PB5-right button*/
	//config DDRB1, DDRB4 and DDRB5 as input
	DDRB&=~((1<<DDB1)|(1<<DDB4)|(1<<DDB5));
		
	//enable internal pull-up by writing 1 to PORTB1, PORTB4 and PORTB5
	PORTB|=(1<<PORTB1)|(1<<PORTB4)|(1<<PORTB5);
	/******************************************************************/

	PORTD|=(1<<PORTD1);	
	PORTD|=(1<<PORTD7);
	while(1)
	{
		//press PB1-left button to toggle red led status
		if(0==(PINB&(1<<PINB1)))
		{
			PORTD^=(1<<PORTD1);
		}
		
		//press PB5-left button to toggle green led status
		if(0==(PINB&(1<<PINB5)))
		{
			PORTD^=(1<<PORTD7);			
		}
		
		//press PB4-middle button to turn off both red and green led
		if(0==(PINB&(1<<PINB4)))
		{
			PORTD&=~(1<<PORTD1);
			PORTD&=~(1<<PORTD7);
		}
		
		_delay_ms(250);
	}
	return 0;
}
