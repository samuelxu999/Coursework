/*
************* led_driver.h ×××××××××××××××××××××××
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-10-20
   Function: Interface definition for LED driver
*/

#ifndef LED_DRIVER_H_
#define LED_DRIVER_H_

#include <avr/io.h>

#define LED_DDR DDRD
#define LED_PORT PORTD

#define RED_LED_LOC 1
#define GREEN_LED_LOC 7

/*****declear pushbutton driver interface******/

void initialize_red_led();

void initialize_green_led();

void turn_on_red_led();

void turn_off_red_led();

void turn_on_green_led();

void turn_off_green_led();

void toggle_red_led();

void toggle_green_led();

#endif
