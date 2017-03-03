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

static char *PWM_export = "/sys/class/pwm/pwmchip0/export";
static char *PWM_enable = "/sys/class/pwm/pwmchip0/pwm0/enable";
static char *PWM_period = "/sys/class/pwm/pwmchip0/pwm0/period";
static char *PWM_duty_cycle = "/sys/class/pwm/pwmchip0/pwm0/duty_cycle";

int main(void)
{

	printf("Content-Type: text/plain\n\n");
	printf("Hello world !\n");
	printf("CGI test (PWM)..... !\n");

	// echo 0 > /sys/class/pwm/pwmchip0/export
	system("echo 0 > /sys/class/pwm/pwmchip0/export");

	// echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable
	system("echo 1 > /sys/class/pwm/pwmchip0/pwm0/enable");

	// echo 300000 > /sys/class/pwm/pwmchip0/pwm0/period
	system("echo 300000 > /sys/class/pwm/pwmchip0/pwm0/period");

	// echo 100000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle
	system("echo 100000 > /sys/class/pwm/pwmchip0/pwm0/duty_cycle");

        return 0;
}

