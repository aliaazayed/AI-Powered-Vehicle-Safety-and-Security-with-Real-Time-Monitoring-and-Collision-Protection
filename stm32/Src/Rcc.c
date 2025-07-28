/**
 * @file RCC.c
 * @author
 * @brief
 * @version 0.1
 * @date 2024-03-8
 *
 * @copyright Copyright (c) 2024
 */

#include "../INC/stm32f103xx.h"
#include "../INC/Rcc.h"
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//     Generic Variable
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


// PPRE1: APB low-speed prescaler (APB1)
//Set and cleared by software to control the division factor of the APB low-speed clock
//(PCLK1).
//Warning: the software has to set correctly these bits to not exceed 36 MHz on this domain.
//0xx: HCLK not divided
//100: HCLK divided by 2
//101: HCLK divided by 4
//110: HCLK divided by 8
//111: HCLK divided by 16

const uint8_t APBPrescTable [8U]={0,0,0,0,1,2,3,4};

//HPRE: AHB prescaler
//Set and cleared by software to control the division factor of the AHB clock.
//0xxx: SYSCLK not divided
//1000: SYSCLK divided by 2
//1001: SYSCLK divided by 4
//1010: SYSCLK divided by 8
//1011: SYSCLK divided by 16
//1100: SYSCLK divided by 64
//1101: SYSCLK divided by 128
//1110: SYSCLK divided by 256
//1111: SYSCLK divided by 512

const uint8_t AHBPrescTable [16U]={0,0,0,0,0,0,0,0,1,2,3,4,6,7,8,9};



// Function to initialize system clock
void InitSysClock(ClkConfig config, PLL_MulFactor mulFactor) {
    if (config == HSI && mulFactor == CLOCK_1X) {
        HelperSetInternalHighSpeedClk();
        return;
    }
    if (config == HSE && mulFactor == CLOCK_1X) {
    	HelperSetExternalHighSpeedClk();
        return;
    }

    // Disable PLL before configuring
    RCCREG->CR.bits.PLLON = 0;
    HelperSetPllFactor(mulFactor);
    HelperSetPllSource(config);

    // Enable PLL after configuration
    RCCREG->CR.bits.PLLON = 1;
  for (int i=0;i<RCC_TIMEOUT;i++){ __asm volatile ("nop"); }
    RCCREG->CFGR.bits.SW = 2;  // Switch to PLL
}

void SetAHBPrescaler(AHP_ClockDivider divFactor) {
    RCCREG->CFGR.bits.HPRE = divFactor;
}

void SetAPB1Prescaler(APB_ClockDivider divFactor) {
    RCCREG->CFGR.bits.PPRE1 = divFactor;
}

void SetAPB2Prescaler(APB_ClockDivider divFactor) {

    RCCREG->CFGR.bits.PPRE2 = divFactor;
}

void SetMCOPinClk(McoModes mode) {
    RCCREG->CFGR.bits.MCO = mode;
}

void AdjustInternalClock(uint8_t CalibrationValue) {
    RCCREG->CR.bits.HSITRIM = CalibrationValue;
}

void HelperSetInternalHighSpeedClk(void) {
    RCCREG->CR.bits.HSION = 1;
    //WaitToReady(kHSIRDY);
    for (int i=0;i<RCC_TIMEOUT;i++){ __asm volatile ("nop"); }
    RCCREG->CFGR.bits.SW = 0;  // Switch to HSI
}

void HelperSetExternalHighSpeedClk(void) {
    RCCREG->CR.bits.HSEON = 1;
    //WaitToReady(kHSERDY);
    for (int i=0;i<RCC_TIMEOUT;i++);
    RCCREG->CFGR.bits.SW = 1;  // Switch to HSE
    RCCREG->CR.bits.CSSON = 1;  // Enable clock security system
}

void HelperSetPllFactor(PLL_MulFactor factor) {
    if (factor == CLOCK_1X) {
        return;
    }
    RCCREG->CFGR.bits.PLLMUL = factor;
}

void HelperSetPllSource(ClkConfig config) {
    if (config == HSI) {
        RCCREG->CR.bits.HSION = 1;
        //WaitToReady(kHSIRDY);
        for (int i=0;i<RCC_TIMEOUT;i++){ __asm volatile ("nop"); }
        RCCREG->CFGR.bits.PLLSRC = 0;
    } else {
        RCCREG->CR.bits.HSEON = 1;
       // WaitToReady(kHSERDY);
        for (int i=0;i<RCC_TIMEOUT;i++){ __asm volatile ("nop"); }
        RCCREG->CFGR.bits.PLLSRC = 1;
        RCCREG->CFGR.bits.PLLXTPRE = (config == HSE) ? 0 : 1;
    }
}

void SetExternalClock(HSE_Type HseType) {
    RCCREG->CR.bits.HSEON = 0;
    RCCREG->CR.bits.HSEBYP = (HseType == HSE_CRYSTAL) ? 0 : 1;
}

// Function to enable peripheral clock
void RCC_EnablePeripheralClock(uint8_t busId, uint8_t peripheralId) {
        switch (busId) {
            case AHB_BUS:
                RCCREG->AHBENR.reg |= (1 << peripheralId);
                break;
            case APB1_BUS:
                RCCREG->APB1ENR.reg |= (1 << peripheralId);
                break;
            case APB2_BUS:
                RCCREG->APB2ENR.reg |= (1 << peripheralId);
                break;
            default:
                break;
        }
}

// Function to disable peripheral clock
void RCC_DisablePeripheralClock(uint8_t busId, uint8_t peripheralId) {
        switch (busId) {
            case AHB_BUS:
                RCCREG->AHBENR.reg &= ~(1 << peripheralId);
                break;
            case APB1_BUS:
                RCCREG->APB1ENR.reg &= ~(1 << peripheralId);
                break;
            case APB2_BUS:
                RCCREG->APB2ENR.reg &= ~(1 << peripheralId);
                break;
            default:
                break;
        }
}


uint32_t MCAL_RCC_GetSYS_CLK2Freq( void )
{
	//	SWS: System clock switch status
	//	Set and cleared by hardware to indicate which clock source is used as system clock.
	//	00: HSI oscillator used as system clock
	//	01: HSE oscillator used as system clock
	//	10: PLL used as system clock
	//	11: not applicable

	switch( RCCREG->CFGR.bits.SWS )
	{
	case 0:
		return HSI_RC_CLK ;
		break;

	case 1:
		return HSE_RC_CLK;
		break;
	case 2:
		return 16000000;
		break;

	}


}
uint32_t MCAL_RCC_GetHCLKFreq( void )
{
	//HPRE: AHB prescaler
	return (MCAL_RCC_GetSYS_CLK2Freq( ) >> AHBPrescTable[ ( RCCREG->CFGR.bits.HPRE) & 0xf] ) ;

}
uint32_t MCAL_RCC_GetPCLK1Freq( void )
{

	return (MCAL_RCC_GetHCLKFreq( ) >> APBPrescTable[ ( RCCREG->CFGR.bits.PPRE1) & 0b111] ) ;

}
uint32_t MCAL_RCC_GetPCLK2Freq( void )
{

	return (MCAL_RCC_GetHCLKFreq( ) >> APBPrescTable[ ( RCCREG->CFGR.bits.PPRE2) & 0b111] ) ;

}



