#ifndef DEV_INC_MCAL_STM32F103XX_H_
#define DEV_INC_MCAL_STM32F103XX_H_


#include "BaseAddress.h"


#include "STD_TYPES.h"

typedef uint32_t RegWidth_t;
struct RccRegDef {
    union {
        struct {
            RegWidth_t HSION   :1; /* High-speed internal oscillator enable */
            RegWidth_t HSIRDY  :1; /* High-speed internal oscillator ready */
            RegWidth_t         :1; /* Reserved */
            RegWidth_t HSITRIM :5; /* High-speed internal oscillator trimming */
            RegWidth_t HSICAL  :8; /* High-speed internal oscillator calibration*/
            RegWidth_t HSEON   :1; /* High-speed external oscillator enable */
            RegWidth_t HSERDY  :1; /* High-speed external oscillator ready */
            RegWidth_t HSEBYP  :1; /* High-speed external oscillator bypass */
            RegWidth_t CSSON   :1; /* Clock security system enable */
            RegWidth_t         :4; /* Reserved */
            RegWidth_t PLLON   :1; /* Phase-locked loop enable */
            RegWidth_t PLLRDY  :1; /* Phase-locked loop ready */
            RegWidth_t         :6; /* Reserved */
        } bits;
        RegWidth_t reg;
    } CR;

    union {
        struct {
            RegWidth_t SW        :2; /* System clock switch */
            RegWidth_t SWS       :2; /* System clock switch status */
            RegWidth_t HPRE      :4; /* AHB prescaler */
            RegWidth_t PPRE1     :3; /* APB low-speed prescaler (APB1) */
            RegWidth_t PPRE2     :3; /* APB high-speed prescaler (APB2) */
            RegWidth_t ADCPRE    :2; /* ADC prescaler */
            RegWidth_t PLLSRC    :1; /* PLL entry clock source */
            RegWidth_t PLLXTPRE  :1; /* HSE divider for PLL entry */
            RegWidth_t PLLMUL    :4; /* PLL multiplication factor */
            RegWidth_t USBPRE    :1; /* USB prescaler */
            RegWidth_t           :1; /* Reserved */
            RegWidth_t MCO       :3; /* MicroController clock output */
            RegWidth_t           :5; /* Reserved  */
        } bits;
        RegWidth_t reg;
    } CFGR;

    RegWidth_t CIR;

    union {
        struct {
            RegWidth_t AFIORST   :1; /* Alternative function clock enable  */
            RegWidth_t           :1; /* Reserved  */
            RegWidth_t IOPARST   :1; /* Port A clock enable  */
            RegWidth_t IOPBRST   :1; /* Port B clock enable  */
            RegWidth_t IOPCRST   :1; /* Port C clock enable  */
            RegWidth_t IOPDRST   :1; /* Port D clock enable  */
            RegWidth_t IOPERST   :1; /* Port E clock enable  */
            RegWidth_t           :2; /* Reserved  */
            RegWidth_t ADC1RST   :1; /* ADC 1 clock enable  */
            RegWidth_t ADC2RST   :1; /* ADC 2 clock enable  */
            RegWidth_t TIM1RST   :1; /* TIM1 clock enable  */
            RegWidth_t SPI1RST   :1; /* SPI1 clock enable  */
            RegWidth_t           :1; /* Reserved  */
            RegWidth_t USART1RST :1; /* USART1 clock enable  */
            RegWidth_t           :17; /* Reserved  */
        } bits;
        RegWidth_t reg;
    } APB2RSTR;

    union {
        struct {
            RegWidth_t TIM2RST   :1;
            RegWidth_t TIM3RST   :1;
            RegWidth_t TIM4RST   :1;
            RegWidth_t TIM5RST   :1;
            RegWidth_t TIM6RST   :1;
            RegWidth_t TIM7RST   :1;
            RegWidth_t TIM12RST  :1;
            RegWidth_t TIM13RST  :1;
            RegWidth_t TIM14RST  :1;
            RegWidth_t WWDGRST   :1;
            RegWidth_t           :2;
            RegWidth_t SPI2RST   :1;
            RegWidth_t SPI3RST   :1;
            RegWidth_t USART2RST :1;
            RegWidth_t USART3RST :1;
            RegWidth_t USART4RST :1;
            RegWidth_t USART5RST :1;
            RegWidth_t I2C1RST   :1;
            RegWidth_t I2C2RST   :1;
            RegWidth_t USBRST    :1;
            RegWidth_t           :1;
            RegWidth_t CANRST    :1;
            RegWidth_t           :1;
            RegWidth_t BKPRST    :1;
            RegWidth_t PWRRST    :1;
            RegWidth_t DACRST    :1;
            RegWidth_t           :2;
        } bits;
        RegWidth_t reg;
    } APB1RSTR;

