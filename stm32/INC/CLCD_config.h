/*
 *
 *<<<<<<<<<<<<<<<<<<<<<CLCD_CONFIG_H_>>>>>>>>>>>>>>>>>>>>>>>>
 * Author : ALIAA ESLAM ZAYED
 * Created: 10 SEP. 2024
 * Layer  : HAL
 * SWC    : CLCD
 *Version : V03  --- Updating for ARM
 */
 
 #ifndef CLCD_CONFIG_H_
 #define CLCD_CONFIG_H_
 
#define CLCD_DATA_PORT     DIOA   /**** We Can choose *GPIO_PORTA
														    *GPIO_PORTB*****/

#define CLCD_CONTROL_PORT  DIOB   /**** We Can choose *GPIO_PORTA
														    *GPIO_PORTB
														    *GPIO_PORTC*****/


#define CLCD_MODE   FOUR_BIT_MODE      /**** We Can choose *EIGHT_BIT_MODE
														    *FOUR_BIT_MODE *****/
#if CLCD_MODE == EIGHT_BIT_MODE
#define CLCD_DATA_PINS  {PIN0, PIN1, PIN2, PIN3, PIN4, PIN5, PIN6, PIN7}
#else
#define CLCD_DATA_PINS  {PIN4, PIN5, PIN6, PIN7}  // 4-bit mode uses only these pins
#endif

#define CLCD_RS_PIN  PIN7
#define CLCD_RW_PIN  PIN6
#define CLCD_EN_PIN  PIN5
 
 #endif
