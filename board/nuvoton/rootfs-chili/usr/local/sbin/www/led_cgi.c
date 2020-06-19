/* LED CGI Program
 *
 *
 * Note :
 *   PORT NAME[PIN] = GPIO [id]	
 *   PORTA[ 0]      = gpio[ 0x00]
 *   PORTA[ 1]      = gpio[ 0x01]	  
 *                  :
 *   PORTA[31]      = gpio[ 0x1F]
 *   PORTB[ 0]      = gpio[ 0x20]
 *                  :
 *   PORTB[31]      = gpio[ 0x3F]
 *                  :
 *                  :
 *                  :
 *   PORTI[ 0]      = gpio[ 0xC0]
 *                  :
 *                  :
 *   PORTI[31]      = gpio[ 0xDF]
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#if 0
//For NK-980IOT board
#define LED1_NUM	0x28 //PB8--->LED3
#define LED2_NUM	0x2D //PB13--->LED5
#endif

//For chili board
#define LED1_NUM	0x4B //PC11--->LED1
#define LED2_NUM	0x43 //PC3--->LED2

#if 0		
//For NuDesign-EtherU and NuDesign-EtherD
#define LED1_NUM	0x6C //PD12
#define LED2_NUM	0x6D //PD13
#define LED3_NUM	0x6E //PD14
#endif	

int main(void)
{
	FILE *fp;
	char str[256];

	char *data;
	long led1,led2;

	data = getenv("QUERY_STRING");

	if(data == NULL)
		printf("<P>Error! Error in passing data from form to script.");

	led1 = 0;
	led2 = 0;
	sscanf(data,"LED1=%ld&LED2=%ld",&led1,&led2);


	sprintf(str,"/sys/class/gpio/gpio%d/direction",LED1_NUM);
	if ((fp = fopen(str, "w")) == NULL) {

		//linux equivalent code "echo pin_num > export" to export the pin
		if ((fp = fopen("/sys/class/gpio/export", "w")) == NULL) {
			printf("Cannot open export file.\n");
			exit(1);
		}
		fprintf(fp, "%d", LED1_NUM);
		fclose(fp);

		//linux equivalent code "echo out > direction" to set the pin as an output  
		sprintf(str,"/sys/class/gpio/gpio%d/direction",LED1_NUM);
		if ((fp = fopen(str, "w")) != NULL) {
			fprintf(fp, "out");
			fclose(fp);
		}
	}
	else{
		fclose(fp);
	}

	sprintf(str,"/sys/class/gpio/gpio%d/direction",LED2_NUM);
	if ((fp = fopen(str, "w")) == NULL) {

		//linux equivalent code "echo pin_num > export" to export the pin
		if ((fp = fopen("/sys/class/gpio/export", "w")) == NULL) {
			printf("Cannot open export file.\n");
			exit(1);
		}
		fprintf(fp, "%d", LED2_NUM);
		fclose(fp);



		//linux equivalent code "echo out > direction" to set the pin as an output  
		sprintf(str,"/sys/class/gpio/gpio%d/direction",LED2_NUM);
		if ((fp = fopen(str, "w")) != NULL) {
			fprintf(fp, "out");
			fclose(fp);
		}
	}
	else{
		fclose(fp);
	}

	//linux equivalent code "echo "0" > value" to set the pin high/low 
	sprintf(str,"/sys/class/gpio/gpio%d/value",LED1_NUM);
	if ((fp = fopen(str, "w")) != NULL) {
		if(led1)
			fprintf(fp, "%d", 0);
		else
			fprintf(fp, "%d", 1);		
		fclose(fp);
	}
	
	//linux equivalent code "echo "0" > value" to set the pin high/low 
	sprintf(str,"/sys/class/gpio/gpio%d/value",LED2_NUM);
	if ((fp = fopen(str, "w")) != NULL) {
		if(led2)
			fprintf(fp, "%d", 0);
		else
			fprintf(fp, "%d", 1);		
		fclose(fp);
	}
	
	printf("<div id=\"ledimg_content\">\n");

	if((led1 == 0) && (led2 == 0)){	
		printf("<img id=\"led_img\" src=\"LED_1_off_2_off.jpg\">\n");
	}
	else if((led1 == 1) && (led2 == 0)){	
		printf("<img id=\"led_img\" src=\"LED_1_on_2_off.jpg\">\n");
	}
	else if((led1 == 0) && (led2 == 1)){	
		printf("<img id=\"led_img\" src=\"LED_1_off_2_on.jpg\">\n");
	}
	else if((led1 == 1) && (led2 == 1)){	
		printf("<img id=\"led_img\" src=\"LED_1_on_2_on.jpg\">\n");
	}

    printf("</drv>\n");

	return 0;
}