    union {
        struct {
            RegWidth_t DMA1EN     :1;
            RegWidth_t DMA2EN     :1;
            RegWidth_t SRAMEN     :1;
            RegWidth_t            :1;
            RegWidth_t FLITFEN    :1;
            RegWidth_t            :1;
            RegWidth_t CRCEN      :1;
            RegWidth_t            :5;
            RegWidth_t OTGFSEN    :1;
            RegWidth_t            :1;
            RegWidth_t ETHMACEN   :1;
            RegWidth_t ETHMACTXEN :1;
            RegWidth_t ETHMACRXEN :1;
        } bits;
        RegWidth_t reg;
    } AHBENR;

    union {
        struct {
            RegWidth_t AFIOEN   :1; /* Alternative function clock enable  */
            RegWidth_t          :1; /* Reserved  */
            RegWidth_t IOPAEN   :1; /* Port A clock enable  */
            RegWidth_t IOPBEN   :1; /* Port B clock enable  */
            RegWidth_t IOPCEN   :1; /* Port C clock enable  */
            RegWidth_t IOPDEN   :1; /* Port D clock enable  */
            RegWidth_t IOPEEN   :1; /* Port E clock enable  */
            RegWidth_t          :2; /* Reserved  */
            RegWidth_t ADC1EN   :1; /* ADC 1 clock enable  */
            RegWidth_t ADC2EN   :1; /* ADC 2 clock enable  */
            RegWidth_t TIM1EN   :1; /* TIM1 clock enable  */
            RegWidth_t SPI1EN   :1; /* SPI1 clock enable  */
            RegWidth_t          :1; /* Reserved  */
            RegWidth_t USART1EN :1; /* USART1 clock enable  */
            RegWidth_t          :17; /* Reserved  */
        } bits;
        RegWidth_t reg;
    } APB2ENR;

    union {
        struct {
            RegWidth_t TIM2EN   :1;
            RegWidth_t TIM3EN   :1;
            RegWidth_t TIM4EN   :1;
            RegWidth_t TIM5EN   :1;
            RegWidth_t TIM6EN   :1;
            RegWidth_t TIM7EN   :1;
            RegWidth_t TIM12EN  :1;
            RegWidth_t TIM13EN  :1;
            RegWidth_t TIM14EN  :1;
            RegWidth_t WWDGEN   :1;
            RegWidth_t          :2;
            RegWidth_t SPI2EN   :1;
            RegWidth_t SPI3EN   :1;
            RegWidth_t USART2EN :1;
            RegWidth_t USART3EN :1;
            RegWidth_t USART4EN :1;
            RegWidth_t USART5EN :1;
            RegWidth_t I2C1EN   :1;
            RegWidth_t I2C2EN   :1;
            RegWidth_t USBEN    :1;
            RegWidth_t          :1;
            RegWidth_t CANEN    :1;
            RegWidth_t          :1;
            RegWidth_t BKPEN    :1;
            RegWidth_t PWREN    :1;
            RegWidth_t DACEN    :1;
            RegWidth_t          :2;
        } bits;
        RegWidth_t reg;
    } APB1ENR;

    RegWidth_t BDCR;
    RegWidth_t CSR;

    union {
        struct {
            RegWidth_t DMA1RST     :1;
            RegWidth_t DMA2RST     :1;
            RegWidth_t SRAMRST     :1;
            RegWidth_t             :1;
            RegWidth_t FLITFRST    :1;
            RegWidth_t             :1;
            RegWidth_t CRCRST      :1;
            RegWidth_t             :5;
            RegWidth_t OTGFSRST    :1;
            RegWidth_t             :1;
            RegWidth_t ETHMACRST   :1;
            RegWidth_t ETHMACTXRST :1;
            RegWidth_t ETHMACRXRST :1;
        } bits;
        RegWidth_t reg;
    } AHBRSTR;

    RegWidth_t CFGR2;
};

/* GPIO Register Definitions */
struct GpioRegDef {
    RegWidth_t CRL;     /* Port configuration register low */
    RegWidth_t CRH;     /* Port configuration register high */
    RegWidth_t IDR;     /* Input data register */
    RegWidth_t ODR;     /* Output data register */
    RegWidth_t BSRR;    /* Bit set/reset register */
    RegWidth_t BRR;     /* Bit reset register */
    RegWidth_t LCKR;    /* Lock register */
};


struct NvicRegDef {
    uint32_t ISER[3];    // Interrupt Set Enable Registers
    uint32_t RES0[29];   // Reserved
    uint32_t ICER[3];    // Interrupt Clear Enable Registers
    uint32_t RES1[29];   // Reserved
    uint32_t ISPR[3];    // Interrupt Set Pending Registers
    uint32_t RES2[29];   // Reserved
    uint32_t ICPR[3];    // Interrupt Clear Pending Registers
    uint32_t RES3[29];   // Reserved
    uint32_t IABR[3];    // Interrupt Active Bit Registers
    uint32_t RES4[61];   // Reserved
    uint8_t  IPR[240];   // Interrupt Priority Registers
    uint32_t RES5[644];  // Reserved
    uint32_t STIR;       // Software Trigger Interrupt Register
};

