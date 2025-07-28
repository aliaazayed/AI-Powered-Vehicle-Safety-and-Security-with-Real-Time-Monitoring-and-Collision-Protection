#include "../INC/STD_TYPES.h"
#include "../INC/BIT_MATH.h"
#include "../INC/Gpio.h"
#include "../INC/STK_interface.h"
#include "../INC/timer.h"
#include "../INC/HULTRA_interface.h"
#include "../INC/HULTRA_private.h"
#include "../INC/HULTRA_config.h"


void HULTRA_attachPin(uint8_t Copy_uint8_tTrigPort,uint8_t Copy_uint8_tTrigPIN,uint8_t Copy_uint8_tEcho)
{
	SetPinDirection(Copy_uint8_tTrigPort, Copy_uint8_tTrigPIN, OUTPUT_SPEED_2MHZ_PP) ;

	switch(Copy_uint8_tEcho)
	{
	case ULT_TIMER1_CH1_PORTA_8:
		SetPinDirection(DIOA,PIN8,INPUT_FLOATING);
		break;

	case ULT_TIMER1_CH2_PORTA_9:
		SetPinDirection(DIOA,PIN9,INPUT_FLOATING);
		break;

	case ULT_TIMER1_CH3_PORTA_10:
		SetPinDirection(DIOA,PIN10,INPUT_FLOATING);
		break;

	case ULT_TIMER1_CH4_PORTA_11:
		SetPinDirection(DIOA,PIN11,INPUT_FLOATING);
		break;


	case ULT_TIMER2_CH1_PORTA_0:
		SetPinDirection(DIOA,PIN0,INPUT_FLOATING);
		break;

	case ULT_TIMER2_CH2_PORTA_1:
		SetPinDirection(DIOA,PIN1,INPUT_FLOATING);
		break;

	case ULT_TIMER2_CH3_PORTA_2:
		SetPinDirection(DIOA,PIN2,INPUT_FLOATING);
		break;

	case ULT_TIMER2_CH4_PORTA_3:
		SetPinDirection(DIOA,PIN3,INPUT_FLOATING);
		break;

	case ULT_TIMER3_CH1_PORTA_6:
		SetPinDirection(DIOA,PIN6,INPUT_FLOATING);
		break;

	case ULT_TIMER3_CH2_PORTA_7:
		SetPinDirection(DIOA,PIN7,INPUT_FLOATING);
		break;

	case ULT_TIMER3_CH3_PORTB_0:
		SetPinDirection(DIOB,PIN0,INPUT_FLOATING);
		break;

	case ULT_TIMER3_CH4_PORTB_1:
		SetPinDirection(DIOB,PIN1,INPUT_FLOATING);
		break;
	}
	return;
}

void HULTRA_Trig(uint8_t Copy_uint8_tPort,uint8_t Copy_uint8_tPin)
{
	SetPinValue(Copy_uint8_tPort, Copy_uint8_tPin, DIO_LOW);
	STK_SetBusyWait(10*8000);
	SetPinValue(Copy_uint8_tPort, Copy_uint8_tPin, DIO_HIGH);
	STK_SetBusyWait(15*8000);
	SetPinValue(Copy_uint8_tPort, Copy_uint8_tPin, DIO_LOW);
	return;
}


uint16_t HULTRA_Distance(uint8_t timer, uint8_t Copy_uint8_tChannel)
{
	uint16_t time = 0;
	if(timer==1)
	time = MTIMER1_PWM_PulseIn(Copy_uint8_tChannel,38000);
	if(timer==2)
	time = MTIMER2_PWM_PulseIn(Copy_uint8_tChannel,38000);
	if(timer==3)
		time = MTIMER3_PWM_PulseIn(Copy_uint8_tChannel,38000);
	return (uint16_t)(0.034*(time/2));

}
