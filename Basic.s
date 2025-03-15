processor 18F8722
radix dec 

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF 

#include <xc.inc> 


PSECT resetVector, class=CODE, reloc=2
resetVector:
 goto start 
PSECT start, class=CODE, reloc=2
start: ; ??????part
  
  movlw 0x0F
  movwf ADCON1, a  
  bsf TRISB, 0, a  
  clrf TRISF, a 
  bcf TRISH, 0, a
  bcf TRISH, 1, a

main: ; ????part
  movlw 11111111B   ;  !!! ??7-segment ?????????1
  movwf LATF, a
  
  movf PORTB, W, a  
  andlw 00000001B   ;  !!! ???????????
  
  
  bz pb2_pressed    
  bra main	    

pb2_pressed:
  bcf LATH, 1, a    ;  !!! RH0?1 ?0???
  movlw 10000101B   ;  !!! 7-segment (1.ab.cdefg ????????? 2.0?? 1??)
  movwf LATF, a
  
  movlw 11111111B
  movwf LATH, a     ;  !!! ?????transistor?????
  bra main
  end
    