struct SCBRegDef {
    uint32_t CPUID;      // CPUID Base Register
    uint32_t ICSR;       // Interrupt Control and State Register
    uint32_t VTOR;       // Vector Table Offset Register
    uint32_t AIRCR;      // Application Interrupt and Reset Control Register
    union {
        struct {
            uint32_t              :1;     // Reserved
            uint32_t SLEEPONEXIT  :1;
            uint32_t SLEEPDEEP    :1;
            uint32_t              :1;     // Reserved
            uint32_t SEVONPEND    :1;
            uint32_t              :27;    // Reserved
        } bits;
        uint32_t registerVal;  // Register value
    } SCR;   // System Control Register
    uint32_t CCR;        // Configuration and Control Register
    uint32_t SHP[12];    // System Handlers Priority Registers
    uint32_t SHCSR;      // System Handler Control and State Register
    uint32_t CFSR;       // Configurable Fault Status Register
    uint32_t HFSR;       // HardFault Status Register
    uint32_t MMFAR;      // MemManage Fault Address Register
    uint32_t BFAR;       // BusFault Address Register
};



struct AfioRegDef {
    union {
        struct {
            uint32_t PIN      :4;    // Event Output Pin
            uint32_t PORT     :3;    // Event Output Port
            uint32_t EVOE     :1;    // Event Output Enable
            uint32_t          :24;   // Reserved
        } bits;
        uint32_t registerVal;  // Register value
    } EVCR;  // Event Output Configuration Register

    union {
        struct {
            uint32_t SPI1_REMAP           :1;  // SPI1 remapping
            uint32_t I2C1_REMAP           :1;  // I2C1 remapping
            uint32_t USART1_REMAP         :1;  // USART1 remapping
            uint32_t USART2_REMAP         :1;  // USART2 remapping
            uint32_t USART3_REMAP         :2;  // USART3 remapping
            uint32_t TIM1_REMAP           :2;  // TIM1 remapping
            uint32_t TIM2_REMAP           :2;  // TIM2 remapping
            uint32_t TIM3_REMAP           :2;  // TIM3 remapping
            uint32_t TIM4_REMAP           :1;  // TIM4 remapping
            uint32_t CAN_REMAP            :2;  // CAN remapping
            uint32_t PD01_REMAP           :1;  // Port D0/Port D1 remapping
            uint32_t TIM5CH4_IREMAP       :1;  // TIM5 Channel4 Input Capture remapping
            uint32_t ADC1_ETRGINJ_REMAP   :1;  // ADC1 External Trigger Injected Conversion remapping
            uint32_t ADC1_ETRGREG_REMAP   :1;  // ADC1 External Trigger Regular Conversion remapping
            uint32_t ADC2_ETRGINJ_REMAP   :1;  // ADC2 External Trigger Injected Conversion remapping
            uint32_t ADC2_ETRGREG_REMAP   :1;  // ADC2 External Trigger Regular Conversion remapping
            uint32_t                      :3;  // Reserved
            uint32_t SWJ_CFG              :3;  // Serial Wire JTAG configuration
            uint32_t                      :5;  // Reserved
        } bits;
        uint32_t registerVal;  // Register value
    } MAPR;  // AF remap and debug I/O configuration register

    uint32_t EXTICRx[4];  // External interrupt configuration registers

    union {
        struct {
            uint32_t                      :5;  // Reserved
            uint32_t TIM9_REMAP           :1;  // TIM9 remapping
            uint32_t TIM10_REMAP          :1;  // TIM10 remapping
            uint32_t TIM11_REMAP          :1;  // TIM11 remapping
            uint32_t TIM13_REMAP          :1;  // TIM13 remapping
            uint32_t TIM14_REMAP          :1;  // TIM14 remapping
            uint32_t FSMC_NADV            :1;  // FSMC NADV signal
            uint32_t                      :20; // Reserved
        } bits;
        uint32_t registerVal;  // Register value
    } MAPR2;  // AF remap and debug I/O configuration register 2
};


struct SystickRegDef {
    union {
        struct {
            uint32_t ENABLE    :1;   // Counter enable
            uint32_t TICKINT   :1;   // SysTick exception request enable
            uint32_t CLKSOURCE :1;   // Clock source selection
            uint32_t           :13;  // Reserved
            uint32_t COUNTFLAG :1;   // Counter flag
            uint32_t           :15;  // Reserved
        } bits;
        uint32_t registerVal;  // CTRL register value
    } CTRL;

    uint32_t LOAD;  // Reload value
    uint32_t VAL;   // Current value
};

