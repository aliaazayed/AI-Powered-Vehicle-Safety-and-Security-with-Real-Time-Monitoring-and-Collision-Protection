#ifndef DEV_INC_MCAL_RCC_H_
#define DEV_INC_MCAL_RCC_H_


//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
/* Macros Configuration  */
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
#define HSI_RC_CLK       (uint32_t)16000000
#define HSE_RC_CLK       (uint32_t)8000000

#define RCC_TIMEOUT (400)

/**
 * @brief Enumeration for clock configuration options
 */
typedef enum {
    HSI,        /**< High-Speed Internal clock */
    HSE,        /**< High-Speed External clock */
    HSE_DIV2,   /**< High-Speed External clock divided by 2 */
    PLL         /**< Phase-Locked Loop clock */
} ClkConfig;

/**
 * @brief Enumeration for PLL multiplication factors
 */
typedef enum {
    CLOCK_1X  = 0b11111,  /**< PLL input clock x 1 */
    CLOCK_2X  = 0b0000,   /**< PLL input clock x 2 */
    CLOCK_3X  = 0b0001,   /**< PLL input clock x 3 */
    Clock_4X  = 0b0010,   /**< PLL Clock Multiplier 4x */
    Clock_5X  = 0b0011,   /**< PLL Clock Multiplier 5x */
    Clock_6X  = 0b0100,   /**< PLL Clock Multiplier 6x */
    Clock_7X  = 0b0101,   /**< PLL Clock Multiplier 7x */
    CLOCK_8X  = 0b0110,   /**< PLL Clock Multiplier 8x */
    CLOCK_9X  = 0b0111,   /**< PLL Clock Multiplier 9x */
    CLOCK_10X = 0b1000,   /**< PLL Clock Multiplier 10x */
    CLOCK_11X = 0b1001,   /**< PLL Clock Multiplier 11x */
    CLOCK_12X = 0b1010,   /**< PLL Clock Multiplier 12x */
    CLOCK_13X = 0b1011,   /**< PLL Clock Multiplier 13x */
    CLOCK_14X = 0b1100,   /**< PLL Clock Multiplier 14x */
    CLOCK_15X = 0b1101,   /**< PLL Clock Multiplier 15x */
    CLOCK_16X = 0b1110    /**< PLL input clock x 16 */
} PLL_MulFactor;

/**
 * @brief Enumeration for AHB clock divider options
 */
typedef enum {
    AhpNotDivided = 0b0000,    /**< AHB clock not divided */
    AhpDiv2       = 0b1000,    /**< AHB clock divided by 2 */
    AhpDiv4       = 0b1001,    /**< AHB clock divided by 4 */
    AhpDiv8       = 0b1010,    /**< AHB clock divided by 8 */
    AhpDiv16      = 0b1011,    /**< AHB clock divided by 16 */
    AhpDiv64      = 0b1100,    /**< AHB clock divided by 64 */
    AhpDiv128     = 0b1101,    /**< AHB clock divided by 128 */
    AhpDiv256     = 0b1110,    /**< AHB clock divided by 256 */
    AhpDiv512     = 0b1111     /**< AHB clock divided by 512 */
} AHP_ClockDivider;

/**
 * @brief Enumeration for APB clock divider options
 */
typedef enum {
    APB_NOT_DIVIDED = 0b000,  /**< APB clock not divided */
    APB_DIV2        = 0b100,  /**< APB clock divided by 2 */
    APB_DIV4        = 0b101,  /**< APB clock divided by 4 */
    APB_DIV8        = 0b110,  /**< APB clock divided by 8 */
    APB_DIV16       = 0b111   /**< APB clock divided by 16 */
} APB_ClockDivider;

/**
 * @brief Enumeration for Microcontroller Clock Output (MCO) modes
 */
typedef enum {
    MCO_NO_CLOCK,           /**< No clock on MCO pin */
    MCO_SYSTEM_CLOCK = 4,   /**< System clock on MCO pin */
    MCO_HSI,                /**< HSI clock on MCO pin */
    MCO_HSE,                /**< HSE clock on MCO pin */
    MCO_PLL                 /**< PLL clock on MCO pin */
} McoModes;

/**
 * @brief Enumeration for HSE clock source type
 */
typedef enum {
    HSE_CRYSTAL,  /**< HSE uses an external crystal/ceramic resonator */
    HSE_RC        /**< HSE uses an external RC oscillator */
} HSE_Type;

// Enum for bus types
typedef enum {
    AHB_BUS,
    APB1_BUS,
    APB2_BUS
} RCC_BusType_t;

// Enum for AHB peripherals
typedef enum {
    AHB_DMA1 = 0,
    AHB_DMA2 = 1,
    AHB_SRAM = 2,
    AHB_FLITF = 4,
    AHB_CRC = 6,
    AHB_FSMC = 8,
    AHB_SDIO = 10
} RCC_AHBPeripheral_t;

