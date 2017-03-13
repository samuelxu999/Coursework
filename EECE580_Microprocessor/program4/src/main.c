/***********************************************************************************************************
 Assignment: program4
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-11-23
Change date: 2016-11-30
   Function: Using the attached LCD driver, write a program that turns the 3Pi display into a hex stopwatch.  
	1) The left button functions as a start, the right as stop, and the middle as clear/lap.
	2) In stop mode, the middle clears the time.
	3) In run mode, it freezes the display but the counter keeps counting in the background.
	   When pressed again, the display once again shows the counter in real time.  
	4) The display should show the seconds and milliseconds, in hex, separated by colons.
	Seconds should count modulo-60 and milliseconds modulo-1000.  
	5) Create an interrupt-based driver using a timer module to obtain 1ms timing update of the counter.
************************************************************************************************************/

#include "timer_driver.h"
#include "lcd_driver.h"
#include "pushbutton_driver.h"
#include <util/delay.h>

#define TO_HEX(i) (i <= 9 ? '0' + i : 'A' + i - 10)

/* Transfer number to string with hex8 format */
void IntToHex8(char* pDes, unsigned long ulnum)
{
	int num = (int)(ulnum);	

	if (num <= 0xFF)
	{
		pDes[0] = TO_HEX(((num & 0xF0) >> 4));
		pDes[1] = TO_HEX((num & 0x0F));
		pDes[2] = '\0';
	}	
}

/* Transfer number to string with hex16 format */
void IntToHex16(char* pDes, unsigned long ulnum)
{
	int num = (int)(ulnum);	

	if (num <= 0xFFFF)
	{
		pDes[0] = TO_HEX(((num & 0xF000) >> 12));   
		pDes[1] = TO_HEX(((num & 0x0F00) >> 8));
		pDes[2] = TO_HEX(((num & 0x00F0) >> 4));
		pDes[3] = TO_HEX((num & 0x000F));
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
	//1ms timing update of the counter
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
	
	//lcd refresh flag
	uint8_t Is_refresh_lcd =1;	

	while(1)
	{		
		/* Waits for a button press */ 
		if(left_button_is_pressed())
		{
			//if in stop mode, then run timer counter.
			if(!(TIMSK2&(1 << TIMER_EN)))	
			{
				start_timer();
			}					
		}
		if(right_button_is_pressed())
		{
			//if in run mode, then stop timer counter.
			if(TIMSK2&(1 << TIMER_EN))
			{
				stop_timer();				
			}									
		}
		if(middle_button_is_pressed())
		{
			if(TIMSK2&(1 << TIMER_EN))			
			{				
				//in run mode,lcd forzen while counter keeps runings: just toggle lcd refresh flag
				Is_refresh_lcd^=0x01;
				_delay_ms(100);
			}
			else
			{
				//in stop mode: clear timer counting value
				reset_timer();
				Is_refresh_lcd =1;				
			}						
		}
		
		//refresh lcd to display stopwatch	
		if(Is_refresh_lcd==1)
		{
			refresh_display();
		}
		
	}
	return 0;
}
