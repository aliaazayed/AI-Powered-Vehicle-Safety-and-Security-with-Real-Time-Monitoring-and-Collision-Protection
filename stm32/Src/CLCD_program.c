
#include "STD_TYPES.h"
#include "BIT_MATH.h"

#include "Gpio.h"

#include "STK_interface.h"
#include "CLCD_interface.h"
#include "CLCD_private.h"
#include "CLCD_config.h"


#define  ARM_DELAY(d)   do{unsigned long int i=(d * 2500); while(i--){asm("nop");}}while(0)

void CLCD_voidInitialization(void)
{
	//ARM_DELAY (250) ;
	STK_SetBusyWait(250*8000);
uint8_t data_pins[] = CLCD_DATA_PINS;  // Use configuration-defined data pins

    // Set Data Pins as Output
    for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
    {
        SetPinDirection(CLCD_DATA_PORT, data_pins[i], OUTPUT_SPEED_2MHZ_PP);
    }
	SetPinDirection( CLCD_CONTROL_PORT, CLCD_RS_PIN,OUTPUT_SPEED_2MHZ_PP);
	SetPinDirection( CLCD_CONTROL_PORT, CLCD_RW_PIN,OUTPUT_SPEED_2MHZ_PP);
	SetPinDirection( CLCD_CONTROL_PORT, CLCD_EN_PIN,OUTPUT_SPEED_2MHZ_PP);
#if CLCD_MODE ==EIGHT_BIT_MODE
	CLCD_voidSendCommand(FUNCTION_SET_TWO_LINE);
	//ARM_DELAY (2) ;
	STK_SetBusyWait(2*8000);
	CLCD_voidSendCommand(LCD_DISPLAY_ON_CURSOR_ON_BLINK_OFF  );
	//ARM_DELAY (2) ;
	STK_SetBusyWait(2*8000);
	CLCD_voidClearScreen();
	//ARM_DELAY(15) ;
	STK_SetBusyWait(15*8000);
	CLCD_voidSendCommand(LCD_ENTRY_MODE);
	//	ARM_DELAY (2) ;
	STK_SetBusyWait(2*8000);
#elif CLCD_MODE == FOUR_BIT_MODE

	    CLCD_voidSendCommand(0x33); // Initialize sequence
	    ARM_DELAY(5);
	    CLCD_voidSendCommand(0x32); // Set to 4-bit mode
	    ARM_DELAY(5);
	    CLCD_voidSendCommand(FUNCTION_SET_FOUR_BIT);
	    ARM_DELAY(5);
	    CLCD_voidSendCommand(LCD_DISPLAY_ON_CURSOR_OFF_BLINK_OFF);
	    ARM_DELAY(5);
	    CLCD_voidClearScreen();
	    ARM_DELAY(15);
	    CLCD_voidSendCommand(LCD_ENTRY_MODE_SHIFT_LEFT);
	    ARM_DELAY(5);
	    #endif

}

void CLCD_voidSendData( uint8_t copy_uint8_tData)
{uint8_t data_pins[] = CLCD_DATA_PINS;

#if CLCD_MODE == EIGHT_BIT_MODE
	for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
	{
	   SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tData, i));
	}

	SetPinValue(CLCD_CONTROL_PORT,CLCD_RS_PIN,DIO_HIGH);
	SetPinValue(CLCD_CONTROL_PORT,CLCD_RW_PIN,DIO_LOW);
	CLCD_voidSendFallingEdge ();
#elif CLCD_MODE == FOUR_BIT_MODE
    SetPinValue(CLCD_CONTROL_PORT, CLCD_RS_PIN, DIO_HIGH);
    SetPinValue(CLCD_CONTROL_PORT, CLCD_RW_PIN, DIO_LOW);
    for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
     {
     	SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tData, (i+4)));
     }
    CLCD_voidSendFallingEdge();
    for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
     {
     	SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tData, i));
     }
    CLCD_voidSendFallingEdge();

    ARM_DELAY(5);

#endif
}

void CLCD_voidSendCommand( uint8_t copy_uint8_tCommand)
{uint8_t data_pins[] = CLCD_DATA_PINS;
#if CLCD_MODE == EIGHT_BIT_MODE
	   for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
	    {
	    	SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tCommand, i));
	    }


	SetPinValue(CLCD_CONTROL_PORT,CLCD_RS_PIN,DIO_LOW);
	SetPinValue(CLCD_CONTROL_PORT,CLCD_RW_PIN,DIO_LOW);
	CLCD_voidSendFallingEdge ();
