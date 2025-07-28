

#include "../INC/stm32f103xx.h"
#include "../INC/Gpio.h"
#include "../INC/BIT_MATH.h"

void SetPinDirection(uint8_t Port, uint8_t Pin, DIO_PinMode_t Mode) {
    volatile struct GpioRegDef* GPIO;
    volatile uint32_t* reg;

    switch(Port) {
    case DIOA: GPIO = (volatile struct GpioRegDef*)GPIOA_BASE_ADDRESS; break;
    case DIOB: GPIO = (volatile struct GpioRegDef*)GPIOB_BASE_ADDRESS; break;
    case DIOC: GPIO = (volatile struct GpioRegDef*)GPIOC_BASE_ADDRESS; break;
    default: return;
    }

    reg = (Pin <= 7) ? &GPIO->CRL : &GPIO->CRH;
    uint8_t shift = (Pin % 8) * 4;

    // Clear the 4 bits corresponding to the pin
    for (int i = 0; i < 4; i++) {
        CLR_BIT(*reg, (shift + i));
    }

    // Set the new mode
    for (int i = 0; i < 4; i++) {
        if (Mode & (1 << i)) {
            SET_BIT(*reg, (shift + i));
        }
    }
}

void SetPinValue(uint8_t Port, uint8_t Pin, uint8_t Value) {
    volatile struct GpioRegDef* GPIO;

    switch(Port) {
    case DIOA: GPIO = (volatile struct GpioRegDef*)GPIOA_BASE_ADDRESS; break;
    case DIOB: GPIO = (volatile struct GpioRegDef*)GPIOB_BASE_ADDRESS; break;
    case DIOC: GPIO = (volatile struct GpioRegDef*)GPIOC_BASE_ADDRESS; break;
    default: return;
    }

    if (Value == DIO_HIGH) {
    	 SET_BIT(GPIO->ODR, Pin);
    } else {
    	CLR_BIT(GPIO->ODR, Pin);
    }
}

uint8_t GetPinValue(uint8_t Port, uint8_t Pin) {
    volatile struct GpioRegDef* GPIO;
    switch(Port) {
    case DIOA: GPIO = GPIOAREG; break;
    case DIOB: GPIO = GPIOBREG; break;
    case DIOC: GPIO = GPIOCREG; break;
    default: return 0;
    }

    return (uint8_t)GET_BIT(GPIO->IDR, Pin);
}

void SetPortDirection(uint8_t Port, uint8_t StartPin, uint8_t EndPin, DIO_PinMode_t Mode) {
    if (StartPin > PIN15 || EndPin > PIN15 || StartPin > EndPin) {
        // Invalid pin range
        return;
    }

    for (uint8_t i = StartPin; i <= EndPin; i++) {
        SetPinDirection(Port, i, Mode);
    }
}

void SetPortValue(uint8_t Port, uint8_t Position, uint16_t Value) {
    volatile struct GpioRegDef* GPIO;

    switch(Port) {
    case DIOA: GPIO = GPIOAREG; break;
    case DIOB: GPIO = GPIOBREG; break;
    case DIOC: GPIO = GPIOCREG; break;
    default: return;
    }

    if (Position == DIO_LOW) {
        GPIO->ODR = (GPIO->ODR & 0xFF00) | (Value & 0x00FF);
    } else if (Position == DIO_HIGH) {
        GPIO->ODR = (GPIO->ODR & 0x00FF) | ((Value << 8) & 0xFF00);
    }
}

uint16_t GetPortValue(uint8_t Port, uint8_t Position) {
	volatile struct GpioRegDef* GPIO;
    uint16_t Result = 0;

    switch(Port) {
        case DIOA: GPIO = GPIOAREG; break;
        case DIOB: GPIO = GPIOBREG; break;
        case DIOC: GPIO = GPIOCREG; break;
        default: return 0;
    }

    Result = GPIO->IDR;
    if (Position == DIO_LOW) {
        Result &= 0x00FF;
    } else if (Position == DIO_HIGH) {
        Result &= 0xFF00;
    }

    return Result;
}
