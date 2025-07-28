/**
 ******************************************************************************
 * @file           : main.c
 * @author         : Aya Ramadan
 * @brief          : Main program body
 ******************************************************************************
 */


#include"stm32f103xx.h"
#include"Gpio.h"
#include "timer.h"
#include "stm32_f103c6_USART_driver.h"
#include "servo.h"

/* Define States */
#define DOOR_UNLOCK      ( 0xfd )
#define DOOR_LOCK        ( 0xfa )
#define Trunk_UNLOCK     ( 0xfe )
#define Trunk_LOCK       ( 0xfc )

/* Variable to Save Received data in it*/
volatile uint8_t  Received_char ;

void UART_IRQ_callback(void)
{
	Received_char = '\0';
	/* Get Received Data */
	MCAL_UART_ReceiveData(USART1REG, &Received_char ,disable );

	/* Door Action */
	if( Received_char == DOOR_UNLOCK )
	{
		set_servo_angle_timer1(4, 90);
	}
	else if(Received_char == DOOR_LOCK)
	{
		set_servo_angle_timer1(4, 0);
	}

	/*Trunk Action */
	if(Received_char == Trunk_UNLOCK )
	{
		set_servo_angle_timer1(4, 90);
	}
	else if(Received_char == Trunk_LOCK)
	{
		set_servo_angle_timer1(4, 0);
	}

}

void main(void)
{
	/*Initialization System CLK and Enable it for needing module */
	InitSysClock( HSI , CLOCK_1X);
	RCC_EnablePeripheralClock(APB2_BUS, APB2_DIOA);
	RCC_EnablePeripheralClock(APB2_BUS, APB2_DIOB);
	RCC_EnablePeripheralClock(APB2_BUS, APB2_AFIO);

	/* Assign configuration for UART */
	UART_Config uartcfg;
	uartcfg.BaudRate = UART_BaudRate_115200;
	uartcfg.HwFlowCtl= UART_HwFlowCtl_NONE;
	uartcfg.IRQ_Enable =UART_IRQ_Enable_RXNEIE;
	uartcfg.P_IRQ_CallBack= &UART_IRQ_callback;
	uartcfg.Parity = UART_Parity__NONE;
	uartcfg.Payload_Length =UART_Payload_Length_8B;
	uartcfg.StopBits =UART_StopBits__1;
	uartcfg.USART_Mode=UART_MODE_RX;

	/*Set RX, TX for UART */
	MCAL_UART_GPIO_Set_Pins(USART1REG);

	/* Initialize Timer1 channel 4 For Servo */
	MTIMER1_init(SPWM_channel_4);

	/* Initialize UART To Receive Data */
	MCAL_UART_Init(USART1REG, &uartcfg);


	while(1)
	{

	}

}


