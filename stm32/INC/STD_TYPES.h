/******************************************STD_TYPES_H_*************************************
* Author : ALIAA ESLAM ZAYED                                                               *
* Created: 18 OCT. 2023                                                                    *
* Layer  : LIB                                                                             *
* Verion : V01                                                                             *
********************************************************************************************/


#ifndef  STD_TYPES_H_
#define  STD_TYPES_H_

typedef unsigned char           uint8_t ;
typedef unsigned short int      uint16_t;
typedef unsigned long  int      uint32_t;
typedef unsigned long long int  uint64_t;

typedef signed char             s8 ;
typedef signed short int        s16;
typedef signed long int         s32;
typedef signed long long int    s64;

typedef float                   f32;
typedef double                  f64;


typedef enum
{
  false,
   true
}bool;   
#define NULL  (void*)0

#endif

