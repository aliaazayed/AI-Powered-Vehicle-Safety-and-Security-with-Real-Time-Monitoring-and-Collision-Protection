#include "INC/STD_TYPES.h"
#include "INC/BIT_MATH.h"
#include "INC/stm32f103xx.h"
#include "INC/Rcc.h"
#include "INC/Gpio.h"
#include "INC/timer.h"

#include "INC/STK_interface.h"
#include "INC/HULTRA_interface.h"
#include "INC/HULTRA_config.h"


#include "INC/CLCD_interface.h"
#include "INC/CLCD_config.h"


int main(void)
{
	/* initialization RCC */
	InitSysClock(HSI,CLOCK_1X );

	/* Enable pinout of Timers (PortA , PORTB) from RCC */
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOA );
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOB );
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOC );
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOD);

	RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM2);
	RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM3);




	/*------------------------ LCD -----------------------------*/

	//CLCD_Initialization(&lcd_config);
	//		    CLCD_SendString(&lcd_config, "HelloWorld!");
	//		    CLCD_SendData(&lcd_config,'z');
	 MTIMER2_init(PWM_channel_1_us);
	  SetPinDirection(DIOA, PIN2, OUTPUT_SPEED_50MHZ_AFPP);

	


}

