.SUFFIXES : .x .o .c .s

CC := arm-linux-gcc
STRIP := arm-linux-strip

LED_TARGET = led.cgi
LED_SRCS := led_cgi.c

KEY_TARGET = key.cgi
KEY_SRCS := key_cgi.c

all: 
	$(CC) -static $(LED_SRCS) -o $(LED_TARGET)
	$(CC) -static $(KEY_SRCS) -o $(KEY_TARGET)
	$(STRIP) $(LED_TARGET) 
	$(STRIP) $(KEY_TARGET) 

clean:
	rm -f *.o 
	rm -f *.x 
	rm -f *.flat
	rm -f *.map
	rm -f temp
	rm -f *.img
	rm -f $(LED_TARGET)	
	rm -f $(KEY_TARGET)	
	rm -f *.gdb
	rm -f *.bak
