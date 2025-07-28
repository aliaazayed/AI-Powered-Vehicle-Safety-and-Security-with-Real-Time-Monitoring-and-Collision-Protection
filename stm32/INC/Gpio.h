/**
 * @file Gpio.h
 * @author
 * @brief
 * @version 0.1
 * @date 2024-03-16
 *
 * @copyright Copyright (c) 2024
 *
 */
#ifndef DEV_INC_MCAL_GPIO_H_
#define DEV_INC_MCAL_GPIO_H_

#include "STD_TYPES.h"

#define DIO_HIGH    1
#define DIO_LOW     0
typedef enum {
    DIOA = 0,
    DIOB,
    DIOC,
} DIO_Port_t;

// Pin Definitions
typedef enum {
    PIN0 = 0,
    PIN1,
    PIN2,
    PIN3,
    PIN4,
    PIN5,
    PIN6,
    PIN7,
    PIN8,
    PIN9,
    PIN10,
    PIN11,
    PIN12,
    PIN13,
    PIN14,
    PIN15,
} DIO_Pin_t;

//==============================================================================================================
// Pin Modes
typedef enum {
    INPUT_ANALOG            = 0b0000,
    INPUT_FLOATING          = 0b0100,
    INPUT_PULLUP_PULLDOWN   = 0b1000,

    // Output modes - 10MHz
    OUTPUT_SPEED_10MHZ_PP   = 0b0001,
    OUTPUT_SPEED_10MHZ_OD   = 0b0101,
    OUTPUT_SPEED_10MHZ_AFPP = 0b1001,
    OUTPUT_SPEED_10MHZ_AFOD = 0b1101,

    // Output modes - 2MHz
    OUTPUT_SPEED_2MHZ_PP    = 0b0010,
    OUTPUT_SPEED_2MHZ_OD    = 0b0110,
    OUTPUT_SPEED_2MHZ_AFPP  = 0b1010,
    OUTPUT_SPEED_2MHZ_AFOD  = 0b1110,

    // Output modes - 50MHz
    OUTPUT_SPEED_50MHZ_PP   = 0b0011,
    OUTPUT_SPEED_50MHZ_OD   = 0b0111,
    OUTPUT_SPEED_50MHZ_AFPP = 0b1011,
    OUTPUT_SPEED_50MHZ_AFOD = 0b1111
} DIO_PinMode_t;

//==============================================================================================================
// Function Prototypes

/**
 * @brief Set the direction and mode of a specific pin
 * @param port The port of the pin (DIOA, DIOB, DIOC)
 * @param pin The pin number (PIN0 to PIN15)
 * @param mode The mode to set the pin to (e.g., INPUT_FLOATING, OUTPUT_SPEED_50MHZ_PP)
 */
void SetPinDirection(DIO_Port_t port, DIO_Pin_t pin, DIO_PinMode_t mode);

/**
 * @brief Set the value of a specific pin
 * @param port The port of the pin (DIOA, DIOB, DIOC)
 * @param pin The pin number (PIN0 to PIN15)
 * @param value The value to set (DIO_HIGH or DIO_LOW)
 */
void SetPinValue(DIO_Port_t port, DIO_Pin_t pin, uint8_t value);

/**
 * @brief Get the current value of a specific pin
 * @param port The port of the pin (DIOA, DIOB, DIOC)
 * @param pin The pin number (PIN0 to PIN15)
 * @return The current value of the pin (DIO_HIGH or DIO_LOW)
 */
uint8_t GetPinValue(DIO_Port_t port, DIO_Pin_t pin);

/**
 * @brief Set the direction and mode of a group of pins in a port
 * @param port The port to configure (DIOA, DIOB, DIOC)
 * @param startpin The starting position of the group of pins
 * @param mode The mode to set the pins to
 */
void SetPortDirection(uint8_t Port, uint8_t StartPin, uint8_t EndPin, DIO_PinMode_t Mode);

/**
 * @brief Set the value of a group of pins in a port
 * @param port The port to set (DIOA, DIOB, DIOC)
 * @param position The starting position of the group of pins
 * @param value The value to set (16-bit value for up to 16 pins)
 */
void SetPortValue(DIO_Port_t port, uint8_t position, uint16_t value);

/**
 * @brief Get the current value of a group of pins in a port
 * @param port The port to read from (DIOA, DIOB, DIOC)
 * @param position The starting position of the group of pins
 * @return The current value of the group of pins (16-bit value)
 */
uint16_t GetPortValue(DIO_Port_t port, uint8_t position);


#endif  // DEV_INC_MCAL_GPIO_H_
