/******************************************DC_MOTOR_conf.h*********************************
* Author : ALIAA ESLAM ZAYED                                                              *
* Created: 19 OCT. 2024                                                                   *
* Layer  : HAL                                                                            *
* Verion : V01                                                                            *
*******************************************************************************************/

#ifndef DC_MOTOR_CONF_H_
#define DC_MOTOR_CONF_H_

/*
 **Connection of DC Motor
 *Options of PORT_DC_T1
        *DIOA
        *DIOB
        *DIOC
		
 *Options of PORT_DC_T2
        *DIOA
        *DIOB
        *DIOC
		
 *Options of PIN_DC_T1
        *PIN0
        *PIN1
        *PIN2
        *PIN3
        *PIN4
        *PIN5
        *PIN6
        *PIN7
        *PIN8
        *PIN9
        *PIN10
        *PIN11
        *PIN12
        *PIN13
        *PIN14
        *PIN15
		
  *Options of PIN_DC_T2
        *PIN0
        *PIN1
        *PIN2
        *PIN3
        *PIN4
        *PIN5
        *PIN6
        *PIN7
        *PIN8
        *PIN9
        *PIN10
        *PIN11
        *PIN12
        *PIN13
        *PIN14
        *PIN15
 */


#define PORT_DC_T1   DIOA
#define PIN_DC_T1    PIN0
#define PORT_DC_T2   DIOA
#define PIN_DC_T2    PIN5

#endif  /*DC_MOTOR_CONF_H_*/
