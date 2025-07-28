
/******************************************STK_program.c **********************************
 * Author : ALIAA ESLAM ZAYED                                                               *
 * Created: 16 SEP. 2024                                                                    *
 * Layer  : MCAL                                                                            *
 * Verion : V02                                                                            *
 ********************************************************************************************/
#include "../INC/STD_TYPES.h"
#include "../INC/BIT_MATH.h"
#include "../INC/stm32f103xx.h"
#include "../INC/STK_config.h"
#include "../INC/STK_interface.h"


static void (*MSTK_CallBack)(void) =NULL;
static uint8_t STK_ModeOfInterval;

/* Apply Clock choice from configuration file
   Disable Systick interrupt
   Disable Systick                          */    
uint8_t STK_Init(void)
{
#if STK_CLK_SRC == MSTK_SRC_AHB
    /* Disable STK - Disable STK Interrupt - Set clock source AHB */
    SYSTICK->CTRL.bits.ENABLE = 0;
    SYSTICK->CTRL.bits.TICKINT = 0;
    SYSTICK->CTRL.bits.CLKSOURCE = 1;
#else
    /* Disable STK - Disable STK Interrupt - Set clock source AHB/8 */
    SYSTICK->CTRL.bits.ENABLE = 0;
    SYSTICK->CTRL.bits.TICKINT = 0;
    SYSTICK->CTRL.bits.CLKSOURCE = 0;
#endif
    return STK_OK;
}

uint8_t STK_SetBusyWait(uint32_t Ticks)
{
    if(Ticks <= 0x00FFFFFF)
    {
        SYSTICK->LOAD = Ticks;
        /*Enable of systick  (Start Timer )*/
        SYSTICK->CTRL.bits.ENABLE = 1;
        /* Wait till flag is raised */
        while(SYSTICK->CTRL.bits.COUNTFLAG == 0);
        /* Stop Timer */
        SYSTICK->CTRL.bits.ENABLE = 0;
        SYSTICK->LOAD = 0;
        SYSTICK->VAL  = 0;
        return STK_OK;
    }
    return STK_NOK;
}

uint8_t STK_SetIntervalSingle(uint32_t Ticks, void (*Copy_ptr)(void))
{
    if((Ticks <= 0x00FFFFFF) && (Copy_ptr != NULL))
    {
        SYSTICK->LOAD = Ticks;
        SYSTICK->CTRL.bits.ENABLE = 1;
        MSTK_CallBack = Copy_ptr;
        STK_ModeOfInterval = STK_SINGLE_INTERVAL;
        SYSTICK->CTRL.bits.TICKINT = 1;
        return STK_OK;
    }
    return STK_NOK;
}

uint8_t STK_SetIntervalPeriodic(uint32_t Ticks, void (*Copy_ptr)(void))
{
    if((Ticks <= 0x00FFFFFF) && (Copy_ptr != NULL))
    {
        SYSTICK->LOAD = Ticks - 1;
        SYSTICK->CTRL.bits.ENABLE = 1;
        MSTK_CallBack = Copy_ptr;
        STK_ModeOfInterval = STK_PERIOD_INTERVAL;
        SYSTICK->CTRL.bits.TICKINT = 1;
        return STK_OK;
    }
    return STK_NOK;
}

uint8_t STK_GetElapsedTime(uint32_t *ElapsedTimer)
{
    if(ElapsedTimer != NULL)
    {
        *ElapsedTimer = SYSTICK->LOAD - SYSTICK->VAL;
        return STK_OK;
    }
    return STK_NOK;
}

uint8_t STK_GetRemainingTime(uint32_t *RemainingTimer)
{
    if(RemainingTimer != NULL)
    {
        *RemainingTimer = SYSTICK->VAL;
        return STK_OK;
    }
    return STK_NOK;
}

uint8_t STK_StopInterval(void)
{
    SYSTICK->CTRL.bits.ENABLE = 0;
    SYSTICK->LOAD = 0;
    SYSTICK->VAL = 0;
    return STK_OK;
}

void STK_voidStopTimer(void)
{
    SYSTICK->CTRL.bits.ENABLE = 0;
    SYSTICK->LOAD = 0;
    SYSTICK->VAL = 0;
}

void SysTick_Handler(void)
{
    uint8_t Local_u8Temporary;

    if (STK_ModeOfInterval == STK_SINGLE_INTERVAL)
    {
        SYSTICK->CTRL.bits.TICKINT = 0;
        SYSTICK->CTRL.bits.ENABLE = 0;
        SYSTICK->LOAD = 0;
        SYSTICK->VAL  = 0;
    }

    if(MSTK_CallBack != NULL)
    {
        MSTK_CallBack();
    }

    Local_u8Temporary = SYSTICK->CTRL.bits.COUNTFLAG;
}

void MSTK_voidSetCallBack(void (*ptr)(void))
{
    MSTK_CallBack = ptr;
}