#elif CLCD_MODE == FOUR_BIT_MODE
	SetPinValue(CLCD_CONTROL_PORT, CLCD_RS_PIN, DIO_LOW);
	    SetPinValue(CLCD_CONTROL_PORT, CLCD_RW_PIN, DIO_LOW);
	    for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
	     {
	     	SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tCommand,( i+4)));
	     }
	    CLCD_voidSendFallingEdge();

	    for (uint8_t i = 0; i < (sizeof(data_pins) / sizeof(data_pins[0])); i++)
	     {
	     	SetPinValue(CLCD_DATA_PORT, data_pins[i], GET_BIT(copy_uint8_tCommand, i));
	     }
	    CLCD_voidSendFallingEdge();

	    ARM_DELAY(5);
#endif
}
void CLCD_voidClearScreen(void)
{
	CLCD_voidSendCommand( LCD_DISPLAY_CLEAR);
}
void CLCD_voidSendString( uint8_t* copy_uint8_tptrString)
{
	uint8_t LOC_uint8_tItrator=0;
	while(copy_uint8_tptrString[ LOC_uint8_tItrator] != '\0')
	{
		CLCD_voidSendData(copy_uint8_tptrString[ LOC_uint8_tItrator]);
		LOC_uint8_tItrator++;
	}
}

void CLCD_voidSetPosition ( uint8_t copy_uint8_tRow, CLCD_COLUMN_t copy_uint8_tColumn)
{
	uint8_t LOC_uint8_tData;
	if( (copy_uint8_tRow>2)||(copy_uint8_tRow<1) ||(copy_uint8_tColumn>16)||(copy_uint8_tColumn<1))
	{
		LOC_uint8_tData=LCD_SET_CURSOR_FIRST_LINE;
	}
	else if(copy_uint8_tRow==CLCD_ROW_1)
	{
		LOC_uint8_tData=LCD_SET_CURSOR_FIRST_LINE+(copy_uint8_tColumn-1);
	}
	else if(copy_uint8_tRow==CLCD_ROW_2)
	{
		LOC_uint8_tData=LCD_SET_CURSOR_SECOND_LINE +(copy_uint8_tColumn-1);
	}
	CLCD_voidSendCommand(LOC_uint8_tData);
	//STK_SetBusyWait(10000);
}


void CLCD_voidSendFallingEdge (void)
{
	SetPinValue(CLCD_CONTROL_PORT, CLCD_EN_PIN, DIO_HIGH);
	    ARM_DELAY(2);
	    SetPinValue(CLCD_CONTROL_PORT, CLCD_EN_PIN, DIO_LOW);
	    ARM_DELAY(2);
}



void CLCD_voidSendNumber(s32 cpy_u32Number) //123
{      uint32_t cpy_u32power=1;
s32 cpy_u32num=cpy_u32Number;
if(cpy_u32Number==0)
{
	CLCD_voidSendData('0');
	return;
}
if(cpy_u32Number<0)
{

	cpy_u32Number=cpy_u32Number*(-1);
	CLCD_voidSendData('-');
}
while(cpy_u32num)
{//01234

	cpy_u32num=cpy_u32num/10;          //01234  0123  012   01   0 0
	cpy_u32power=cpy_u32power*10;      //10000
}
cpy_u32power=cpy_u32power/10;
while(cpy_u32power>0)
{
	cpy_u32num=cpy_u32Number/cpy_u32power;  //01234/1000=0
	cpy_u32Number%=cpy_u32power;
	cpy_u32power/=10;

	CLCD_voidSendData(cpy_u32num+'0');
}




}

void CLCD_voidSendFloat(f64 cpy_f64Float)
{
	uint32_t cpy_u32power=1;
	s32 cpy_u32num=cpy_f64Float;
	s32 i=0;

	if(cpy_f64Float==0)
	{
		CLCD_voidSendData('0');
		return;
	}
	if(cpy_f64Float<0)
	{

		cpy_f64Float=cpy_f64Float*(-1);
		CLCD_voidSendData('-');
	}
	while(cpy_u32num)//1234
	{

		cpy_u32num=cpy_u32num/10;
		i++;//4
		cpy_u32power=cpy_u32power*10;      //10000
	}
	s32 int_num=cpy_f64Float*10000;  //1234.1234-->12341234
	cpy_u32power=cpy_u32power*1000;
	while(cpy_u32power>0)
	{
		cpy_u32num=int_num/cpy_u32power;  //01234/1000=0
		int_num%=cpy_u32power;
		cpy_u32power/=10;
		if(i==0)
		{
			CLCD_voidSendData('.');

		}
		i--;
		CLCD_voidSendData(cpy_u32num+'0');
	}
