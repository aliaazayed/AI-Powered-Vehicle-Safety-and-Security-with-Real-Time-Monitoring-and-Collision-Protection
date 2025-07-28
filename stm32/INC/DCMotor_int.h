/******************************************DC_MOTOR_int.h*********************************
* Author : ALIAA ESLAM ZAYED                                                              *
* Created: 19 OCT. 2024                                                                   *
* Layer  : HAL                                                                            *
* Verion : V01                                                                            *
*******************************************************************************************/

 
#ifndef DC_MOTOR_INT_H_
#define DC_MOTOR_INT_H_


//########################################     APIs    ###########################################
/*
	Function Name        : HDC_voidInt
	Function Returns     : void
	Function Arguments   : void
	Function Description : intialize LCD
*/
void HDC_voidInt   (void) ;

/*
	Function Name        : HDC_voidRoCw
	Function Returns     : void
	Function Arguments   : void
	Function Description : rotate DC motor in counter wise
*/
void HDC_voidRoCw  (void) ;

/*
	Function Name        : HDC_voidRoCcw
	Function Returns     : void
	Function Arguments   : void
	Function Description : rotate DC motor in counter clock wise
*/
void HDC_voidRoCcw (void) ;

/*
	Function Name        : HDC_voidStop
	Function Returns     : void
	Function Arguments   : void
	Function Description : turn off DC motor
*/
void HDC_voidStop  (void) ;


#define DCMOTOR_CW		0
#define DCMOTOR_CCW		1
#define DCMOTOR_STOP	2

typedef struct
{
	uint8_t Copy_uint8_tDcMotorPort ;
	uint8_t Copy_uint8_tDcMotorPinA ;
	uint8_t Copy_uint8_tDcMotorPinB ;
} DCMOTOR_CONFIG ;

uint8_t DCMOTOR_uint8_tControl (DCMOTOR_CONFIG * DcMotor , uint8_t Copy_uint8_tState) ;


//CLk = 72MHz
//PWM_Freq = 20KHz
//-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-           PWM          *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
void Dc_Motor_PWM(uint8_t Copy_uint8_timer, uint8_t channel ,uint8_t Port, uint8_t pin , uint16_t duty );





#endif  /*DC_MOTOR_INT_H_*/
