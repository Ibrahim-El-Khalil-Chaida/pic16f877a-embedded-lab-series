//===============================================================================
// File:    lab4_lcd_ds1820.c
// Purpose: Drive a 16×2 LCD in 4-bit mode and read temperature from a DS1820
//          One-Wire sensor, displaying “±YY.Y °C” on the LCD.
// Platform: PIC16F877A, 8 MHz XT oscillator
// Toolchain: MikroC PRO for PIC
// Author:  Ibrahim El Khalil Chaida
// Date:    2020
//===============================================================================

/* LCD pin mapping */
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;

/* One-Wire pin for DS1820 */
#define DS_PIN  RA5_bit

char displayBuf[6];   // Holds “±YY.Y”  

//-----------------------------------------------------------------------------
// Convert raw 12-bit DS1820 reading to ASCII in displayBuf
//-----------------------------------------------------------------------------
void Format_Temperature(unsigned short raw) {
    // DS1820 uses two’s complement, LSB = 0.0625 °C
    signed int temp = raw;
    if (temp & 0x8000) {   // negative
        temp = (~temp + 1) & 0x0FFF;
        displayBuf[0] = '-';
    } else {
        displayBuf[0] = ' ';
    }
    // Multiply by 0.0625 → temp × 0.0625 = temp/16
    int whole = temp >> 4;
    int frac  = (temp & 0x000F) * 625 / 1000;  // get first decimal digit

    displayBuf[1] = '0' + (whole / 10) % 10;
    displayBuf[2] = '0' + (whole % 10);
    displayBuf[3] = '.';
    displayBuf[4] = '0' + frac;
    displayBuf[5] = 0;    // null terminator
}

void main() {
    unsigned short rawL, rawH;
    unsigned short raw12;

    ADCON1 = 0xFF;       // All AN pins digital
    Lcd_Init();          
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);

    while (1) {
        // 1) Reset and SKIP ROM
        Ow_Reset(&PORTA, DS_PIN);
        Ow_Write(&PORTA, DS_PIN, 0xCC);

        // 2) Convert T
        Ow_Write(&PORTA, DS_PIN, 0x44);
        Delay_ms(600);   // max conversion time

        // 3) Reset and SKIP ROM
        Ow_Reset(&PORTA, DS_PIN);
        Ow_Write(&PORTA, DS_PIN, 0xCC);

        // 4) Read Scratchpad
        Ow_Write(&PORTA, DS_PIN, 0xBE);
        rawL = Ow_Read(&PORTA, DS_PIN);
        rawH = Ow_Read(&PORTA, DS_PIN);

        raw12 = (rawH << 8) | rawL;
        Format_Temperature(raw12);

        // Display
        Lcd_Out(1, 1, "Temp (C):");
        Lcd_Out(2, 1, displayBuf);

        Delay_ms(1000);
    }
}
