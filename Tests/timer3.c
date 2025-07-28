#include "STD_TYPES.h"
#include "BIT_MATH.h"
#include "stm32f103xx.h"
#include "Rcc.h"
#include "Gpio.h"
#include "TIMER2_interface.h"
#include "TIMER3_interface.h"
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
	 RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM3);
	//MTIMER3_init(PWM_channel_1_IN);
	//MTIMER3_init(PWM_channel_2_IN);
	//MTIMER3_init(PWM_channel_3_IN);
	SetPinDirection(DIOA, PIN1, OUTPUT_SPEED_2MHZ_PP);
	SetPinValue(DIOA, PIN1, DIO_LOW);
	//HULTRA_attachPin(DIOA,PIN0,TIMER3_CH1_PORTA_6);
	//HULTRA_attachPin(DIOA,PIN1,TIMER3_CH2_PORTA_7);
	//HULTRA_attachPin(DIOA,PIN2,TIMER3_CH3_PORTB_0);


	/* Loop forever */
	for(;;){

	MTIMER3_init(PWM_channel_1_IN);
		HULTRA_attachPin(DIOA,PIN0,TIMER3_CH1_PORTA_6);
			HULTRA_Trig(DIOA, PIN0);
			uint16_t value =HULTRA_Distance(TIMER3_CH1_PORTA_6);
			void disable();
			MTIMER3_init(PWM_channel_2_IN);
			HULTRA_attachPin(DIOA,PIN1,TIMER3_CH2_PORTA_7);
			HULTRA_Trig(DIOA, PIN1);
			uint16_t value1 =HULTRA_Distance(TIMER3_CH2_PORTA_7);
			void disable();
			MTIMER3_init(PWM_channel_3_IN);
			HULTRA_attachPin(DIOA,PIN2,TIMER3_CH3_PORTB_0);
			HULTRA_Trig(DIOA, PIN2);
			uint16_t value2 =HULTRA_Distance(TIMER3_CH3_PORTB_0);
		if(value>10){
			SetPinValue(DIOA, PIN1, DIO_HIGH);


		}
		else{
		SetPinValue(DIOA, PIN1, DIO_LOW);
		//MTIMER2_delay_ms(5000);
		}
	}
}
