;===============================================================================
; File:    lab1_timer_interrupt.asm
; Purpose: Toggle LEDs on PORTB via Timer0 overflow interrupts on PIC16F877A
; Author:  Ibrahim El Khalil Chaida
; Date:    2019
;===============================================================================

    LIST    P=16F877A
    INCLUDE <P16F877.INC>

; Configuration bits: XT oscillator, WDT off, Power-up Timer on,
; code protection off, Brown-out enabled, Low-voltage Prog. off
    __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF & _BODEN_ON & _LVP_OFF

;-------------------------------------------------------------------------------
; Register Equates
;-------------------------------------------------------------------------------
cmpt    EQU 0x45        ; General‐purpose register (not used)

;-------------------------------------------------------------------------------
; Reset and Interrupt Vectors
;-------------------------------------------------------------------------------
    ORG     0x00
    GOTO    start

    ORG     0x04
    GOTO    Timer0_ISR

;-------------------------------------------------------------------------------
; Main Program
;-------------------------------------------------------------------------------
    ORG     0xA0
start:
    ;--- Initialize registers ---
    CLRF    cmpt

    ;--- Enable interrupts: GIE=1, T0IE=1 ---
    BANKSEL INTCON
    MOVLW   b'10010000'
    MOVWF   INTCON

    ;--- Preload Timer0 with 0 ---
    BANKSEL TMR0
    CLRF    TMR0

    ;--- Assign 1:256 prescaler to Timer0 (PS2..PS0=111) ---
    BANKSEL OPTION_REG
    MOVLW   b'10000111'
    MOVWF   OPTION_REG

    ;--- Configure PORTB: RB0–RB3 outputs, RB4–RB7 inputs ---
    BANKSEL TRISB
    MOVLW   b'11110000'
    MOVWF   TRISB

    ;--- Initial LED pattern (optional) ---
    BANKSEL PORTB
    MOVLW   b'00001010'
    MOVWF   PORTB

main_loop:
    NOP
    GOTO    main_loop

;-------------------------------------------------------------------------------
; Timer0 Interrupt Service Routine
;-------------------------------------------------------------------------------
Timer0_ISR:
    BANKSEL PORTB
    COMF    PORTB, F        ; Toggle all PORTB pins
    BANKSEL INTCON
    BCF     INTCON, T0IF    ; Clear Timer0 interrupt flag
    RETFIE                   ; Return and re-enable interrupts

    END
