

#include "../INC/STD_TYPES.h"
#include "../INC/BIT_MATH.h"
#include "../INC/stm32f103xx.h"
#include "../INC/timer.h"

void disable() {
    TIMER1REG->CR1.bits.CEN = 0;
    TIMER2REG->CR1.bits.CEN = 0;
    TIMER3REG->CR1.bits.CEN = 0;
}
void MTIMER1_init(uint8_t mode) {
	switch(mode) {

	case PWM_channel_1_IN:
		TIMER1REG->PSC = 7999;
		TIMER1REG->CR1.bits.CEN = 0;      // Disable counter during configuration

        // Configure for input capture
        TIMER1REG->CCMR1.bits.CC1S = 1;   // Channel 1 as input
        TIMER1REG->CCER.bits.CC1E = 1;    // Enable capture
        TIMER1REG->CCER.bits.CC1P = 0;    // Rising edge

        TIMER1REG->CR1.bits.CEN = 1;      // Enable counter
        break;
	case PWM_channel_1_us:
	        TIMER1REG->PSC = 7999;

	        // Configure CR1
	        TIMER1REG->CR1.bits.CEN = 0;     // Disable counter during configuration
	        TIMER1REG->CR1.bits.DIR = 0;     // Upcounting mode
	        TIMER1REG->CR1.bits.ARPE = 1;    // Enable auto-reload preload
	        TIMER1REG->CR1.bits.CKD = 0;     // Clock division 1

	        // Configure CCMR1 for PWM mode
	        TIMER1REG->CCMR1.bits.CC1S = 0;   // Channel 1 as output
	        TIMER1REG->CCMR1.bits.OC1M = 6;   // PWM mode 1
	        TIMER1REG->CCMR1.bits.OC1PE = 1;  // Enable preload

	        // Configure CCER
	        TIMER1REG->CCER.bits.CC1E = 1;    // Enable channel 1 output
	        TIMER1REG->CCER.bits.CC1P = 0;    // Active high polarity

	        TIMER1REG->CR1.bits.CEN = 1;      // Enable counter
	        break;
	case PWM_channel_2_IN:
		TIMER1REG->CR1.bits.CEN = 1;
		TIMER1REG->PSC = 7;
		TIMER1REG->CCMR1.bits.CC2S = 2;
		TIMER1REG->CCER.bits.CC2E = 1;
		TIMER1REG->CCER.bits.CC2P = 1;
		break;
	case PWM_channel_3_IN:
		TIMER1REG->CR1.bits.CEN = 1;
		TIMER1REG->PSC = 7;
		TIMER1REG->CCMR2.bits.CC3S = 1;
		TIMER1REG->CCER.bits.CC3E = 1;
		TIMER1REG->CCER.bits.CC3P = 1;
		break;
	case PWM_channel_4_IN:
		TIMER1REG->CR1.bits.CEN = 1;
		TIMER1REG->PSC = 7;
		TIMER1REG->CCMR2.bits.CC4S = 2;
		TIMER1REG->CCER.bits.CC4E = 1;
		TIMER1REG->CCER.bits.CC4P = 1;
		break;
	}
	return;
}

void MTIMER2_init(uint8_t mode) {
    switch(mode) {
        case PWM_channel_1_us:
            TIMER2REG->PSC = 71;
                    // Configure CR1
                    TIMER2REG->CR1.bits.CEN = 0;
                    TIMER2REG->CR1.bits.DIR = 0;
                    TIMER2REG->CR1.bits.ARPE = 1;

                    // Configure CCMR1 for PWM mode
                    TIMER2REG->CCMR1.bits.CC1S = 0;   // Channel 1 as output
                    TIMER2REG->CCMR1.bits.OC1M = 6;   // PWM mode 1
                    TIMER2REG->CCMR1.bits.OC1PE = 1;  // Enable preload

                    // Configure CCER
                    TIMER2REG->CCER.bits.CC1E = 1;    // Enable channel 1 output
                    TIMER2REG->CCER.bits.CC1P = 0;    // Active high polarity

                    TIMER2REG->CR1.bits.CEN = 1;      // Enable counter
            break;
        case delay_ms:
                TIMER2REG->PSC = 7999;
                TIMER2REG->CR1.bits.CEN = 0;      // Disable counter during configuration
                TIMER2REG->CR1.bits.DIR = 0;      // Upcounting mode
                TIMER2REG->CR1.bits.ARPE = 1;     // Enable auto-reload preload
                TIMER2REG->CR1.bits.CEN = 1;      // Enable counter
                break;

            case delay_us:
                TIMER2REG->PSC = 7999;
                TIMER2REG->CR1.bits.CEN = 0;
                TIMER2REG->CR1.bits.DIR = 0;
                TIMER2REG->CR1.bits.ARPE = 1;
                TIMER2REG->CR1.bits.CEN = 1;
                break;
	case PWM_channel_1_IN:
		TIMER2REG->CR1.bits.CEN = 1;
		TIMER2REG->PSC = 7;
		TIMER2REG->CCMR1.bits.CC1S = 1;
		TIMER2REG->CCER.bits.CC1E = 1;
		TIMER2REG->CCER.bits.CC1P = 1;
		break;
	case PWM_channel_2_IN:
		TIMER2REG->CR1.bits.CEN = 1;
		TIMER2REG->PSC = 7;
		TIMER2REG->CCMR1.bits.CC2S = 2;
		TIMER2REG->CCER.bits.CC2E = 1;
		TIMER2REG->CCER.bits.CC2P = 1;
		break;
	case PWM_channel_3_IN:
		TIMER2REG->CR1.bits.CEN = 1;
		TIMER2REG->PSC = 7;
		TIMER2REG->CCMR2.bits.CC3S = 1;
		TIMER2REG->CCER.bits.CC3E = 1;
		TIMER2REG->CCER.bits.CC3P = 1;
		break;
	case PWM_channel_4_IN:
		TIMER2REG->CR1.bits.CEN = 1;
		TIMER2REG->PSC = 7;
		TIMER2REG->CCMR2.bits.CC4S = 2;
		TIMER2REG->CCER.bits.CC4E = 1;
		TIMER2REG->CCER.bits.CC4P = 1;
		break;
    }
}

