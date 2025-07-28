/////*
//// * stm32_f103c6_gpio_driver.c
//// *
//// *  Created on: Apr 29, 2025
//// *      Author: Aya Ramadan
//// */
////

#include "../INC/USART_driver.h"

UART_Config* Global_UART_Config  = NULL ;

/*
 * =======================================================================================
 * 							Generic Macros
 * =======================================================================================
 */


/*
 * =======================================================================================
 * 							Generic Functions
 * =======================================================================================
 */

/**================================================================
 * @Fn				-MCAL_UART_Init
 * @brief 			- Initializes UART (Supported feature ASYNCH. Only)
 * @param [in] 		- USARTx: where x can be (1..3 depending on device used)
 * @param [in] 		- UART_Config: All UART Configuration EXTI_PinConfig_t
 * @retval 			-none
 * Note				-Support for Now Asynch mode & Clock 8 MHZ S
 */
void MCAL_UART_Init (struct UsartRegDef* USARTx, UART_Config* UART_Config)
{
	Global_UART_Config = UART_Config ;
	uint32_t pclk ,BRR  ;
	//	enable the Clock for given USART peripheral

	if ( USARTx == USART1REG )
		RCC_EnablePeripheralClock( APB2_BUS, APB2_USART1);

	else if ( USARTx == USART2REG )
		RCC_EnablePeripheralClock( APB1_BUS, APB1_USART2);

	else if ( USARTx == USART3REG )
		RCC_EnablePeripheralClock( APB1_BUS, APB1_USART3);



	//Enable USART Module
	//	USART_CR1  Bit 13 UE: USART enable
	USARTx->CR1.bits.UE = 1;

	//Enable USART Tx and Rx engines according to the USART_Mode configuration item
	//	USART_CR1 Bit 3 TE: Transmitter enable & Bit 2 RE: Receiver enable
	USARTx->CR1.registerVal |= UART_Config->USART_Mode ;
	//PAYLOAD Width
	// USARTx->CR1  Bit 12 M: Word length
	USARTx->CR1.registerVal |= UART_Config->Payload_Length ;

	//Configuration of parity control bit fields
	// USARTx->CR1 	Bit 10 PCE: Parity control enable     Bit 9 PS: Parity selection
	USARTx->CR1.registerVal |= UART_Config->Parity ;

	//configure the number of stop bits
	//USART_CR2  Bits 13:12 STOP: STOP bits
	USARTx->CR2.registerVal |= UART_Config->StopBits ;


	//USART hardware flow control
	//USART_CR3  Bit 9 CTSE: CTS enable   Bit 8 RTSE: RTS enable
	USARTx->CR3.registerVal |= UART_Config->HwFlowCtl ;


	//Configuration of BRR(Baudrate register)
	//PCLK1 for USART2, 3
	//PCLK2 for USART1
	if ( USARTx == USART1REG )
	{
		pclk = MCAL_RCC_GetPCLK2Freq();
	}
	else
	{
		pclk = MCAL_RCC_GetPCLK1Freq();
	}

	BRR = UART_BRR_Register(pclk, UART_Config->BaudRate) ;

	USARTx->BRR.registerVal = BRR ;


	// ENABLE / DISABLE Interrupt
	//USART_CR1
	if (UART_Config->IRQ_Enable  != UART_IRQ_Enable_NONE)
	{
		USARTx->CR1.registerVal |= (UART_Config->IRQ_Enable) ;
		//		Enable NVIC For USARTx IRQ
		if ( USARTx == USART1REG )
			NVIC_IRQ37_USART1_Enable ;

		else if ( USARTx == USART2REG )
			NVIC_IRQ38_USART2_Enable ;

		else if ( USARTx == USART3REG )
			NVIC_IRQ39_USART3_Enable ;
	}

}
/**================================================================
 * @Fn				-MCAL_UART_DEInit
 * @brief 			- DEInitializes UART (Supported feature ASYNCH. Only)
 * @param [in] 		- USARTx: where x can be (1..3 depending on device used)
 * @retval 			-none
 * Note				-Reset the Model By RCC
 */
void MCAL_UART_DeInit (struct UsartRegDef* USARTx)
{
	if ( USARTx == USART1REG )
	{
		RCC_USART1_CLK_Reset();
		NVIC_IRQ37_USART1_Disable ;

	}

	else if ( USARTx == USART2REG )
	{
		RCC_USART2_CLK_Reset();
		NVIC_IRQ38_USART2_Disable ;


	}

	else if ( USARTx == USART3REG )
	{
		RCC_USART3_CLK_Reset();
		NVIC_IRQ39_USART3_Disable ;

	}


}





/*********************************************************************
 * @fn      		  - MCAL_UART_SendData
 *
 * @brief             -Send Buffer on UART
 *
 * @param [in] 		- USARTx: where x can be (1..3 depending on device used)
 * @param[in]         -pTxBuffer Buffer
 * @param[in]         -PollingEn   Enable pooling or dsable it
 *
 * @return            -

 * @Note              - Should initialize UART First
 * 		//			When transmitting with the parity enabled (PCE bit set to 1 in the USART_CR1 register),
			//			the value written in the MSB (bit 7 or bit 8 depending on the data length) has no effect
			//			because it is replaced by the parity.
			//			When receiving with the parity enabled, the value read in the MSB bit is the received parity
			//			bit

 */

