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

//For NK-980IOT board
//#define KEY1_NUM	0x8A //PE10
//#define KEY2_NUM	0x8C //PE12

//For chili board
#define KEY1_NUM	0x4F //PC15

int main(void)
{
	FILE *fp;
	char str[256];

	char buffer[10];
	int key1;

	key1 = 0;

	sprintf(str,"/sys/class/gpio/gpio%d/direction",KEY1_NUM);
	if ((fp = fopen(str, "w")) == NULL) {

		//linux equivalent code "echo pin_num > export" to export the pin
		if ((fp = fopen("/sys/class/gpio/export", "w")) == NULL) {
			printf("Cannot open export file.\n");
			exit(1);
		}
		fprintf(fp, "%d", KEY1_NUM);
		fclose(fp);

		//linux equivalent code "echo out > direction" to set the pin as an output  
		sprintf(str,"/sys/class/gpio/gpio%d/direction",KEY1_NUM);
		if ((fp = fopen(str, "w")) != NULL) {
			fprintf(fp, "in");
			fclose(fp);
		}
	}
	else{
		fclose(fp);
	}

	sprintf(str,"/sys/class/gpio/gpio%d/value",KEY1_NUM);
	if ((fp = fopen(str, "rb")) != NULL) {
		key1 = 0;
		fread(buffer, sizeof(char), sizeof(buffer) - 1, fp);
		key1 = atoi(buffer);
		fclose(fp);
	}

	printf("<div id=\"key_content\">\n");
	printf("<form id=\"key_form\" action=\"cgi-bin/key.cgi\" method=\"GET\">\n");
	printf("<table width=\"300\" border=\"1\">\n");
	printf("<tr>\n");
	printf("<td>KEY1</td>\n");
	printf("</tr>\n");
	printf("<tr>\n");
	printf("<td>\n");
	
	if(!key1){
		printf("<input type=\"radio\" id=\"KEY1\" name=\"KEY1\" value=\"1\" checked>ON <br>\n");
		printf("<input type=\"radio\" id=\"KEY1\" name=\"KEY1\" value=\"0\">OFF\n");
	}
	else{
		printf("<input type=\"radio\" id=\"KEY1\" name=\"KEY1\" value=\"1\">ON <br>\n");
		printf("<input type=\"radio\" id=\"KEY1\" name=\"KEY1\" value=\"0\" checked>OFF\n");
	}

	printf("</td>\n");
	printf("</tr>\n");
	printf("</table>\n");
	printf("<br>\n");
	printf("</form>\n");
	printf("</div>");

	return 0;
}