#define SYSTICK ((volatile struct SystickRegDef*)(SYSTICK_BASE_ADDRESS))

struct UsartRegDef {
    union {
        struct {
            uint32_t PE   : 1;
            uint32_t FE   : 1;
            uint32_t NE   : 1;
            uint32_t ORE  : 1;
            uint32_t IDEL : 1;
            uint32_t RXNE : 1;
            uint32_t TC   : 1;
            uint32_t TXE  : 1;
            uint32_t LBD  : 1;
            uint32_t CTS  : 1;
            uint32_t      : 22;
        } bits;
        uint32_t registerVal;
    } SR;

    uint32_t DR;

    union {
        struct {
            uint32_t DIV_Fraction : 4;
            uint32_t DIV_Mantissa : 12;
            uint32_t              : 16;
        } bits;
        uint32_t registerVal;
    } BRR;

    union {
        struct {
            uint32_t SBK    : 1;
            uint32_t RWU    : 1;
            uint32_t RE_TE  : 2;
            uint32_t IDELIE : 1;
            uint32_t RXNEIE : 1;
            uint32_t TCIE   : 1;
            uint32_t TXEIE  : 1;
            uint32_t PEIE   : 1;
            uint32_t PS_PCE : 2;
            uint32_t WAKE   : 1;
            uint32_t M      : 1;
            uint32_t UE     : 1;
            uint32_t        : 18;
        } bits;
        uint32_t registerVal;
    } CR1;

    union {
        struct {
            uint32_t ADD    : 4;
            uint32_t        : 1;
            uint32_t LBDL   : 1;
            uint32_t LBDLIE : 1;
            uint32_t        : 1;
            uint32_t LBCL   : 1;
            uint32_t CPHA   : 1;
            uint32_t CPOL   : 1;
            uint32_t CLKEN  : 1;
            uint32_t STOP   : 2;
            uint32_t LINEN  : 1;
            uint32_t        : 17;
        } bits;
        uint32_t registerVal;
    } CR2;

    union {
        struct {
            uint32_t EIE        : 1;
            uint32_t IREN       : 1;
            uint32_t IRLP       : 1;
            uint32_t HDSEL      : 1;
            uint32_t NACK       : 1;
            uint32_t SCEN       : 1;
            uint32_t DMAR       : 1;
            uint32_t DMAT       : 1;
            uint32_t RTSE_CTSE  : 2;
            uint32_t CTSIE      : 1;
            uint32_t            : 21;
        } bits;
        uint32_t registerVal;
    } CR3;

    uint32_t GTPR;
};



struct EXTIRegDef {
    uint32_t IMR;    // Interrupt mask register
    uint32_t EMR;    // Event mask register
    uint32_t RTSR;   // Rising trigger selection register
    uint32_t FTSR;   // Falling trigger selection register
    uint32_t SWIER;  // Software interrupt event register
    uint32_t PR;     // Pending register
};

struct WWDGRegDef {
    union {
        struct {
            uint32_t T     : 7;   // 7-bit counter (MSB to LSB)
            uint32_t WDGA  : 1;   // Activation bit
            uint32_t       : 24;  // Reserved
        } bits;
        uint32_t registerVal;
    } CR;

    union {
        struct {
            uint32_t W     : 7;   // 7-bit window value
            uint32_t WDGTB : 2;   // Timer Base
            uint32_t EWI   : 1;   // Early Wakeup Interrupt
            uint32_t       : 22;  // Reserved
        } bits;
        uint32_t registerVal;
    } CFR;

    union {
        struct {
            uint32_t EWIF  : 1;   // Early Wakeup Interrupt Flag
            uint32_t       : 31;  // Reserved
        } bits;
        uint32_t registerVal;
    } SR;
};


