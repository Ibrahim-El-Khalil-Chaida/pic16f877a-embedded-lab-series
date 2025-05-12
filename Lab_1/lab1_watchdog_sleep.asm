;===============================================================================
; File:    lab1_watchdog_sleep.asm
; Purpose: Wake from Sleep via Watchdog Timer and increment LEDs on PORTB
; Author:  Ibrahim El Khalil Chaida 
; Date:    2019
;===============================================================================

    LIST    P=16F877A
    INCLUDE <P16F877.INC>

; Configuration bits: XT oscillator, WDT on, Power-up Timer on,
; code protection off, Brown-out enabled, Low-voltage Prog. off
    __CONFIG _XT_OSC & _WDT_ON & _PWRTE_ON & _CP_OFF & _BODEN_ON & _LVP_OFF

;-------------------------------------------------------------------------------
; Reset Vector
;-------------------------------------------------------------------------------
    ORG     0x00
start:
    ;--- PORTB as all outputs ---
    BSF     STATUS, RP0
    CLRF    TRISB
    BCF     STATUS, RP0

    ;--- Assign prescaler 1:256 to WDT (PSA=1, PS2..PS0=111) ---
    BANKSEL OPTION_REG
    MOVLW   b'00000111'     ; PSA=1, PS=111
    MOVWF   OPTION_REG

watch_loop:
    SLEEP                   ; Enter low-power sleep (WDT resets counter)
    INCF    PORTB, F        ; On WDT wake, increment LEDs pattern
    GOTO    watch_loop

    END
