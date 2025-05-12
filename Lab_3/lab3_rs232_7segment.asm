;===============================================================================
; File:    lab3_rs232_7segment.asm
; Purpose: USART (RS-232) receive via interrupt; loopback & PC test;
;          display received byte on PORTD LEDs and two multiplexed 7-segment digits
; Platform: PIC16F877A @ XT osc
; Date:    2020
;===============================================================================

    LIST    P=16F877A
    INCLUDE <P16F877.INC>

; Configuration bits: XT osc, WDT off, Pwr‐Up Timer on, BOD enabled,
; Low‐Voltage Prog. off, Code Prot. off
    __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_ON & _LVP_OFF & _CP_OFF

;-------------------------------------------------------------------------------
; Register Equates
;-------------------------------------------------------------------------------
TMP       EQU 0x20      ; Temporary storage for received byte
Count     EQU 0x21      ; Counter for decimal conversion
Tens      EQU 0x22      ; Tens digit
Units     EQU 0x23      ; Units digit
DelCnt    EQU 0x24      ; Delay loop counter

;-------------------------------------------------------------------------------
; Reset & Interrupt Vectors
;-------------------------------------------------------------------------------
    ORG 0x00
    GOTO MAIN

    ORG 0x04
    GOTO SERIAL_ISR

;-------------------------------------------------------------------------------
; Main Program
;-------------------------------------------------------------------------------
    ORG 0x30
MAIN:
    ;— Digital I/O setup —
    MOVLW   b'00001111'   ; AN0–AN3 analog, rest digital
    MOVWF   ADCON1
    CLRF    TRISD         ; PORTD as output ( LEDs )
    MOVLW   b'00000110'   ; RA1/RA2 outputs (7-seg enables), RA0 unused
    MOVWF   TRISA
    CLRF    TRISB         ; PORTB as output (7-seg segments)

    ;— USART @9600 bps (4 MHz XT) —
    MOVLW   d'25'
    MOVWF   SPBRG         ; SPBRG = 25 → 9600 @ 4 MHz, BRGH=1
    MOVLW   b'00100100'   ; TXSTA: BRGH=1, TXEN=1, SYNC=0
    MOVWF   TXSTA
    MOVLW   b'10010000'   ; RCSTA: SPEN=1, CREN=1
    MOVWF   RCSTA

    ;— Enable receive interrupt —
    BSF     PIE1, RCIE
    BSF     INTCON, PEIE
    BSF     INTCON, GIE

    ; Clear outputs
    CLRF    PORTD
    CLRF    PORTB

Main_Loop:
    ; Continuously multiplex 7-segment display
DispLoop:
    ; Tens digit
    MOVF    Tens, W
    CALL    GetPattern
    MOVWF   PORTB
    BSF     PORTA, 1       ; RA1 = 1 → enable tens
    BCF     PORTA, 2       ; RA2 = 0 → disable units
    CALL    Delay

    ; Units digit
    MOVF    Units, W
    CALL    GetPattern
    MOVWF   PORTB
    BCF     PORTA, 1       ; RA1 = 0 → disable tens
    BSF     PORTA, 2       ; RA2 = 1 → enable units
    CALL    Delay

    GOTO    DispLoop

;-------------------------------------------------------------------------------
; Serial Receive Interrupt
;-------------------------------------------------------------------------------
SERIAL_ISR:
    BANKSEL PIR1
    BTFSC   PIR1, RCIF     ; Check RCIF
    GOTO    READ_BYTE
    RETFIE

READ_BYTE:
    ; Read and clear receive
    BANKSEL RCREG
    MOVF    RCREG, W
    MOVWF   TMP
    BANKSEL RCSTA
    BCF     RCSTA, OERR    ; Clear overrun if set
    BANKSEL PIR1
    BCF     PIR1, RCIF     ; Clear receive flag

    ; Show binary on LEDs
    BANKSEL PORTD
    MOVF    TMP, W
    MOVWF   PORTD

    ; Decimal conversion (0–255 → Tens & Units)
    MOVF    TMP, W
    MOVWF   Count
    CLRF    Tens

ConvLoop:
    MOVF    Count, W
    SUBLW   d'10'
    BTFSC   STATUS, C      ; if Count < 10, done
        GOTO DivDone
    MOVLW   d'10'
    SUBWF   Count, F
    INCF    Tens, F
    GOTO    ConvLoop

DivDone:
    MOVF    Count, W
    MOVWF   Units

    RETFIE

;-------------------------------------------------------------------------------
; GetPattern: W = 0–9 → 7-segment pattern (common-cathode)
;-------------------------------------------------------------------------------
GetPattern:
    ADDWF   PCL, F
    RETLW   0x3F ;0
    RETLW   0x06 ;1
    RETLW   0x5B ;2
    RETLW   0x4F ;3
    RETLW   0x66 ;4
    RETLW   0x6D ;5
    RETLW   0x7D ;6
    RETLW   0x07 ;7
    RETLW   0x7F ;8
    RETLW   0x6F ;9

;-------------------------------------------------------------------------------
; Delay ~1 ms @4 MHz
;-------------------------------------------------------------------------------
Delay:
    MOVLW   d'200'
    MOVWF   DelCnt
D1:
    NOP
    DECFSZ  DelCnt, F
    GOTO    D1
    RETURN

    END
