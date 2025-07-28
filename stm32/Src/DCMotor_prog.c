
/*
 *
 *<<<<<<<<<<<<<<<<<<<<<dcmotor.c>>>>>>>>>>>>>>>>>>>>>
 * Author : ALIAA ESLAM ZAYED
 * Created: 2 APRIL 2025
 * Layer  : HAL
 * SWC    : DC MOTOR
 *Version : V03  --- Updating for ARM
 */
#include "STD_TYPES.h"
#include "BIT_MATH.h"
#include "stm32f103xx.h"
#include "Rcc.h"
#include "timer.h"
#include "Gpio.h"

#include "dcmotor.h"


void MotorDriver_voidInit(void) {
    // Set pins as output for motor control (H-Bridge inputs)
    SetPinDirection(MOTOR1_PIN, OUTPUT_SPEED_2MHZ_PP);
    SetPinDirection(MOTOR2_PIN, OUTPUT_SPEED_2MHZ_PP);
    SetPinDirection(MOTOR3_PIN, OUTPUT_SPEED_2MHZ_PP);
    SetPinDirection(MOTOR4_PIN, OUTPUT_SPEED_2MHZ_PP);

    // Initialize PWM channels (for controlling motor speed)
    MTIMER3_init(PWM_channel_3);  // Initialize channel 1 for PWM (Motor 1)
   // MTIMER1_init(PWM_channel_4);  // Initialize channel 2 for PWM (Motor 2)
}

void MotorDriver_voidControlSpeed(uint8_t DutyCycle) {
    // Ensure DutyCycle is between 0 and 100
    if (DutyCycle > 100) {
        DutyCycle = 100;
    }

    // Calculate PWM value for duty cycle (0 to 1000 range)
    uint16_t pwm_value = (DutyCycle * 1000) / 100;  // Convert to 0-1000 range

    // Adjust duty cycle for channels 1 and 2 (Motor 1 and Motor 2)
    MTIMER3_PWM(TIMER3_CH3_PORTB_0, 999, pwm_value);  // Set duty cycle for Motor 1
 //   MTIMER1_PWM(TIMER1_CH4_PORTA_11, 999, pwm_value);  // Set duty cycle for Motor 2
}


void MotorDriver_voidStop(void)
{
	MotorDriver_voidControlSpeed(0);
	SetPinValue(MOTOR1_PIN, DIO_LOW);    // Motor 1
	SetPinValue(MOTOR2_PIN, DIO_LOW);  	// Motor 2
	SetPinValue(MOTOR3_PIN, DIO_LOW);    // Motor 3
	SetPinValue(MOTOR4_PIN, DIO_LOW);  	// Motor 4
}
void MotorDriver_voidMoveForward(void)
{
	SetPinValue(MOTOR1_PIN, DIO_HIGH);    // Motor 1
	SetPinValue(MOTOR2_PIN, DIO_LOW);  	// Motor 2
	SetPinValue(MOTOR3_PIN, DIO_HIGH);    // Motor 3
	SetPinValue(MOTOR4_PIN, DIO_LOW);  	// Motor 4
}

void MotorDriver_voidMoveBackward(void)
{
	SetPinValue(MOTOR1_PIN, DIO_LOW);   	// Motor 1
	SetPinValue(MOTOR2_PIN, DIO_HIGH);     // Motor 2
	SetPinValue(MOTOR3_PIN, DIO_LOW);   	// Motor 3
	SetPinValue(MOTOR4_PIN, DIO_HIGH);     // Motor 4
}

void MotorDriver_voidMoveRight(void)
{
	SetPinValue(MOTOR1_PIN, DIO_LOW);   // Motor 1
	SetPinValue(MOTOR2_PIN, DIO_HIGH);   // Motor 2
	SetPinValue(MOTOR3_PIN, DIO_HIGH);     // Motor 3
	SetPinValue(MOTOR4_PIN, DIO_LOW);   // Motor 4
}

void MotorDriver_voidMoveLeft(void)
{
	SetPinValue(MOTOR1_PIN, DIO_HIGH);      // Motor 1
	SetPinValue(MOTOR2_PIN, DIO_LOW);  	 // Motor 2
	SetPinValue(MOTOR3_PIN, DIO_LOW);   	// Motor 3
	SetPinValue(MOTOR4_PIN, DIO_HIGH);   // Motor 4
}
