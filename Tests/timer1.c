#include "STD_TYPES.h"
#include "BIT_MATH.h"
#include "stm32f103xx.h"
#include "Rcc.h"
#include "Gpio.h"
#include "Timer1.h"

#include "STK_interface.h"
#include "HULTRA_interface.h"
#include "HULTRA_config.h"


int main(void)
{
	/* initialization RCC */
	InitSysClock(HSI,CLOCK_1X );

	/* Enable pinout of Timers (PortA , PORTB) from RCC */
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOA );
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOB );
	RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM2);
	RCC_EnablePeripheralClock(APB2_BUS, APB2_TIM1);

	MTIMER1_init(PWM_channel_4_IN);

	SetPinDirection(DIOA, PIN1, OUTPUT_SPEED_2MHZ_PP);
	SetPinValue(DIOA, PIN1, DIO_LOW);
	HULTRA_attachPin(DIOA,PIN0,TIMER1_CH4_PORTA_11);

	/* Loop forever */
	for(;;){


			HULTRA_Trig(DIOA, PIN0);
			uint16_t value =HULTRA_Distance(TIMER1_CH4_PORTA_11);
		if(value>10){
			SetPinValue(DIOA, PIN1, DIO_HIGH);
			//MTIMER2_delay_ms(5000);

		}
		else{
		SetPinValue(DIOA, PIN1, DIO_LOW);
		//MTIMER2_delay_ms(5000);
		}
	}
}