void MTIMER3_init(uint8_t mode) {
	switch(mode) {
	case delay_ms:
		MTIMER3 -> PSC  = (uint16_t)7999;   // Prescaler set for milliseconds delay
		MTIMER3 -> CR1  = (uint16_t)0x0088; // Configuring the timer
		break;

	case delay_us:
		MTIMER3 -> PSC  = (uint16_t)7;      // Prescaler set for microseconds delay
		MTIMER3 -> CR1  = (uint16_t)0x0088; // Configuring the timer
		break;

	case PWM_channel_1_us:
		MTIMER3 -> CR1   = (uint16_t)0x0081; // Timer in upcounting mode, counter enabled
		MTIMER3 -> PSC   = (uint16_t)7;      // Prescaler for PWM in microseconds
		MTIMER3 -> CCMR1 = (uint16_t)0x0068; // PWM mode settings for channel 1
		MTIMER3 -> CCER  = (uint16_t)0x0001; // Enable output on channel 1
		break;

	case PWM_channel_1_IN:
		MTIMER3 -> CR1   = (uint16_t)0x0001; // Timer in upcounting mode, counter enabled
		MTIMER3 -> PSC   = (uint16_t)7;      // Prescaler for input capture
		MTIMER3 -> CCMR1 = (uint16_t)0x0201; // Input capture settings for channel 1
		MTIMER3 -> CCER  = (uint16_t)0x0031; // Capture on both edges, enable channel 1
		break;
	case PWM_channel_2_IN:
		MTIMER3 -> CR1   = (uint16_t)0x0001; // Timer in upcounting mode, counter enabled
		MTIMER3 -> PSC   = (uint16_t)7;      // Prescaler for input capture
		MTIMER3 -> CCMR1 = (uint16_t)0x0102; // Input capture settings for channel 2
		MTIMER3 -> CCER  = (uint16_t)0x0013; // Capture on both edges, enable channel 2
		break;
	case PWM_channel_3_IN:
		MTIMER3 -> CR1   = (uint16_t)0x0001; // Timer in upcounting mode, counter enabled
		MTIMER3 -> PSC   = (uint16_t)7;      // Prescaler for input capture
		MTIMER3 -> CCMR2 = (uint16_t)0x0201; // Input capture settings for channel 3
		MTIMER3 -> CCER  = (uint16_t)0x3100; // Capture on both edges, enable channel 3
		break;
	case PWM_channel_4_IN:
		MTIMER3 -> CR1   = (uint16_t)0x0001; // Timer in upcounting mode, counter enabled
		MTIMER3 -> PSC   = (uint16_t)7;      // Prescaler for input capture
		MTIMER3 -> CCMR2 = (uint16_t)0x0102; // Input capture settings for channel 4
		MTIMER3 -> CCER  = (uint16_t)0x1300; // Capture on both edges, enable channel 4
		break;

	}
	return;
}

void MTIMER2_delay_ms(uint16_t Copy_uint16_tValue) {
    TIMER2REG->ARR = Copy_uint16_tValue;
    TIMER2REG->CR1.bits.CEN = 1;
    while(TIMER2REG->SR.bits.UIF == 0);
    TIMER2REG->SR.bits.UIF = 0;
}

