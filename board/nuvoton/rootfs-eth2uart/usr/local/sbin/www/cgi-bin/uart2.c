/*
 * Copyright (c) 2014 Nuvoton technology corporation
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
//#include <linux/watchdog.h>

int main(int argc, char * const argv[])
{
	char buffer [100];
        int fd;
	char *data;
	long ur_port, ur_baud, ur_data, ur_parity, ur_stop, ur_flow, ur_485;

	//Read the UART settings from SPI flash
        fd = open("/mnt/mtdblock0/uart.ini",O_RDWR);

	printf("Content-Type: text/html\n\n");
	printf("NUC972 UART settings:\n\n");

        if (fd == -1) {
		printf("<FORM METHOD=\"GET\" ACTION=\"uart.cgi\">");
		printf("Port<INPUT SIZE=10 VALUE= \"2\" NAME=\"ur_port\">(1~10)<BR>");
		printf("Baudrate<INPUT SIZE=10 VALUE= \"115200\" NAME=\"ur_baud\">bps<BR>");
		printf("Data<INPUT SIZE=10 VALUE = \"8\" NAME=\"ur_data\">(8 or 7 bits)<BR>");
		printf("Parity<INPUT SIZE=10 VALUE = \"0\" NAME=\"ur_parity\">(0:none, 1:odd, 2:even)<BR>");
		printf("Stop<INPUT SIZE=10 VALUE = \"1\" NAME=\"ur_stop\">(1 or 2 bits)<BR>");
		printf("Flow Control<INPUT SIZE=10 VALUE = \"0\" NAME=\"ur_flow\">(0:none, 1:hardware, 2:Xon/Xoff)(Port 1,2,4,6,8,10 support only)<BR>");
		printf("RS485<INPUT SIZE=10 VALUE = \"0\" NAME=\"ur_485\">(0:Disable, 1:Enable)(Port 1,2 support only)<BR>");
		printf("<INPUT TYPE=\"submit\" VALUE=\"Submit\">");
		printf("</FORM>");
        }
	else {
		read(fd,buffer,100);
		sscanf(buffer,"%ld,%ld,%ld,%ld,%ld,%ld,%ld",&ur_port,&ur_baud,&ur_data,&ur_parity,&ur_stop,&ur_flow,&ur_485);

		printf("<FORM METHOD=\"GET\" ACTION=\"uart.cgi\">");
		printf("Port<INPUT SIZE=10 VALUE= \"%ld\" NAME=\"ur_port\">(1~10)<BR>",ur_port);
		printf("Baudrate<INPUT SIZE=10 VALUE= \"%ld\" NAME=\"ur_baud\">bps<BR>",ur_baud);
		printf("Data<INPUT SIZE=10 VALUE = \"%ld\" NAME=\"ur_data\">(8 or 7 bits)<BR>",ur_data);
		printf("Parity<INPUT SIZE=10 VALUE = \"%ld\" NAME=\"ur_parity\">(0:none, 1:odd, 2:even)<BR>",ur_parity);
		printf("Stop<INPUT SIZE=10 VALUE = \"%ld\" NAME=\"ur_stop\">(1 or 2 bits)<BR>",ur_stop);
		printf("Flow Control<INPUT SIZE=10 VALUE = \"%ld\" NAME=\"ur_flow\">(0:none, 1:hardware, 2:Xon/Xoff)(Port 1,2,4,6,8,10 support only)<BR>",ur_flow);
		printf("RS485<INPUT SIZE=10 VALUE = \"%ld\" NAME=\"ur_485\">(0:Disable, 1:Enable)(Port 1,2 support only)<BR>",ur_485);
		printf("<INPUT TYPE=\"submit\" VALUE=\"Submit\">");
		printf("</FORM>");
	}

        close(fd);
        return 0;
}

