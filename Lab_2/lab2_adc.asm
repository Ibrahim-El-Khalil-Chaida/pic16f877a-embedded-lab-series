;===============================================================================
; File:    lab2_adc.asm
; Purpose: Measure 0–5 V on AN0 (RA0) with the 10-bit ADC, display:
;            • High 8 bits on PORTD LEDs  
;            • Decimal value (0–255) on two multiplexed 7-segment displays  
; Platform: PIC16F877A @ XT osc   
; Date:    2020  
;===============================================================================

    LIST    P=16F877A
    INCLUDE <P16F877.INC>

; Configuration bits: XT oscillator, WDT off, Power-up Timer on,
; Brown-out enabled, Low-voltage Prog. off, Code protection off
    __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _LVP_OFF & _CP_OFF

;-------------------------------------------------------------------------------
; Variable Definition (in Bank 0)
;-------------------------------------------------------------------------------
Count       EQU 0x20    ; Holds ADRESH value / units during div
Tens        EQU 0x21    ; Holds tens digit
Units       EQU 0x22    ; Holds units digit
DelCnt      EQU 0x23    ; Delay counter

;-------------------------------------------------------------------------------
; Reset & Interrupt Vectors
;-------------------------------------------------------------------------------
    ORG     0x00
    GOTO    MAIN

; No interrupts used
    ORG     0x04
    RETFIE

;-------------------------------------------------------------------------------
; Main Program
;-------------------------------------------------------------------------------
    ORG     0x30
MAIN:
    ;--- Configure analog & digital I/O ---
    MOVLW   b'00001110'    ; AN0 analog, others digital
    MOVWF   ADCON1

    MOVLW   b'00000001'    ; ADON=1, CHS=000 (AN0)
    MOVWF   ADCON0

    CLRF    TRISD          ; PORTD as outputs (LEDs)
    MOVLW   b'11111001'    ; RA0 input, RA1/RA2 outputs (7-seg enables)
    MOVWF   TRISA
    CLRF    TRISB          ; PORTB all outputs (segments a–g)

;--- Continuous conversion & display loop ---
Loop:
    BSF     ADCON0, GO     ; Start A/D conversion
WaitADC:
    BTFSC   ADCON0, GO     ; Wait until conversion done
    GOTO    WaitADC

    ;--- Show top 8 bits on PORTD LEDs ---
    MOVF    ADRESH, W
    MOVWF   PORTD

    ;--- Decimal conversion: divide 8-bit value by 10 ---
    MOVF    ADRESH, W
    MOVWF   Count
    CLRF    Tens

DivLoop:
    MOVF    Count, W
    SUBLW   d'10'
    BTFSC   STATUS, C      ; if Count < 10, done
    GOTO    DivDone
    MOVLW   d'10'
    SUBWF   Count, F       ; Count -= 10
    INCF    Tens, F        ; Tens++
    GOTO    DivLoop

DivDone:
    MOVF    Count, W
    MOVWF   Units          ; Units = remainder

    ;--- Multiplex two 7-segment digits indefinitely ---
DispLoop:
    ; Tens digit
    MOVF    Tens, W
    CALL    GetPattern     ; W → segment pattern
    MOVWF   PORTB
    BSF     PORTA, 1       ; RA1 = 1 → enable digit “tens”
    BCF     PORTA, 2       ; RA2 = 0 → disable digit “units”
    CALL    Delay

    ; Units digit
    MOVF    Units, W
    CALL    GetPattern
    MOVWF   PORTB
    BCF     PORTA, 1       ; RA1 = 0 → disable “tens”
    BSF     PORTA, 2       ; RA2 = 1 → enable “units”
    CALL    Delay

    GOTO    Loop

;-------------------------------------------------------------------------------
; Subroutine: GetPattern
;  Input: W = digit (0–9)
;  Output: W = 7-segment pattern (common-cathode)
;-------------------------------------------------------------------------------
GetPattern:
    ADDWF   PCL, F         ; computed GOTO into table
    RETLW   0x3F           ; 0 → 0b00111111
    RETLW   0x06           ; 1 → 0b00000110
    RETLW   0x5B           ; 2 → 0b01011011
    RETLW   0x4F           ; 3 → 0b01001111
    RETLW   0x66           ; 4 → 0b01100110
    RETLW   0x6D           ; 5 → 0b01101101
    RETLW   0x7D           ; 6 → 0b01111101
    RETLW   0x07           ; 7 → 0b00000111
    RETLW   0x7F           ; 8 → 0b01111111
    RETLW   0x6F           ; 9 → 0b01101111

;-------------------------------------------------------------------------------
; Subroutine: Delay (~1 ms at XT)
;-------------------------------------------------------------------------------
Delay:
    MOVLW   d'200'
    MOVWF   DelCnt
Del1:
    NOP
    DECFSZ  DelCnt, F
    GOTO    Del1
    RETURN

    END