void MTIMER2_delay_us(uint16_t Copy_uint16_tValue) {
    TIMER2REG->ARR = Copy_uint16_tValue;
    TIMER2REG->CR1.bits.CEN = 1;
    while(TIMER2REG->SR.bits.UIF == 0);
    TIMER2REG->SR.bits.UIF = 0;
}


void MTIMER3_delay_ms(uint16_t value)
{
	MTIMER3 -> ARR = value;
	SET_BIT((MTIMER3 -> CR1),CR1_CEN);
	while(GET_BIT((MTIMER3 -> SR),SR_UIF) == 0);
	CLR_BIT((MTIMER3 -> SR),SR_UIF);
	return;
}

void MTIMER3_delay_us(uint16_t value)
{
	MTIMER3 -> ARR = value;
	SET_BIT((MTIMER3 -> CR1),CR1_CEN);
	while(GET_BIT((MTIMER3 -> SR),SR_UIF) == 0);
	CLR_BIT((MTIMER3 -> SR),SR_UIF);
	return;
}


void MTIMER1_PWM(uint8_t channel,uint16_t CNT_value,uint16_t PWM_value)
{
	TIMER1REG->ARR = CNT_value;

	    switch(channel) {
	    case TIMER1_CH1_PORTA_8:
	        TIMER1REG->CCR1 = PWM_value;
	        break;
	    case TIMER1_CH2_PORTA_9:
	        TIMER1REG->CCR2 = PWM_value;
	        break;
	    case TIMER1_CH3_PORTA_10:
	        TIMER1REG->CCR3 = PWM_value;
	        break;
	    case TIMER1_CH4_PORTA_11:
	        TIMER1REG->CCR4 = PWM_value;
	        break;
	    }
}
void MTIMER2_PWM(uint8_t channel, uint16_t CNT_value, uint16_t PWM_value)
{
	TIMER2REG->ARR = CNT_value;

	    switch(channel) {
	    case TIMER2_CH1_PORTA_0:
	        TIMER2REG->CCR1 = PWM_value;
	        break;
	    case TIMER2_CH2_PORTA_1:
	    	TIMER2REG->CCMR1.bits.CC2S = 0;   // Channel as output
            TIMER2REG->CCMR1.bits.OC2M = 6;   // PWM mode 1
            TIMER2REG->CCMR1.bits.OC2PE = 1;  // Enable preload
            TIMER2REG->CCER.bits.CC2E = 1;    // Enable output
	        TIMER2REG->CCR2 = PWM_value;
	        break;
	    case TIMER2_CH3_PORTA_2:
            TIMER2REG->CCMR2.bits.CC3S = 0;   // Channel as output
            TIMER2REG->CCMR2.bits.OC3M = 6;   // PWM mode 1
            TIMER2REG->CCMR2.bits.OC3PE = 1;  // Enable preload
            TIMER2REG->CCER.bits.CC3E = 1;    // Enable output
            TIMER2REG->CCR3 = PWM_value;
	        break;
	    case TIMER2_CH4_PORTA_3:
	        TIMER2REG->CCR4 = PWM_value;
	        break;
	    }
}


void MTIMER3_PWM(uint8_t channel,uint16_t CNT_value,uint16_t PWM_value)
{

	MTIMER3 -> ARR = CNT_value;
	switch(channel)
	{
	case TIMER3_CH1_PORTA_6:
		MTIMER3 -> CCR1 = PWM_value;
		break;

	case TIMER3_CH2_PORTA_7:
		MTIMER3 -> CCR2 = PWM_value;
		break;

	case TIMER3_CH3_PORTB_0:
		MTIMER3 -> CCR3 = PWM_value;
		break;

	case TIMER3_CH4_PORTB_1:
		MTIMER3 -> CCR4 = PWM_value;
		break;
	}

	while(GET_BIT((MTIMER3 -> SR),SR_UIF) == 0);
	CLR_BIT((MTIMER3 -> SR),SR_UIF);

	return;
}


