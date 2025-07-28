/*
 * NVIC.h
 *
 *  Created on: May 10, 2025
 *      Author: QUADRO
 */

#ifndef NVIC_H_
#define NVIC_H_
#include "BaseAddress.h"
#include "stm32f103xx.h"


/*USART*/
#define USART1_IRQ     37
#define USART2_IRQ     38
#define USART3_IRQ     39

/*USART*/
// Enable
#define NVIC_IRQ37_USART1_Enable   (NVICREG->ISER[1] |= 1<<(USART1_IRQ - 32 ))
#define NVIC_IRQ38_USART2_Enable   (NVICREG->ISER[1] |= 1<<(USART2_IRQ - 32 ))
#define NVIC_IRQ39_USART3_Enable   (NVICREG->ISER[1] |= 1<<(USART3_IRQ - 32 ))

// Disable
#define NVIC_IRQ37_USART1_Disable   (NVICREG->ICER[1] |= 1<<(USART1_IRQ - 32 ))
#define NVIC_IRQ38_USART2_Disable   (NVICREG->ICER[1] |= 1<<(USART2_IRQ - 32 ))
#define NVIC_IRQ39_USART3_Disable   (NVICREG->ICER[1] |= 1<<(USART3_IRQ - 32 ))



#endif /* NVIC_H_ */