// ADC Register Definition Structure
typedef struct {
    union {
        struct {
            uint32_t AWD   : 1;
            uint32_t EOC   : 1;
            uint32_t JEOC  : 1;
            uint32_t JSTRT : 1;
            uint32_t STRT  : 1;
            uint32_t       : 27;
        };
        uint32_t registerVal;
    } SR;

    union {
        struct {
            uint32_t AWDCH  : 5;
            uint32_t EOCIE  : 1;
            uint32_t AWDIE  : 1;
            uint32_t JEOCIE : 1;
            uint32_t SCAN   : 1;
            uint32_t AWDSGL : 1;
            uint32_t JAUTO  : 1;
            uint32_t DISCEN : 1;
            uint32_t JDISCEN: 1;
            uint32_t DISCNUM: 3;
            uint32_t DUALMOD: 4;
            uint32_t        : 2;
            uint32_t JAWDEN : 1;
            uint32_t AWDEN  : 1;
            uint32_t        : 8;
        };
        uint32_t registerVal;
    } CR1;

    union {
        struct {
            uint32_t ADON   : 1;
            uint32_t CONT   : 1;
            uint32_t CAL    : 1;
            uint32_t RSTCAL : 1;
            uint32_t        : 4;
            uint32_t DMA    : 1;
            uint32_t        : 2;
            uint32_t ALIGN  : 1;
            uint32_t JEXTSEL: 3;
            uint32_t JEXTTRIG: 1;
            uint32_t        : 1;
            uint32_t EXTSEL : 3;
            uint32_t EXTTRIG: 1;
            uint32_t JSWSTART: 1;
            uint32_t SWSTART: 1;
            uint32_t TSVREFE: 1;
            uint32_t        : 8;
        };
        uint32_t registerVal;
    } CR2;

    union {
        struct {
            uint32_t SMP10 : 3;
            uint32_t SMP11 : 3;
            uint32_t SMP12 : 3;
            uint32_t SMP13 : 3;
            uint32_t SMP14 : 3;
            uint32_t SMP15 : 3;
            uint32_t SMP16 : 3;
            uint32_t SMP17 : 3;
            uint32_t       : 8;
        };
        uint32_t registerVal;
    } SMPR1;

    union {
        struct {
            uint32_t SMP0  : 3;
            uint32_t SMP1  : 3;
            uint32_t SMP2  : 3;
            uint32_t SMP3  : 3;
            uint32_t SMP4  : 3;
            uint32_t SMP5  : 3;
            uint32_t SMP6  : 3;
            uint32_t SMP7  : 3;
            uint32_t SMP8  : 3;
            uint32_t SMP9  : 3;
            uint32_t       : 2;
        };
        uint32_t registerVal;
    } SMPR2;

    uint32_t JOFR1;   // Injected Channel Data Offset Register 1
    uint32_t JOFR2;   // Injected Channel Data Offset Register 2
    uint32_t JOFR3;   // Injected Channel Data Offset Register 3
    uint32_t JOFR4;   // Injected Channel Data Offset Register 4
    uint32_t HTR;     // Watchdog Higher Threshold Register
    uint32_t LTR;     // Watchdog Lower Threshold Register

    union {
        struct {
            uint32_t SQ13 : 5;
            uint32_t SQ14 : 5;
            uint32_t SQ15 : 5;
            uint32_t SQ16 : 5;
            uint32_t L    : 4;
            uint32_t      : 8;
        };
        uint32_t registerVal;
    } SQR1;

    uint32_t SQR2;    // Regular Sequence Register 2
    uint32_t SQR3;    // Regular Sequence Register 3

    union {
        struct {
            uint32_t JSQ1 : 5;
            uint32_t JSQ2 : 5;
            uint32_t JSQ3 : 5;
            uint32_t JSQ4 : 5;
            uint32_t JL   : 2;
            uint32_t      : 10;
        };
        uint32_t registerVal;
    } JSQR;

    union {
        struct {
            uint32_t JDATA : 16;
            uint32_t       : 16;
        };
        uint32_t registerVal;
    } JDR1;

    uint32_t JDR2;    // Injected Data Register 2
    uint32_t JDR3;    // Injected Data Register 3
    uint32_t JDR4;    // Injected Data Register 4

    union {
        struct {
            uint32_t DATA : 16;
            uint32_t      : 16;
        };
        uint32_t registerVal;
    } DR;

} ADCRegDef;




struct I2CRegDef {
    union CR1 {
        struct {
            uint32_t PE          : 1;   // Peripheral enable
            uint32_t SMBUS       : 1;   // SMBus mode
            uint32_t             : 1;   // Reserved
            uint32_t SMBTYPE     : 1;   // SMBus type
            uint32_t ENARP       : 1;   // ARP enable
            uint32_t ENPEC       : 1;   // PEC enable
            uint32_t ENGC        : 1;   // General call enable
            uint32_t NOSTRETCH   : 1;   // Clock stretching disable
            uint32_t START       : 1;   // Start generation
            uint32_t STOP        : 1;   // Stop generation
            uint32_t ACK         : 1;   // Acknowledge enable
            uint32_t POS         : 1;   // Acknowledge/PEC position (for data reception)
            uint32_t PEC         : 1;   // Packet error checking
            uint32_t ALERT       : 1;   // SMBus alert
            uint32_t             : 1;   // Reserved
            uint32_t SWRST       : 1;   // Software reset
            uint32_t             : 16;  // Reserved
        } bits;
        uint32_t registerVal;
    } CR1;

    union CR2 {
        struct {
            uint32_t FREQ        : 6;   // Peripheral clock frequency
            uint32_t RESERVED    : 2;   // Reserved
            uint32_t ITERREN     : 1;   // Error interrupt enable
            uint32_t ITEVTEN     : 1;   // Event interrupt enable
            uint32_t ITBUFEN     : 1;   // Buffer interrupt enable
            uint32_t DMAEN       : 1;   // DMA requests enable
            uint32_t LAST        : 1;   // DMA last transfer
            uint32_t             : 19;  // Reserved
        } bits;
        uint32_t registerVal;
    } CR2;

