

#ifndef HULTRA_INTERFACE_H_
#define HULTRA_INTERFACE_H_



/*Ultra-Sonic functions*/
void HULTRA_attachPin(uint8_t Copy_uint8_tTrigPort,uint8_t Copy_uint8_tTrigPIN,uint8_t Copy_uint8_tEcho) ;
void HULTRA_Trig(uint8_t Copy_uint8_tPort,uint8_t Copy_uint8_tPin) ;
uint16_t HULTRA_Distance(uint8_t timer, uint8_t Copy_uint8_tChannel);







#endif
