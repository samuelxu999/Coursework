/********************************************************************************************************
 Assignment: program4
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-11-18
   Function: Using the attached LCD driver, write a program that turns the 3Pi display into a hex stopwatch.  
The left button functions as a start, the right as stop, and the middle as clear/lap 
in stop mode, the middle clears the time; 
in stop mode, it freezes the display but the counter keeps counting in the background.  
The display should show the seconds and milliseconds, in hex, separated by colons.  
Seconds should count modulo-60 and milliseconds modulo-1000.  
Create an interrupt-based driver using a timer module to obtain 1ms timing update of the counter.
********************************************************************************************************/

#include "timer_driver.h"
#include "lcd_driver.h"
#include "led_driver.h"
#include "pushbutton_driver.h"
#include "motor_driver.h"
#include <util/delay.h>


#define TO_HEX(i) (i <= 9 ? '0' + i : 'A' - 10 + i)

/* Transfer number to string with hex8 format */
void IntToHex8(char* pDes, unsigned long ulnum)
{
	int x = (int)(ulnum);	

	if (x <= 0xFF)
	{
		pDes[0] = TO_HEX(((x & 0xF0) >> 4));
		pDes[1] = TO_HEX((x & 0x0F));
		pDes[2] = '\0';
	}	
}

/* Transfer number to string with hex16 format */
void IntToHex16(char* pDes, unsigned long ulnum)
{
	int x = (int)(ulnum);	

	if (x <= 0xFFFF)
	{
		pDes[0] = TO_HEX(((x & 0xF000) >> 12));   
		pDes[1] = TO_HEX(((x & 0x0F00) >> 8));
		pDes[2] = TO_HEX(((x & 0x00F0) >> 4));
		pDes[3] = TO_HEX((x & 0x000F));
		pDes[4] = '\0';
	}	
}

/* Transfer sec and ms to time string with format:ss:xxxx */
void IntToTimer_sec_ms(char* pDes, unsigned long ulsec, unsigned long ulms)
{
	unsigned int sec = (unsigned int)(ulsec);
	unsigned int ms = (unsigned int)(ulms);

	//get sec
	pDes[0] = TO_HEX(((sec & 0xF0) >> 4));
	pDes[1] = TO_HEX((sec & 0x0F));

	pDes[2] = ':';

	//get ms
	pDes[3] = TO_HEX(((ms & 0xF000) >> 12));   
	pDes[4] = TO_HEX(((ms & 0x0F00) >> 8));
	pDes[5] = TO_HEX(((ms & 0x00F0) >> 4));
	pDes[6] = TO_HEX((ms & 0x000F));
	pDes[7] = '\0';	
}

/* refresh LCD to show stopwatch on display */
void refresh_display()
{
	char res[8];
	//IntToHex8(res,get_secCount());
	IntToTimer_sec_ms(res,get_secCount(),get_msCount());	
	LCD_execute_command(CLEAR_DISPLAY);	
	
	LCD_print_String(res);
	_delay_ms(1);
}

int main()
{
	/******************initialize port*************************/
	initialize_pushbutton_array();	
	initialize_LCD_driver();
	initialize_timer();
		
	//turn on LCD after startup
	LCD_execute_command(CLEAR_DISPLAY);
	LCD_execute_command(TURN_ON_DISPLAY);		
	
	while(1)
	{
		
		//Waits for a button press on any button
		if(left_button_is_pressed())
		{						
			//LCD_execute_command(CLEAR_DISPLAY);
			//LCD_print_String("LEFT");
			//LCD_print_hex8(get_secCount());
			//LCD_execute_command(MOVE_CURSOR_HOME);
			start_timer();
		}
		if(right_button_is_pressed())
		{
			//LCD_execute_command(TURN_ON_DISPLAY);
			//LCD_execute_command(TURN_ON_BLINKING_CURSOR);
			//LCD_execute_command(CLEAR_DISPLAY);			
			//LCD_print_hex16(get_msCount());
			//LCD_execute_command(TURN_ON_STEADY_CURSOR);
			//LCD_move_cursor_to_col_row(0, 1);
			stop_timer();
		}
		if(middle_button_is_pressed())
		{	
			//LCD_execute_command(TURN_OFF_DISPLAY);
			//LCD_execute_command(CLEAR_DISPLAY);			
			//LCD_print_hex8(get_minCount());
			//LCD_execute_command(TURN_ON_BLINKING_CURSOR);
			//LCD_move_cursor_to_col_row(2, 1);
			reset_timer();			
		}
		
		//refresh timer
		refresh_display();		

	}
	return 0;
}