    union OAR1 {
        struct {
            uint32_t ADD0        : 1;   // Interface address
            uint32_t ADD         : 9;   // Interface address
            uint32_t             : 5;   // Reserved
            uint32_t ADDMODE     : 1;   // Addressing mode (7-bit/10-bit)
            uint32_t             : 16;  // Reserved
        } bits;
        uint32_t registerVal;
    } OAR1;

    union OAR2 {
        struct {
            uint32_t ENDUAL      : 1;   // Dual addressing mode enable
            uint32_t ADD2        : 7;   // Interface address
            uint32_t             : 24;  // Reserved
        } bits;
        uint32_t registerVal;
    } OAR2;

    uint32_t DR;  // 8-bit data register

    union SR1 {
        struct {
            uint32_t SB          : 1;   // Start bit (Master mode)
            uint32_t ADDR        : 1;   // Address sent (master mode)/matched (slave mode)
            uint32_t BTF         : 1;   // Byte transfer finished
            uint32_t ADD10       : 1;   // 10-bit header sent (Master mode)
            uint32_t STOPF       : 1;   // Stop detection (Slave mode)
            uint32_t             : 1;   // Reserved
            uint32_t RxNE        : 1;   // Data register not empty (receivers)
            uint32_t TxE         : 1;   // Data register empty (transmitters)
            uint32_t BERR        : 1;   // Bus error
            uint32_t ARLO        : 1;   // Arbitration lost (master mode)
            uint32_t AF          : 1;   // Acknowledge failure
            uint32_t OVR         : 1;   // Overrun/underrun
            uint32_t PECERR      : 1;   // PEC error in reception
            uint32_t             : 1;   // Reserved
            uint32_t TIMEOUT     : 1;   // Timeout or Tlow detection flag
            uint32_t SMBALERT    : 1;   // SMBus alert
            uint32_t             : 16;  // Reserved
        } bits;
        uint32_t registerVal;
    } SR1;

    union SR2 {
        struct {
            uint32_t MSL         : 1;   // Master/slave
            uint32_t BUSY        : 1;   // Bus busy
            uint32_t TRA         : 1;   // Transmitter/receiver
            uint32_t             : 1;   // Reserved
            uint32_t GENCALL     : 1;   // General call address (Slave mode)
            uint32_t SMBDEFAULT  : 1;   // SMBus device default address (Slave mode)
            uint32_t SMBHOST     : 1;   // SMBus host header (Slave mode)
            uint32_t DUALF       : 1;   // Dual flag (Slave mode)
            uint32_t PEC         : 8;   // Packet error checking
            uint32_t             : 16;  // Reserved
        } bits;
        uint32_t registerVal;
    } SR2;

    union CCR {
        struct {
            uint32_t CcR         : 12;  // Clock control register in Fast/Standard mode
            uint32_t             : 2;   // Reserved
            uint32_t DUTY        : 1;   // Fm mode duty cycle
            uint32_t F_S         : 1;   // I2C master mode selection
            uint32_t             : 16;  // Reserved
        } bits;
        uint32_t registerVal;
    } CCR;

    uint32_t TRISE;
};



struct timerRegDef {
    union {
        struct {
            uint32_t CEN  : 1;    // Counter Enable
            uint32_t UDIS : 1;    // Update Disable
            uint32_t URS  : 1;    // Update Request Source
            uint32_t OPM  : 1;    // One Pulse Mode
            uint32_t DIR  : 1;    // Direction
            uint32_t CMS  : 2;    // Center-aligned Mode Selection
            uint32_t ARPE : 1;    // Auto-Reload Preload Enable
            uint32_t CKD  : 2;    // Clock Division
            uint32_t Reserved : 22;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } CR1;

    union {
        struct {
            uint32_t CCPC : 1;  // Capture/Compare Preloaded Control
            uint32_t      : 1;  // Reserved
            uint32_t CCUS : 1;  // Capture/Compare Control Update Selection
            uint32_t CCDS : 1;  // Capture/Compare DMA Selection
            uint32_t MMS  : 3;  // Master Mode Selection
            uint32_t TI1S : 1;  // TI1 Selection
            uint32_t OIS1 : 1;  // Output Idle State 1 (OC1 output)
            uint32_t OIS1N: 1;  // Output Idle State 1 (OC1N output)
            uint32_t OIS2 : 1;  // Output Idle State 2 (OC2 output)
            uint32_t OIS2N: 1;  // Output Idle State 2 (OC2N output)
            uint32_t OIS3 : 1;  // Output Idle State 3 (OC3 output)
            uint32_t OIS3N: 1;  // Output Idle State 3 (OC3N output)
            uint32_t OIS4 : 1;  // Output Idle State 4 (OC4 output)
            uint32_t Reserved : 17;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } CR2;

