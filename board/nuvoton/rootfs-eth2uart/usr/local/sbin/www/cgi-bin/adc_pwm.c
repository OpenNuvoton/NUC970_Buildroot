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
	char result[4];
	int value;
        int fd;
	char *data;
	long pwm_ch,period,duty,adc_ch;

	printf("Content-Type: text/plain\n\n");
	//printf("Content-Type: text/html\n\n");

	data = getenv("QUERY_STRING");
	printf("QUERY_STRING is %s\n\n",data);

	if(data == NULL)
		printf("<P>Error! Error in passing data from form to script.");
	else if(sscanf(data,"pwm_ch=%ld&period=%ld&duty=%ld&adc_ch=%ld",&pwm_ch,&period,&duty,&adc_ch)!=4)
		printf("<P>Error! Invalid data. Data must be numeric.");
	else
		printf("<P>The PWM channel is %ld, period is %ld, duty is %ld, and ADC channel is %ld.\n",pwm_ch,period,duty,adc_ch);

	//PWM
	sprintf (buffer, "echo 0 > /sys/class/pwm/pwmchip%d/export", pwm_ch);
        system((const char *)buffer);
        //system("echo 0 > /sys/class/pwm/pwmchip0/export");

	sprintf (buffer, "echo 1 > /sys/class/pwm/pwmchip%d/pwm0/enable", pwm_ch);
        system((const char *)buffer);
        //system("echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable");

	sprintf (buffer, "echo %d > /sys/class/pwm/pwmchip%d/pwm0/period", period,pwm_ch);
        system((const char *)buffer);

	sprintf (buffer, "echo %d > /sys/class/pwm/pwmchip%d/pwm0/duty_cycle", duty,pwm_ch);
        system((const char *)buffer);


	//ADC
	sprintf (buffer, "/sys/bus/iio/devices/iio:device0/in_voltage%d_raw", adc_ch);
        fd = open(buffer, O_RDWR);
        //fd = open(buffer, O_RDONLY);

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