uint16_t MTIMER1_PWM_PulseIn(uint8_t channel,uint16_t CNT_value)
{


	uint16_t value = 0;
	MTIMER1 -> ARR = CNT_value;
	switch(channel)
	{
	case TIMER1_CH1_PORTA_8:
		while(!(GET_BIT((MTIMER1 -> SR),1) && GET_BIT((MTIMER1 -> SR),2)));
		CLR_BIT((MTIMER1 -> SR),1);
		CLR_BIT((MTIMER1 -> SR),2);
		value = ((MTIMER1 -> CCR2)-(MTIMER1 -> CCR1));
		return value;
		break;

	case TIMER1_CH2_PORTA_9:
		while(!GET_BIT((MTIMER1 -> SR),1) && GET_BIT((MTIMER1 -> SR),2));
		CLR_BIT((MTIMER1 -> SR),1);
		CLR_BIT((MTIMER1 -> SR),2);
		value = ((MTIMER1 -> CCR1)-(MTIMER1 -> CCR2));
		return value;
		break;

	case TIMER1_CH3_PORTA_10:
		while(!GET_BIT((MTIMER1 -> SR),3) && GET_BIT((MTIMER1 -> SR),4));
		CLR_BIT((MTIMER1 -> SR),3);
		CLR_BIT((MTIMER1 -> SR),4);
		value = ((MTIMER1 -> CCR4)-(MTIMER1 -> CCR3));
		return value;
		break;

	case TIMER1_CH4_PORTA_11:
		while(!GET_BIT((MTIMER1 -> SR),3) && GET_BIT((MTIMER1 -> SR),4));
		CLR_BIT((MTIMER1 -> SR),3);
		CLR_BIT((MTIMER1 -> SR),4);
		value = ((MTIMER1 -> CCR3)-(MTIMER1 -> CCR4));
		return value;
		break;

	}
	return value;
}

uint16_t MTIMER2_PWM_PulseIn(uint8_t channel,uint16_t CNT_value)
{


	uint16_t value = 0;
	TIMER2REG -> ARR = CNT_value;
	switch(channel)
	{
	case TIMER2_CH1_PORTA_0:
        while(!(TIMER2REG->SR.bits.CC1IF && TIMER2REG->SR.bits.CC2IF));
        TIMER2REG->SR.bits.CC1IF = 0;
        TIMER2REG->SR.bits.CC2IF = 0;
        value = TIMER2REG->CCR2 - TIMER2REG->CCR1;
		break;

	case TIMER2_CH2_PORTA_1:
        while(!(TIMER2REG->SR.bits.CC1IF && TIMER2REG->SR.bits.CC2IF));
        TIMER2REG->SR.bits.CC1IF = 0;
        TIMER2REG->SR.bits.CC2IF = 0;
        value = TIMER2REG->CCR1 - TIMER2REG->CCR2;
		break;

	case TIMER2_CH3_PORTA_2:
		while(!GET_BIT((TIMER2REG -> SR.registerVal),3) && GET_BIT((TIMER2REG -> SR.registerVal),4));
		CLR_BIT((TIMER2REG -> SR.registerVal),3);
		CLR_BIT((TIMER2REG -> SR.registerVal),4);
		value = ((TIMER2REG -> CCR4)-(TIMER2REG -> CCR3));
		break;

	case TIMER2_CH4_PORTA_3:
		while(!GET_BIT((TIMER2REG -> SR.registerVal),3) && GET_BIT((TIMER2REG -> SR.registerVal),4));
		CLR_BIT((TIMER2REG -> SR.registerVal),3);
		CLR_BIT((TIMER2REG -> SR.registerVal),4);
		value = ((TIMER2REG -> CCR3)-(TIMER2REG -> CCR4));
		break;

	}
	return value;
}

uint16_t MTIMER3_PWM_PulseIn(uint8_t channel,uint16_t CNT_value)
{


	uint16_t value = 0;
	MTIMER3 -> ARR = CNT_value;
	switch(channel)
	{
	case TIMER3_CH1_PORTA_6:
		//while(!(GET_BIT((MTIMER3 -> SR),1) && GET_BIT((MTIMER3 -> SR),2)));
		while(!GET_BIT((MTIMER3 -> SR),1));

		CLR_BIT((MTIMER3 -> SR),1);
		CLR_BIT((MTIMER3 -> SR),2);
		value = ((MTIMER3 -> CCR2)-(MTIMER3 -> CCR1));
		return value;
		break;

	case TIMER3_CH2_PORTA_7:
		while(!GET_BIT((MTIMER3 -> SR),1) && GET_BIT((MTIMER3 -> SR),2));
		CLR_BIT((MTIMER3 -> SR),1);
		CLR_BIT((MTIMER3 -> SR),2);
		value = ((MTIMER3 -> CCR1)-(MTIMER3 -> CCR2));
		return value;
		break;

	case TIMER3_CH3_PORTB_0:
		while(!GET_BIT((MTIMER3 -> SR),3) && GET_BIT((MTIMER3 -> SR),4));
		CLR_BIT((MTIMER3 -> SR),3);
		CLR_BIT((MTIMER3 -> SR),4);
		value = ((MTIMER3 -> CCR4)-(MTIMER3 -> CCR3));
		return value;
		break;

	case TIMER3_CH4_PORTB_1:
		while(!GET_BIT((MTIMER3 -> SR),3) && GET_BIT((MTIMER3 -> SR),4));
		CLR_BIT((MTIMER3 -> SR),3);
		CLR_BIT((MTIMER3 -> SR),4);
		value = ((MTIMER3 -> CCR3)-(MTIMER3 -> CCR4));
		return value;
		break;

	}
	return value;
}