    union {
        struct {
            uint32_t SMS  : 3;   // Slave Mode Selection
            uint32_t      : 1;   // Reserved
            uint32_t OCCS : 1;   // OCREF Clear Selection
            uint32_t TS   : 3;   // Trigger Selection
            uint32_t MSM  : 1;   // Master/Slave Mode
            uint32_t ETF  : 4;   // External Trigger Filter
            uint32_t ETPS : 2;   // External Trigger Prescaler
            uint32_t ECE  : 1;   // External Clock Enable
            uint32_t Reserved : 16;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } SMCR;

    union {
        struct {
            uint32_t UIE  : 1;   // Update Interrupt Enable
            uint32_t CC1IE: 1;   // Capture/Compare 1 Interrupt Enable
            uint32_t CC2IE: 1;   // Capture/Compare 2 Interrupt Enable
            uint32_t CC3IE: 1;   // Capture/Compare 3 Interrupt Enable
            uint32_t CC4IE: 1;   // Capture/Compare 4 Interrupt Enable
            uint32_t TIE  : 1;   // Trigger Interrupt Enable
            uint32_t BIE  : 1;   // Break Interrupt Enable
            uint32_t Reserved : 25;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } DIER;

    union {
        struct {
            uint32_t UIF  : 1;   // Update Interrupt Flag
            uint32_t CC1IF: 1;   // Capture/Compare 1 Interrupt Flag
            uint32_t CC2IF: 1;   // Capture/Compare 2 Interrupt Flag
            uint32_t CC3IF: 1;   // Capture/Compare 3 Interrupt Flag
            uint32_t CC4IF: 1;   // Capture/Compare 4 Interrupt Flag
            uint32_t COMIF: 1;   // Reserved bit
            uint32_t TIF  : 1;   // Trigger Interrupt Flag
            uint32_t BIF  : 1;   // Break Interrupt Flag
            uint32_t      : 1;   // Reserved bits
            uint32_t CC1OF: 1;   // Capture/Compare 1 Overcapture Flag
            uint32_t CC2OF: 1;   // Capture/Compare 2 Overcapture Flag
            uint32_t CC3OF: 1;   // Capture/Compare 3 Overcapture Flag
            uint32_t CC4OF: 1;   // Capture/Compare 4 Overcapture Flag
            uint32_t Reserved : 19;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } SR;

    union {
        struct {
            uint32_t UG   : 1;   // Update Generation
            uint32_t CC1G : 1;   // Capture/Compare 1 Generation
            uint32_t CC2G : 1;   // Capture/Compare 2 Generation
            uint32_t CC3G : 1;   // Capture/Compare 3 Generation
            uint32_t CC4G : 1;   // Capture/Compare 4 Generation
            uint32_t TG   : 1;   // Trigger Generation
            uint32_t BG   : 1;   // Break Generation
            uint32_t Reserved : 25;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } EGR;

    union {
        struct {
            uint32_t CC1S    : 2;    // Capture/Compare 1 Selection (00: Output)
            uint32_t OC1FE   : 1;    // Output Compare 1 Fast Enable
            uint32_t OC1PE   : 1;    // Output Compare 1 Preload Enable
            uint32_t OC1M    : 3;    // Output Compare 1 Mode (110 for PWM mode 1)
            uint32_t OC1CE   : 1;    // Output Compare 1 Clear Enable
            uint32_t CC2S    : 2;    // Capture/Compare 2 Selection
            uint32_t OC2FE   : 1;    // Output Compare 2 Fast Enable
            uint32_t OC2PE   : 1;    // Output Compare 2 Preload Enable
            uint32_t OC2M    : 3;    // Output Compare 2 Mode
            uint32_t OC2CE   : 1;    // Output Compare 2 Clear Enable
            uint32_t Reserved: 16;    // Reserved bits
        } bits;
        uint32_t registerVal;
    } CCMR1;

    union {
        struct {
        	 uint32_t CC3S    : 2;    // Capture/Compare 3 Selection (00: Output)
        	        uint32_t OC3FE   : 1;    // Output Compare 3 Fast Enable
        	        uint32_t OC3PE   : 1;    // Output Compare 3 Preload Enable
        	        uint32_t OC3M    : 3;    // Output Compare 3 Mode (110 for PWM mode 1)
        	        uint32_t OC3CE   : 1;    // Output Compare 3 Clear Enable
        	        uint32_t CC4S    : 2;    // Capture/Compare 4 Selection
        	        uint32_t OC4FE   : 1;    // Output Compare 4 Fast Enable
        	        uint32_t OC4PE   : 1;    // Output Compare 4 Preload Enable
        	        uint32_t OC4M    : 3;    // Output Compare 4 Mode
        	        uint32_t OC4CE   : 1;    // Output Compare 4 Clear Enable
        	        uint32_t Reserved: 16;   // Reserved bits
        } bits;
        uint32_t registerVal;
    } CCMR2;

