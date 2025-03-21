processor 18F8722
radix dec 

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF 

#include <xc.inc> 
PSECT udata_acs
global switches, Original
switches: ds 1     ; ????"switch"???switch???
Original: ds 1     ; ????"Original"?????????????
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
 goto start 
PSECT start, class=CODE, reloc=2
start: ; ??????part
  
  movlw 0x0F
  movwf ADCON1, a  ; ???????
  bsf TRISB, 0, a  ; ??RB0???(???RB0???)
  
  clrf TRISF, a    ; ??PORT F???
  
  bcf TRISH, 0, a  ; ??PORT H0???
  bcf TRISH, 1, a  ; ??PORT H1???
  
  movlw 00111100B  ; ??PORT C2-5???(??????4?switch??)
  movwf TRISC, a
  
  movlw 11101111B  ; ??RA4???(Transistor Q3)
  movwf TRISA, a
  
  
main: ; ????part
  clrf LATF, a          ;  !!! ??LED   ????????0
  clrf LATA, a          ;  !!! ??RA4???
  
  ;LED?Switch Part
  movf PORTC, W, a      ; ?????4?switch???
  andlw 00111100B
  movwf switches, a     ; ?????"switch"?
  rrncf switches, f, a  ; ?????????????????switch?
  rrncf switches, W, a  ; ?????????????????W?
  andlw 00001111B       ; ?????4???
  
  movwf Original        ; ?????
  xorlw 00001001B       ; ??????(??????9)
  bz matches_9          ; ??????????case
  
  movf Original, W, a   ; ????????????Port F
  movwf LATF, a         ; ?????PORT F?
  bsf LATA, 4, a        ; ??RA4
  clrf LATA, a          ; ??RA4
  
  ;7-sgement ?RB0 Part
  movlw 11111111B       ;  !!! ??7-segment ?????????1
  movwf LATF, a
  
  movf PORTB, W, a  
  andlw 00000001B       ;  !!! ???????????
  
  
  bz pb2_pressed    
  bra main	    

  
matches_9:
  clrf LATF, a          ; ????LED1-8
  bsf LATA, 4, a        ; ??RA4
  clrf LATA, a          ; ??RA4
  bra main 
  
    
pb2_pressed:
  bcf LATH, 1, a       ;  !!! RH0?1 ?0???
  movlw 10000101B      ;  !!! 7-segment (1.ab.cdefg ????????? 2.0?? 1??)
  movwf LATF, a
  
  movlw 11111111B
  movwf LATH, a        ;  !!! ?????transistor?????
  bra main
  end
    

