F_CPU = 20000000
MCU = atmega328p
CCOPTS= -g -Wall -Os -std=c99

default: compile

all: program

menu_driver.o: menu_driver.c menu_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) menu_driver.c -o menu_driver.o

ADC_driver.o: ADC_driver.c ADC_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) ADC_driver.c -o ADC_driver.o
	
motor_driver.o: motor_driver.c motor_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) motor_driver.c -o motor_driver.o

pushbutton_driver.o: pushbutton_driver.c pushbutton_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) pushbutton_driver.c -o pushbutton_driver.o

compile: main.c pushbutton_driver.o motor_driver.o ADC_driver.o menu_driver.o
	avr-gcc  $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -o pro_final -g main.c pushbutton_driver.o motor_driver.o lcd_driver.o ADC_driver.o menu_driver.o
	    
hex: compile
	avr-strip pro_final
	avr-objcopy -R .eeprom -O ihex pro_final pro_final.hex

program: hex
	avrdude -p m328p -c avrisp2 -P /dev/ttyACM0 -U flash:w:pro_final.hex

clean:
	rm pro_final pro_final.hex pushbutton_driver.o motor_driver.o ADC_driver.o menu_driver.o