    union {
        struct {
            uint32_t CC1E : 1;  // Capture/Compare 1 Output Enable
            uint32_t CC1P : 1;  // Capture/Compare 1 Output Polarity
            uint32_t CC1NE: 1;  // Capture/Compare 1N Output Enable
            uint32_t CC1NP: 1;  // Capture/Compare 1N Output Polarity
            uint32_t CC2E : 1;  // Capture/Compare 2 Output Enable
            uint32_t CC2P : 1;  // Capture/Compare 2 Output Polarity
            uint32_t CC2NE: 1;  // Capture/Compare 2N Output Enable
            uint32_t CC2NP: 1;  // Capture/Compare 2N Output Polarity
            uint32_t CC3E : 1;  // Capture/Compare 3 Output Enable
            uint32_t CC3P : 1;  // Capture/Compare 3 Output Polarity
            uint32_t CC3NE: 1;  // Capture/Compare 3N Output Enable
            uint32_t CC3NP: 1;  // Capture/Compare 3N Output Polarity
            uint32_t CC4E : 1;  // Capture/Compare 4 Output Enable
            uint32_t CC4P : 1;  // Capture/Compare 4 Output Polarity
            uint32_t      : 1;  // Reserved
            uint32_t CC4NP : 1;  // Capture/Compare 4 Output Polarity
            uint32_t Reserved : 16;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } CCER;

    uint32_t CNT;
    uint32_t PSC;
    uint32_t ARR;
    uint32_t RCR;
    uint32_t CCR1;
    uint32_t CCR2;
    uint32_t CCR3;
    uint32_t CCR4;

    union {
        struct {
            uint32_t DTG   : 8;  // Dead-Time Generator Set-up
            uint32_t LOCK  : 2;  // Lock Configuration
            uint32_t OSSI  : 1;  // Off-State Selection for Idle mode
            uint32_t OSSR  : 1;  // Off-State Selection for Run mode
            uint32_t BKE   : 1;  // Break Enable
            uint32_t BKPP   : 1;  // Break Polarity
            uint32_t AOE   : 1;  // Automatic Output Enable
            uint32_t MOE   : 1;  // Main Output Enable
            uint32_t Reserved : 16;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } BDTR;

    union {
        struct {
            uint32_t DBA   : 5;  // DMA Base Address
            uint32_t       : 3;  // Reserved
            uint32_t DBL   : 5;  // DMA Buffer Size
            uint32_t Reserved : 19;  // Reserved bits
        } bits;
        uint32_t registerVal;
    } DCR;

    uint32_t DMAR;
};



#define RCCREG   ((volatile struct RccRegDef*)RCC_BASE_ADDRESS)

#define GPIOAREG ((volatile struct GpioRegDef*)GPIOA_BASE_ADDRESS)
#define GPIOBREG ((volatile struct GpioRegDef*)GPIOB_BASE_ADDRESS)
#define GPIOCREG ((volatile struct GpioRegDef*)GPIOC_BASE_ADDRESS)

#define NVICREG   ((volatile struct NvicRegDef*)(NVIC_BASE_ADDRESS))
#define SCBREG    ((volatile struct SCBRegDef*)(SCB_BASE_ADDRESS))

#define AFIOREG   ((volatile struct AfioRegDef*)(AFIO_BASE_ADDRESS))

#define USART1REG ((volatile struct UsartRegDef*)(USART1_BASE_ADDRESS))
#define USART2REG ((volatile struct UsartRegDef*)(USART2_BASE_ADDRESS))
#define USART3REG ((volatile struct UsartRegDef*)(USART3_BASE_ADDRESS))

#define WWDGREG ((volatile struct WWDGRegDef*)(WWDG_BASE_ADDRESS))

#define ADC1REG ((volatile ADCRegDef*)(ADC1_BASE_ADDRESS))
#define ADC2REG ((volatile ADCRegDef*)(ADC2_BASE_ADDRESS))

#define TIMER1REG ((volatile struct timerRegDef*)TIMER1_BASE_ADDRESS)
#define TIMER2REG ((volatile struct timerRegDef*)TIMER2_BASE_ADDRESS)
#define TIMER3REG ((volatile struct timerRegDef*)TIMER3_BASE_ADDRESS)
#define TIMER4REG ((volatile struct timerRegDef*)TIMER4_BASE_ADDRESS)
#define TIMER5REG ((volatile struct timerRegDef*)TIMER5_BASE_ADDRESS)

#define I2C1REG ((volatile struct I2CRegDef*)I2C1_BASE_ADDRESS)
#define I2C2REG ((volatile struct I2CRegDef*)I2C2_BASE_ADDRESS)


#endif
