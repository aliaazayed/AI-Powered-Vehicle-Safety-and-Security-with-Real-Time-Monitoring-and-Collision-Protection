
/******************************************STK_interface.h**********************************
* Author : ALIAA ESLAM ZAYED                                                               *
* Created: 16 SEP. 2024                                                                    *
* Layer  : MCAL                                                                            *
* Verion : V02                                                                              *
********************************************************************************************/

#ifndef STK_INTERFACE_H_
#define STK_INTERFACE_H_

typedef enum                 //it should be before functions prototypes
 {
	STK_NOK,
	STK_OK

 }STK_ErrorStatus;


#define     STK_SRC_AHB           0
#define     STK_SRC_AHB_8         1

#define     STK_SINGLE_INTERVAL    0
#define     STK_PERIOD_INTERVAL    1
/**
 * @brief Initializes the SysTick timer.
 * 
 * 
 * @retval uint8_t Status of initialization (0 for success, non-zero for error)
 */
uint8_t STK_Init(void);

/**
 * @brief Performs a busy-wait (blocking delay) for a specified number of ticks.
 * 
 * @param Ticks Number of ticks to wait (based on the configured SysTick timer frequency)
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_SetBusyWait(uint32_t Ticks);

/**
 * @brief Sets a single interval timer that triggers once after the specified number of ticks.
 * 
 * This function configures the SysTick timer to call a user-defined function 
 * after the specified number of ticks has elapsed. The timer only runs once and 
 * then stops.
 * 
 * @param Ticks Number of ticks before the function is triggered
 * @param Copy_ptr Pointer to the function that will be executed after the interval
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_uSetIntervalSingle(uint32_t Ticks, void (*Copy_ptr)(void));

/**
 * @brief Sets a periodic interval timer that triggers repeatedly after the specified number of ticks.
 * 
 * This function configures the SysTick timer to call a user-defined function 
 * periodically at a set interval. The function will continue to be triggered 
 * after each interval until stopped manually.
 * 
 * @param Ticks Number of ticks between each interval
 * @param Copy_ptr Pointer to the function that will be executed at each interval
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_SetIntervalPeriodic(uint32_t Ticks, void (*Copy_ptr)(void));

/**
 * @brief Stops the currently running interval (single or periodic).
 * 
 * This function halts the currently active interval timer, preventing further 
 * execution of the associated function.
 * 
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_StopInterval(void);

/**
 * @brief Retrieves the elapsed time since the start of the timer in ticks.
 * 
 * This function calculates how many ticks have passed since the SysTick timer 
 * started running. It is useful for determining the duration of time that has elapsed.
 * 
 * @param ElapsedTimer Pointer to store the elapsed time in ticks
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_GetElapsedTime(uint32_t *ElapsedTimer);

/**
 * @brief Retrieves the remaining time before the current timer expires in ticks.
 * 
 * This function calculates how many ticks remain before the current interval timer 
 * (single or periodic) expires. It can be used to check how much time is left.
 * 
 * @param RemainingTimer Pointer to store the remaining time in ticks
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_GetRemainingTime(uint32_t *RemainingTimer);

/**
 * @brief Sets a callback function for the SysTick timer.
 * 
 * This function allows you to register a callback function that will be executed 
 * whenever the SysTick timer interrupt occurs.
 * 
 * @param ptr Pointer to the function to be called during the SysTick interrupt
 * @retval uint8_t Status of the operation (0 for success, non-zero for error)
 */
uint8_t STK_uSetCallBack(void (*ptr)(void));

/**
 * @brief Stops the SysTick timer completely.
 * 
 * This function stops the SysTick timer and disables any ongoing timers or intervals.
 */
void STK_voidStopTimer(void);

#endif

