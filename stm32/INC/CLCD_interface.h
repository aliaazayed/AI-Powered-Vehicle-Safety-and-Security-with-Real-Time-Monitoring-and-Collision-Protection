/*
 *
 *<<<<<<<<<<<<<<<<<<<<<CLCD_INTERFACE_H_>>>>>>>>>>>>>>>>>>>>>>>>
 * Author : ALIAA ESLAM ZAYED
 * Created: 10 SEP. 2024
 * Layer  : HAL
 * SWC    : CLCD
 *Version : V03  --- Updating for ARM
 */
 #ifndef CLCD_INTERFACE_H_
 #define CLCD_INTERFACE_H_

 


 /****** CLCD_ROWs ********/
 #define CLCD_ROW_1        1
 #define CLCD_ROW_2        2
 
 /*******CLCD_COLUMNs******/
typedef enum {
    CLCD_COLUMN_1 = 1,
    CLCD_COLUMN_2,
    CLCD_COLUMN_3,
    CLCD_COLUMN_4,
    CLCD_COLUMN_5,
    CLCD_COLUMN_6,
    CLCD_COLUMN_7,
    CLCD_COLUMN_8,
    CLCD_COLUMN_9,
    CLCD_COLUMN_10,
    CLCD_COLUMN_11,
    CLCD_COLUMN_12,
    CLCD_COLUMN_13,
    CLCD_COLUMN_14,
    CLCD_COLUMN_15,
    CLCD_COLUMN_16
} CLCD_COLUMN_t;


/********CLCD_MODES*********/
#define EIGHT_BIT_MODE     8
#define FOUR_BIT_MODE      4
 /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Functions>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/

/**
	Function Name        : CLCD_voidInitialization
	Function Returns     : void
	Function Arguments   : void
	Function Description : Intialize the LCD and the port as an output
*/
 void CLCD_voidInitialization(void);
 
 /**
	Function Name        : CLCD_voidSendData
	Function Returns     : void
	Function Arguments   : copy_uint8_tData
	Function Description : Send a data to LCD 
*/
 void CLCD_voidSendData( uint8_t copy_uint8_tData);
 
  /**
	Function Name        : CLCD_voidSendCommand
	Function Returns     : void
	Function Arguments   : copy_uint8_tCommand
	Function Description : Send a Command to LCD 
*/
 void CLCD_voidSendCommand( uint8_t copy_uint8_tCommand);
 
  /**
	Function Name        : CLCD_voidClearScreen
	Function Returns     : void
	Function Arguments   : void
	Function Description : Clear the  LCD 
*/
 void CLCD_voidClearScreen(void);
 
/**
	Function Name        : CLCD_voidSendString
	Function Returns     : void
	Function Arguments   : copy_uint8_tPtrString
	Function Description : Display an array of string on the LCD
*/
 void CLCD_voidSendString( uint8_t* copy_uint8_tptrString);
 
 /**
	Function Name        : CLCD_voidSetPosition
	Function Returns     : void
	Function Arguments   : copy_uint8_tRow,  copy_uint8_tColumn
	Function Description : Set The cursor on the specific position on the LCD
*/ 
 void CLCD_voidSetPosition ( uint8_t copy_uint8_tRow, CLCD_COLUMN_t copy_uint8_tColumn);
 
/**
	Function Name        : CLCD_voidSetExtraChar
	Function Returns     : void
	Function Arguments   : copy_uint8_tRow,  copy_uint8_tColumn
	Function Description : send a data on any char don't hava an ASCII code
*/ 
 void CLCD_voidSetExtraChar( uint8_t copy_uint8_tRow, uint8_t copy_uint8_tColumn);
 
 
 void CLCD_voidSendNumber(s32 cpy_u32Number) ;
 
 void CLCD_voidSendFloat(f64 cpy_f64Float) ;
 void CLCD_voidSendFallingEdge (void);
 #endif
