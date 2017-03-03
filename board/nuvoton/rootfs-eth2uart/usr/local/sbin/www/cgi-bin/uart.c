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
	char buffer [30];
        int fd;
	char *data;
	long ur_port, ur_baud, ur_data, ur_parity, ur_stop, ur_flow, ur_485;

	printf("Content-Type: text/plain\n\n");
	//printf("Content-Type: text/html\n\n");

	data = getenv("QUERY_STRING");
	printf("QUERY_STRING is %s\n\n",data);

	if(data == NULL)
		printf("<P>Error! Error in passing data from form to script.");
	else if(sscanf(data,"ur_port=%ld&ur_baud=%ld&ur_data=%ld&ur_parity=%ld&ur_stop=%ld&ur_flow=%ld&ur_485=%ld",&ur_port,&ur_baud,&ur_data,&ur_parity,&ur_stop,&ur_flow,&ur_485) != 7)
		printf("<P>Error! Invalid data. Data must be numeric.");
	else
		printf("<P>The UART Port is %ld, Baudrate is %ld, Data is %ld, Parity is %ld, Stop is %ld, Flow Control is %ld\n",ur_port,ur_baud,ur_data,ur_parity,ur_stop,ur_flow,ur_485);

	//Write the UART settings to SPI flash
        fd = open("/mnt/mtdblock0/uart.ini",O_CREAT|O_RDWR);

        if (fd == -1) {
        	printf("\n\n Open /mnt/mtdblock0/uart.ini failed!!\n");
                perror("SPI");
                exit(EXIT_FAILURE);
        }

        printf("Open /mnt/mtdblock0/uart.ini ok!\n");

	memset(buffer,0,30);
	sprintf (buffer, "%d,%d,%d,%d,%d,%d,%d",ur_port,ur_baud,ur_data,ur_parity,ur_stop,ur_flow,ur_485);
	write(fd,buffer,30);
        close(fd);

	switch (ur_port) {
	case 1 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart1.ini");
		break;
	case 2 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart2.ini");
		break;
	case 3 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart3.ini");
		break;
	case 4 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart4.ini");
		break;
	case 5 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart5.ini");
		break;
	case 6 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart6.ini");
		break;
	case 7 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart7.ini");
		break;
	case 8 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart8.ini");
		break;
	case 9 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart9.ini");
		break;
	case 10 :
		system("cp /mnt/mtdblock0/uart.ini /mnt/mtdblock0/uart10.ini");
		break;
	}

        return 0;
}