void MCAL_UART_SendData	(struct UsartRegDef* USARTx, uint8_t *pTxBuffer,enum Polling_mechism PollingEn )
{


	// wait until TXE flag is set in the SR
	if (PollingEn == enable)
		while(! (USARTx->SR.registerVal & 1<<7 ) );

	//Check the USART_WordLength item for 9BIT or 8BIT in a frame
	if (Global_UART_Config->Payload_Length == UART_Payload_Length_9B)
	{
		//if 9BIT, load the DR with 2bytes masking the bits other than first 9 bits

		//			When transmitting with the parity enabled (PCE bit set to 1 in the USART_CR1 register),
		//			the value written in the MSB (bit 7 or bit 8 depending on the data length) has no effect
		//			because it is replaced by the parity.
		//			When receiving with the parity enabled, the value read in the MSB bit is the received parity
		//			bit.
		//
		USARTx->DR = (*pTxBuffer & (uint16_t)0x01FF);

	}else
	{
		//This is 8bit data transfer
		USARTx->DR = (*pTxBuffer  & (uint8_t)0xFF);
	}




}



void MCAL_UART_WAIT_TC (struct UsartRegDef* USARTx )
{
	// wait till TC flag is set in the SR
	while( ! (USARTx->SR.registerVal & 1<<6 ));
}



void MCAL_UART_ReceiveData	(struct UsartRegDef* USARTx, uint8_t *pRxBuffer ,enum Polling_mechism PollingEn )
{
	//Loop over until "Len" number of bytes are transferred
	//wait until RXNE flag is set in the SR
	if (PollingEn == enable)
	{
		while( ! (USARTx->SR.registerVal & 1<<5 ));
	}


	//Check the USART_WordLength item for 9BIT or 8BIT in a frame
	if (Global_UART_Config->Payload_Length == UART_Payload_Length_9B)
	{
		if (Global_UART_Config->Parity ==UART_Parity__NONE)
		{
			//no parity So all 9bit are considered data
			*((uint8_t*) pRxBuffer) = USARTx->DR ;

		}else
		{
			//Parity is used, so, 8bits will be of user data and 1 bit is parity
			*((uint8_t*) pRxBuffer) = ( USARTx->DR  & (uint8_t)0xFF );

		}

	}else
	{
		//This is 8bit data
		if (Global_UART_Config->Parity ==UART_Parity__NONE)
		{
			//no parity So all 8bit are considered data
			//*((uint8_t*) pRxBuffer) = ( USARTx->DR  & (uint8_t)0xFF ) ;
			* pRxBuffer =  USARTx->DR & (uint8_t)0xFF ;

		}else
		{
			//Parity is used, so,7 bits will be of user data and 1 bit is parity
			*((uint8_t*) pRxBuffer) = ( USARTx->DR  & (uint8_t)0X7F );

		}
	}


}



/**================================================================
 * @Fn				-MCAL_UART_GPIO_Set_Pins
 * @brief 			- intialize GPIO Pins
 * @param [in] 		- USARTx: where x can be (1..3 depending on device used)
 * @retval 			-none
 * Note				-Should enable the corresponding ALT  & GPIO  in RCC clock Also called after MCAL_UART_Init()
 */
void MCAL_UART_GPIO_Set_Pins (struct UsartRegDef* USARTx)
{
	if(USARTx == USART1REG )
	{
		//PA9 TX
		//PA10 RX
		//PA11 CTS
		//PA12 RTS
		// Output modes - 10MHz
		//TX
		SetPinDirection(DIOA, PIN9, OUTPUT_SPEED_10MHZ_AFPP);

		//RX
		SetPinDirection(DIOA, PIN10, INPUT_FLOATING );


		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_CTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//CTS
			SetPinDirection(DIOA, PIN11, INPUT_FLOATING );
		}
		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//RTS
			SetPinDirection(DIOA, PIN12, OUTPUT_SPEED_10MHZ_AFPP );
		}
	}
	else if(USARTx == USART2REG )
	{
		//PA2 TX
		//PA3 RX
		//PA0 CTS
		//PA1 RTS

		//TX
		SetPinDirection(DIOA, PIN2, OUTPUT_SPEED_10MHZ_AFPP);
		//RX
		SetPinDirection(DIOA, PIN3, INPUT_FLOATING );

		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_CTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//CTS
			SetPinDirection(DIOA, PIN0, INPUT_FLOATING );
		}
		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//RTS
			SetPinDirection(DIOA, PIN1, OUTPUT_SPEED_10MHZ_AFPP );
		}
	}
	else if(USARTx == USART3REG )
	{
		//PB10 TX
		//PB11 RX
		//PB13 CTS
		//PB14 RTS

		//TX
		SetPinDirection(DIOB, PIN10, OUTPUT_SPEED_10MHZ_AFPP);

		//RX
		SetPinDirection(DIOB, PIN11, INPUT_FLOATING );


		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_CTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//CTS
			SetPinDirection(DIOB, PIN13, INPUT_FLOATING );
		}
		if(Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS || Global_UART_Config->HwFlowCtl == UART_HwFlowCtl_RTS_CTS)
		{
			//RTS
			SetPinDirection(DIOA, PIN14, OUTPUT_SPEED_10MHZ_AFPP );
		}
	}
}




//ISR
void USART1_IRQHandler (void)
{
	Global_UART_Config->P_IRQ_CallBack () ;
}

void USART2_IRQHandler (void)
{
	Global_UART_Config->P_IRQ_CallBack () ;

}
void USART3_IRQHandler (void)
{
	Global_UART_Config->P_IRQ_CallBack () ;


}