// Enum for APB2 peripherals
typedef enum {
    APB2_AFIO = 0,
    APB2_DIOA = 2,
    APB2_DIOB = 3,
    APB2_DIOC = 4,
    APB2_DIOD = 5,
    APB2_DIOE = 6,
    APB2_DIOF = 7,
    APB2_DIOG = 8,
    APB2_ADC1 = 9,
    APB2_ADC2 = 10,
    APB2_TIM1 = 11,
    APB2_SPI1 = 12,
    APB2_TIM8 = 13,
    APB2_USART1 = 14,
    APB2_ADC3 = 15,
    APB2_TIM9 = 19,
    APB2_TIM10 = 20,
    APB2_TIM11 = 21
} RCC_APB2Peripheral_t;

// Enum for APB1 peripherals
typedef enum {
    APB1_TIM2 = 0,
    APB1_TIM3 = 1,
    APB1_TIM4 = 2,
    APB1_TIM5 = 3,
    APB1_TIM6 = 4,
    APB1_TIM7 = 5,
    APB1_TIM12 = 6,
    APB1_TIM13 = 7,
    APB1_TIM14 = 8,
    APB1_WWDG = 11,
    APB1_SPI2 = 14,
    APB1_SPI3 = 15,
    APB1_USART2 = 17,
    APB1_USART3 = 18,
    APB1_UART4 = 19,
    APB1_UART5 = 20,
    APB1_I2C1 = 21,
    APB1_I2C2 = 22,
    APB1_USB = 23,
    APB1_CAN = 25,
    APB1_BKP = 27,
    APB1_PWR = 28,
    APB1_DAC = 29
} RCC_APB1Peripheral_t;

/**
 * @brief Set the external clock type
 * @param HseType The type of HSE clock source (crystal or RC)
 */
void SetExternalClock(HSE_Type HseType);

/**
 * @brief Initialize the system clock
 * @param config The desired clock configuration
 * @param mulFactor The PLL multiplication factor (if applicable)
 */
void InitSysClock(ClkConfig config, PLL_MulFactor mulFactor);

/**
 * @brief Set the AHB prescaler
 * @param divFactor The desired AHB clock divider
 */
void SetAHBPrescaler(AHP_ClockDivider divFactor);

/**
 * @brief Set the APB1 prescaler
 * @param divFactor The desired APB1 clock divider
 */
void SetAPB1Prescaler(APB_ClockDivider divFactor);

/**
 * @brief Set the APB2 prescaler
 * @param divFactor The desired APB2 clock divider
 */
void SetAPB2Prescaler(APB_ClockDivider divFactor);

/**
 * @brief Configure the Microcontroller Clock Output (MCO) pin
 * @param mode The desired MCO mode
 */
void SetMCOPinClk(McoModes mode);

/**
 * @brief Adjust the internal clock calibration
 * @param CalibrationValue The calibration value to be applied
 */
void AdjustInternalClock(uint8_t CalibrationValue);

/**
 * @brief Enable and configure the internal high-speed clock
 */
void HelperSetInternalHighSpeedClk();

/**
 * @brief Enable and configure the external high-speed clock
 */
void HelperSetExternalHighSpeedClk();

/**
 * @brief Set the PLL multiplication factor
 * @param factor The desired PLL multiplication factor
 */
void HelperSetPllFactor(PLL_MulFactor factor);

/**
 * @brief Set the PLL clock source
 * @param config The desired PLL clock source configuration
 */
void HelperSetPllSource(ClkConfig config);
/**
 * @brief Disable the clock for a specific peripheral
 * @param busId The bus ID (AHB, APB1, APB2) where the peripheral is located.
 *              It should be a value from the `RCC_BusType_t` enum.
 * @param peripheralId The ID of the peripheral to disable. This is specific to
 *                     the peripheral being controlled and the bus it's on.
 */
void RCC_DisablePeripheralClock(uint8_t busId, uint8_t peripheralId);

/**
 * @brief Enable the clock for a specific peripheral
 * @param busId The bus ID (AHB, APB1, APB2) where the peripheral is located.
 *              It should be a value from the `RCC_BusType_t` enum.
 * @param peripheralId The ID of the peripheral to enable. This is specific to
 *                     the peripheral being controlled and the bus it's on.
 */
void RCC_EnablePeripheralClock(RCC_BusType_t busId, uint8_t peripheralId);

/* USART Assume operate on HSI -> 8 MHz */
uint32_t MCAL_RCC_GetSYS_CLK2Freq( void );
uint32_t MCAL_RCC_GetHCLKFreq    ( void );
uint32_t MCAL_RCC_GetPCLK1Freq   ( void );
uint32_t MCAL_RCC_GetPCLK2Freq   ( void );

#endif // DEV_INC_MCAL_RCC_H_
