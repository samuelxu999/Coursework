/*
********************* pushbutton_driver.h ×××××××××××××××××××××××
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-10-20
   Function: Interface definition for push-button driver
*/

#ifndef PUSHBUTTON_DRIVER_H_
#define PUSHBUTTON_DRIVER_H_

#include <avr/io.h>
#include <stdbool.h>

#define PUSHBUTTON_DDR DDRB
#define PUSHBUTTON_PORT PORTB
#define PUSHBUTTON_PIN PINB
#define PUSHBUTTON_PULLUP PORTB

#define LEFT_BUTTON_LOC 1
#define MIDDLE_BUTTON_LOC 4
#define RIGHT_BUTTON_LOC 5

/*****Declaration for pushbutton driver interface******/
void initialize_pushbutton_array();

bool left_button_is_pressed();

bool right_button_is_pressed();

bool middle_button_is_pressed();

#endif
