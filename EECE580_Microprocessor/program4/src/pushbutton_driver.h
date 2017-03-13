/*
********************* pushbutton_driver.h ×××××××××××××××××××××××
     Author: Xu Ronghua 
       Mail: rxu22@binghamton.edu
Create date: 2016-10-20
   Function: Interface definition for push-button driver
*/

#ifndef PUSHBUTTON_DRIVER_H
#define PUSHBUTTON_DRIVER_H

#include <avr/io.h>
#include <stdbool.h>
#include "port_macros.h"

#define PUSHBUTTON_DDR DDR(B)
#define PUSHBUTTON_PORT PORT(B)
#define PUSHBUTTON_PIN PIN(B)
#define PUSHBUTTON_PULLUP PULLUP(B)

#define LEFT_BUTTON_LOC 1
#define MIDDLE_BUTTON_LOC 4
#define RIGHT_BUTTON_LOC 5

/*****Declaration for pushbutton driver interface******/
void initialize_pushbutton_array();

bool left_button_is_pressed();

bool right_button_is_pressed();

bool middle_button_is_pressed();

#endif
