processor 18F8722
radix dec 

CONFIG OSC = HS 
CONFIG WDT = OFF 
CONFIG LVP = OFF 

#include <xc.inc> 
PSECT udata_acs
global switches1, switches2, Original
switches1: ds 1     ; Store value from right 4 switches to "switch"
switches2: ds 1     ; Store value from left 4 switches to "switch"
Original: ds 1     ; Store the original value(right  switches) to original data
    
PSECT resetVector, class=CODE, reloc=2
resetVector:
 goto start 
PSECT start, class=CODE, reloc=2
start: ; Input/Output part
  
  movlw 0x0F
  movwf ADCON1, a  ; Set digital form
  movlw 00000001B
  movwf TRISB, a  ; Set RB0 to be the input
  
  clrf TRISF, a    ; Set PORT F to be the output
  
  movlw 11110000B  ; SetRH4-7 to be the input and 0-4 to be the output
  movwf TRISH, a
  
  movlw 00111100B  ; Set PORT C2-5 to be the input(To get the value from right 4 switches)
  movwf TRISC, a
  
  ;
  movlw 11101111B  ; Set RA4 to be the output (Transistor Q3)
  movwf TRISA, a
  
  
main: ; LED and switches part
  movlw 11111111B
  movwf LATF, a         ;  Turn off all LEDs   
  clrf LATA, a          ;  Turn off RA4 (Q3)
  movlw 11111111B
  movwf LATH, a
  ;
  movf PORTC, W, a      ; Read the value from right 4 switches to W
  andlw 00111100B       ; Preserve the required value 
  movwf switches1, a     ; Store the value in "switches1"
  rrncf switches1, f, a  ; Move right 1 bit and store in switches1
  rrncf switches1, W, a  ; Move right 1 bit and store in W
  andlw 00001111B       ; Preserve the required value 
  
  movwf Original        ; Save in Original 
  xorlw 00001001B       ; Compare with 9(XOR operation)
  bz matches_9          ; If euqal, jumps to matches_9
  bra Continue

Continue:
  movf Original, W, a   ; If not, read the value from Original to W
  movwf LATF, a         ; Set the value be LATF
  bsf LATA, 4, a        ; Turn on RA4
  clrf LATA, a          ; Turn off RA4
  
  movlw 11111111B       ; Clear all state in PORT F
  movwf LATF, a
Left_Switches: 
  movf PORTH, W, a      ; Read the value from left 4 switches to W
  andlw 11110000B
  movwf switches2, a    ; Store the value in "switches2"
  rrcf switches2, f, a  ; Move right 1 bit and store in switches2
  rrcf switches2, f, a  ; Move right 1 bit and store in switches2
  rrcf switches2, f, a  ; Move right 1 bit and store in switches2
  rrcf switches2, W, a  ; Move right 1 bit and store in W
  
  subwf Original, W, a  ; Subtract W(switches2) from Original(switches1)
  
  
  bz E_case             ; If euqals to 0, jumps to E_case
  bc R_case             ; If bigger than 0, jumps to R_case
  bra L_case            ; If smaller than 0, jumps to L_case
  
PB0:
  ;7-sgement and RB0 Part
  movlw 11111111B       ; Clear the state in 7-segment
  movwf LATF, a
  
  movf PORTB, W, a  
  andlw 00000001B       ;  !!! Preserve the bit we want
  
  
  bz pb2_pressed    
  bra main	    
  
  
matches_9:
  clrf LATF, a          ; Turn off LED1-8
  bsf LATA, 4, a        ; Turn on RA4
  clrf LATA, a          ; Turn off RA4
  bra Left_Switches
  


E_case:
    movlw 00001110B     ; Dispale 7-segment as E
    movwf LATF, a       
    bcf LATH, 0, a      ; Turn on RH0(Q1)
    bsf LATH, 0, a      ; Turn off RH0(Q1)
    bra PB0
    
R_case:
    movlw 11111111B
    movwf LATF, a
    movlw 11111111B
    movwf LATH, a
    movlw 00010100B     ; Displa 7-segment as R
    movwf LATF, a
    bcf LATH, 0, a      ; Turn on RH0(Q1)
    bsf LATH, 0, a      ; Turn off RH0(Q1)
    bra PB0
    
L_case:
    movlw 10001111B     ; Display 7-segment as R
    movwf LATF, a
    bcf LATH, 0, a      ; Turn on RH0(Q1)
    bsf LATH, 0, a      ; Turn off RH0(Q1)
    bra PB0
    
pb2_pressed:
  bcf LATH, 1, a       ;  !!! RH0 =0(pressed) =1(relaxed)
  movlw 10000101B      ;  !!! 7-segment (1.ab.cdefg from left to right  2.0 bright 1 went out)
  movwf LATF, a
  
  movlw 11111111B
  movwf LATH, a        ;  !!! Remember to turn off transistor
  bra main
  end


