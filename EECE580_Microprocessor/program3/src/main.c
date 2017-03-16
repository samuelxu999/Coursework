/********************************************************************************************************
 Assignment: program3
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-11-9
   Function: Test interfaces of drivers for motor
1. Lights a LED upon program start
2. Waits for a button press on any button
3. Performs the following sequence of movements exactly once, with a 1s delay between movements:
(a) Moves the robot forward at full speed for 1s
(b) Moves the robot in reverse at half speed for 2s
(c) Pivots the robot counterclockwise at 25% speed for approximately 1 revolution
(d) Pivots the robot clockwise at 10% speed for approximately 1 revolution
(e) Travels in an obvious forward arc for t seconds (you choose the radious and time t) interface
(f) Performs the inverse operation to e
4. The robot should be at approximately its starting position and the program should return to step 2
********************************************************************************************************/

#include "led_driver.h"
#include "pushbutton_driver.h"
#include "motor_driver.h"
#include <util/delay.h>

void test_motor_driver()
{
	uint8_t test_duty_cycle=0xff;
	
	//Moves the robot forward at full speed for 1s
	test_duty_cycle=0xff;
	set_left_motor_duty_cycle(test_duty_cycle);
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_forward();
	engage_right_motor_forward();	
	_delay_ms(1000);
	brake_left_motor();
	brake_right_motor();	

	_delay_ms(1000);

	//Moves the robot in reverse at half speed for 2s
	test_duty_cycle=0x80;
	set_left_motor_duty_cycle(test_duty_cycle);
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_backward();
	engage_right_motor_backward();
	_delay_ms(2000);
	brake_left_motor();
	brake_right_motor();	

	_delay_ms(1000);

	//Pivots the robot counterclockwise at 25% speed for approximately 1 revolution
	test_duty_cycle=0x40;
	set_left_motor_duty_cycle(test_duty_cycle);
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_backward();
	engage_right_motor_forward();
	_delay_ms(1050);
	brake_left_motor();
	brake_right_motor();

	_delay_ms(1000);

	//Pivots the robot clockwise at 10% speed for approximately 1 revolution
	test_duty_cycle=0x1a;
	set_left_motor_duty_cycle(test_duty_cycle);
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_forward();
	engage_right_motor_backward();
	_delay_ms(3300);
	brake_left_motor();
	brake_right_motor();

	_delay_ms(1000);

	//Travels in an obvious forward arc for t seconds (you choose the radious and time t) interface
	test_duty_cycle=0x20;
	set_left_motor_duty_cycle(test_duty_cycle);
	test_duty_cycle=0x18;
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_forward();
	engage_right_motor_forward();
	_delay_ms(3300);
	brake_left_motor();
	brake_right_motor();

	_delay_ms(1000);

	//Travels in an obvious backward arc for t seconds (you choose the radious and time t) interface
	test_duty_cycle=0x20;
	set_left_motor_duty_cycle(test_duty_cycle);
	test_duty_cycle=0x18;
	set_right_motor_duty_cycle(test_duty_cycle);
	engage_left_motor_backward();
	engage_right_motor_backward();
	_delay_ms(3000);
	brake_left_motor();
	brake_right_motor();

	_delay_ms(1000);
	
}
	

int main()
{
	/******************initialize port*************************/
	initialize_red_led();
	initialize_green_led();
	initialize_pushbutton_array();
	initialize_left_motor();
	initialize_right_motor();

	//turn on LED after startup
	turn_on_red_led();	
	//turn_on_green_led();

	while(1)
	{
		
		//Waits for a button press on any button
		if(left_button_is_pressed()||middle_button_is_pressed()||right_button_is_pressed())
		{			
			test_motor_driver();
		}		
		_delay_ms(250);
	}
	return 0;
}
