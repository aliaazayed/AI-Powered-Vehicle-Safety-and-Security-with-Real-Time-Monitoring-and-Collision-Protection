/**
 ******************************************************************************
 * @file           : main.c
 * @author         : ALIAA ESLAM ZAYED
 * @brief          :  Turn off led after 3 sec Using IntervalSingle
 ******************************************************************************
 */

#include "STD_TYPES.h"
#include "BIT_MATH.h"

#include "RCC_interface.h"
#include "RCC_config.h"
#include "DIO_private.h"
#include "DIO_interface.h"
#include "STK_interface.h"
#include "LED_interface.h"

LED_CONFIG LED1={ LED_PORTA, LED_PIN0, OUTPUT_SPEED_2MZ_PP};
void App_voidTurnOff(void){
	HLED_voidLEDOff(LED1);

}
int main(void)
{
	/* Initialize clock system                  */
	MRCC_u8InitSystemClock();

	/*Enable RCC For (GPIOA) */
	MRCC_u8EnableClock(RCC_APB2,2);
	/*Enable RCC For (GPIOB) */
	MRCC_u8EnableClock(RCC_APB2,3);
	/*Enable RCC For (GPIOC) */
	MRCC_u8EnableClock(RCC_APB2,4);

	MSTK_u8Init();
	/*---------------------- LEDs -------------------------------*/
	HLED_voidLEDIntialization(LED1);
	/*-------- Turn off led after 3 sec --------------------*/
	HLED_voidLEDOn(LED1);
	MSTK_u8SetIntervalSingle(3000000, &App_voidTurnOff );
	//MSTK_u8SetIntervalPeriodic(1000000, &App_voidTurnOff );
	while(1){

	}

}
