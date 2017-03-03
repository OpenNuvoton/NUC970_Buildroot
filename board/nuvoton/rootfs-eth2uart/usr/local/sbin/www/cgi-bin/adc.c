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

static char *ADC_CH0 = "/sys/bus/iio/devices/iio:device0/in_voltage0_raw";
static char *ADC_CH1 = "/sys/bus/iio/devices/iio:device0/in_voltage1_raw";
static char *ADC_CH2 = "/sys/bus/iio/devices/iio:device0/in_voltage2_raw";
static char *ADC_CH3 = "/sys/bus/iio/devices/iio:device0/in_voltage3_raw";
static char *ADC_CH4 = "/sys/bus/iio/devices/iio:device0/in_voltage4_raw";
static char *ADC_CH5 = "/sys/bus/iio/devices/iio:device0/in_voltage5_raw";

int main(int argc, char * const argv[])
{
	char result[4];
	int value;
        int fd;
	int i;
	char *data;
	long period,duty,channel;

	//printf("Content-Type: text/plain\n\n");
	printf("Content-Type: text/html\n\n");

	data = getenv("QUERY_STRING");
	printf("QUERY_STRING is %s\n\n",data);

	if(data == NULL)
		printf("<P>Error! Error in passing data from form to script.");
	else if(sscanf(data,"period=%ld&duty=%ld&channel=%ld",&period,&duty,&channel)!=3)
		printf("<P>Error! Invalid data. Data must be numeric.");
	else
		printf("<P>The period is %ld, duty is %ld, and ADC channel is %ld.\n",period,duty,channel);

	if (channel == 0)
        	fd = open(ADC_CH0, O_RDWR);
        //fd = open(ADC_CH1, O_RDONLY);
	else if (channel == 1)
                fd = open(ADC_CH1, O_RDWR);
	else if (channel == 2)
                fd = open(ADC_CH2, O_RDWR);
	else if (channel == 3)
                fd = open(ADC_CH3, O_RDWR);
	else if (channel == 4)
                fd = open(ADC_CH4, O_RDWR);
	else if (channel == 5)
                fd = open(ADC_CH5, O_RDWR);

        if (fd == -1) {
        	printf("\n\n Open ADC device failed!!\n");
                perror("ADC");
                exit(EXIT_FAILURE);
        }

        printf("Open ADC device ok!\n");

	read(fd,result,4);
	value = atoi(result);
	printf("ADC conversion result = %d\n",value);

        close(fd);

        return 0;
}

