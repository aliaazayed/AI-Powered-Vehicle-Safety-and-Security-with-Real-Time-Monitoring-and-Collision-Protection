/*
 * timer.h
 *
 *  Created on: Dec 15, 2024
 *      Author: XPRISTO
 */

#ifndef TIMER_H_
#define TIMER_H_

#define MTIMER1  ((volatile TIMER*)(0x40012C00))
#define MTIMER2  ((volatile TIMER*)(0x40000000))
#define MTIMER3  ((volatile TIMER*)(0x40000400))

#define CR1_CEN  0
#define SR_UIF   0
#define EGR_UG   0

typedef struct
{
	uint32_t CR1;
	uint32_t CR2;
	uint32_t SMCR;
	uint32_t DIER;
	uint32_t SR;
	uint32_t EGR;
	uint32_t CCMR1;
	uint32_t CCMR2;
	uint32_t CCER;
	uint32_t CNT;
	uint32_t PSC;
	uint32_t ARR;
	uint32_t RES1;
	uint32_t CCR1;
	uint32_t CCR2;
	uint32_t CCR3;
	uint32_t CCR4;
	uint32_t BDTR;
	uint32_t DCR;
	uint32_t DMAR;
}TIMER;




/*TIMER3REGREG delay types*/
#define delay_ms     		      1
#define delay_us     		      2

/*PWM Mode*/
#define PWM_channel_1_us          3

/*PWM Period & Duty Cycle Measurement on channel 1 by two registers CCR1 & CCR2*/
#define PWM_channel_1_IN          12
#define PWM_channel_2_IN          13
#define PWM_channel_3_IN          14
#define PWM_channel_4_IN          15

/*TIMER3REGREG I/O capture/compare channels*/
#define TIMER1_CH1_PORTA_8   0
#define TIMER1_CH2_PORTA_9   1
#define TIMER1_CH3_PORTA_10  2
#define TIMER1_CH4_PORTA_11  3

/*TIMER3REGREG I/O capture/compare channels*/
#define TIMER2_CH1_PORTA_0  4
#define TIMER2_CH2_PORTA_1  5
#define TIMER2_CH3_PORTA_2  6
#define TIMER2_CH4_PORTA_3  7

/*TIMER3REGREG I/O capture/compare channels*/
#define TIMER3_CH1_PORTA_6  8
#define TIMER3_CH2_PORTA_7  9
#define TIMER3_CH3_PORTB_0  10
#define TIMER3_CH4_PORTB_1  11

void disable();
/*TIMER3REG Functions*/
void MTIMER1_init(uint8_t mode);

void MTIMER1_PWM(uint8_t channel,uint16_t CNT_value,uint16_t PWM_value);
uint16_t MTIMER1_PWM_PulseIn(uint8_t channel,uint16_t CNT_value);

/*TIMER2 Functions*/
void MTIMER2_init(uint8_t Copy_uint8_tDelay_type);
void MTIMER2_delay_ms(uint16_t Copy_uint16_tValue);
void MTIMER2_delay_us(uint16_t Copy_uint16_tValue);
void MTIMER2_PWM(uint8_t channel,uint16_t CNT_value,uint16_t PWM_value);
uint16_t MTIMER2_PWM_PulseIn(uint8_t channel,uint16_t CNT_value);


/*TIMER3REG Functions*/
void MTIMER3_init(uint8_t mode);
void MTIMER3_delay_ms(uint16_t value);
void MTIMER3_delay_us(uint16_t value);
void MTIMER3_PWM(uint8_t channel,uint16_t CNT_value,uint16_t PWM_value);
uint16_t MTIMER3_PWM_PulseIn(uint8_t channel,uint16_t CNT_value);




#endif /* TIMER_H_ */
