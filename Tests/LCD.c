
#include "STD_TYPES.h"
#include "BIT_MATH.h"

#include "BaseAddress.h"
#include "stm32f103xx.h"

#include "RCC.h"
#include "Gpio.h"
#include "STK_interface.h"
#include "CLCD_interface.h"


#include "STK_config.h"

#include "HULTRA_interface.h"
#include "HULTRA_private.h"
#include "timer.h"

#define SAFE_DISTANCE 5


#define  ARM_DELAY(d)   do{unsigned long int i=(d * 2500); while(i--){asm("nop");}}while(0)



int main(void)
{

	InitSysClock(HSI,CLOCK_1X );
	STK_Init();
	//* Enable pinout of Timers (PortA , PORTB) from RCC
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOA );
	RCC_EnablePeripheralClock(APB2_BUS,APB2_DIOB );
	RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM2);
	RCC_EnablePeripheralClock(APB2_BUS, APB2_TIM1);
	RCC_EnablePeripheralClock(APB1_BUS, APB1_TIM3);

	CLCD_voidInitialization();
    CLCD_voidClearScreen();
    CLCD_voidSetPosition( CLCD_ROW_1, CLCD_COLUMN_2);

    ARM_DELAY(1000); // Wait for initialization

    // Test Case TC_CLCD_02
    CLCD_voidSendData('A');
    ARM_DELAY(50);

    // Test Case TC_CLCD_03
    CLCD_voidSendCommand(0x01); // Clear screen
    ARM_DELAY(50);

    // Test Case TC_CLCD_04
    CLCD_voidSendString((uint8_t*)"Hello");
    ARM_DELAY(100);

    // Test Case TC_CLCD_05
    CLCD_voidSetPosition(CLCD_ROW_2, CLCD_COLUMN_1);
    CLCD_voidSendData('B');
    ARM_DELAY(50);

    // Test Case TC_CLCD_06
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_10);
    CLCD_voidSendData('C');
    ARM_DELAY(500);

    // Test Case TC_CLCD_07
    CLCD_voidSendString((uint8_t*)"First String");
    ARM_DELAY(100);
    CLCD_voidClearScreen();
    ARM_DELAY(50);
    CLCD_voidSendString((uint8_t*)"Second String");
    ARM_DELAY(100);

    // Test Case TC_CLCD_08
    CLCD_voidClearScreen();
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_1);
    CLCD_voidSendString((uint8_t*)"Number: ");
    CLCD_voidSendNumber(12345);
    ARM_DELAY(100);

    // Test Case TC_CLCD_09
    CLCD_voidClearScreen();
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_1);
    CLCD_voidSendString((uint8_t*)"Negative: ");
    CLCD_voidSendNumber(-987);
    ARM_DELAY(100);

    // Test Case TC_CLCD_10
    CLCD_voidClearScreen();
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_1);
    CLCD_voidSendString((uint8_t*)"Float: ");
    CLCD_voidSendFloat(3.14);
    ARM_DELAY(100);

    // Test Case TC_CLCD_11
    CLCD_voidClearScreen();
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_1);
    CLCD_voidSendString((uint8_t*)"Negative Float: ");
    CLCD_voidSendFloat(-2.71);
    ARM_DELAY(100);

    // Test Case TC_CLCD_14
    CLCD_voidClearScreen();
    CLCD_voidSetPosition(CLCD_ROW_1, CLCD_COLUMN_1);
    CLCD_voidSendString((uint8_t*)"This is a long string for row 1");
    ARM_DELAY(200);
	for(;;){
		CLCD_voidSendString( (uint8_t *)"WARNING! ");
		CLCD_voidSendData('&');


	}
}




