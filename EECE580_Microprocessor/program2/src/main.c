/*************************************************************************
 Assignment: program2
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-10-20
   Function: Test interfaces of drivers 
***************************************************************************/

#include "led_driver.h"
#include "pushbutton_driver.h"
#include <util/delay.h>

int main()
{
	/******************initialize port*************************/
	initialize_red_led();
	initialize_green_led();
	initialize_pushbutton_array();

	turn_on_red_led();	
	turn_on_green_led();

	while(1)
	{
		//press PB1-left button to toggle red led status
		if(left_button_is_pressed())
		{
			toggle_red_led();
		}
		
		//press PB5-left button to toggle green led status
		if(right_button_is_pressed())
		{
			toggle_green_led();			
		}
		
		//press PB4-middle button to turn off both red and green led
		if(middle_button_is_pressed())
		{
			turn_off_red_led();	
			turn_off_green_led();
		}
		
		_delay_ms(250);
	}
	return 0;
}
