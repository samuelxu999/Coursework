F_CPU = 20000000
MCU = atmega328p
CCOPTS= -g -Wall -Os -std=c99

default: compile

all: program
	
pushbutton_driver.o: pushbutton_driver.c pushbutton_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) pushbutton_driver.c -o pushbutton_driver.o

led_driver.o: led_driver.c led_driver.h
	avr-gcc -c $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) led_driver.c -o led_driver.o

compile: main.c pushbutton_driver.o led_driver.o
	avr-gcc  $(CCOPTS) -mmcu=$(MCU) -DF_CPU=$(F_CPU) -o program2 -g main.c pushbutton_driver.o led_driver.o
	    
hex: compile
	avr-strip program2
	avr-objcopy -R .eeprom -O ihex program2 program2.hex

program: hex
	avrdude -p m328p -c avrisp2 -P /dev/ttyACM0 -U flash:w:program2.hex

clean:
	rm program2 program2.hex pushbutton_driver.o led_driver.o
