//===============================================================================
// File:    lab5_i2c_rtc.c
// Purpose: Bit-banged I²C to read date/time from PCF8583P RTC and display on LCD
// Platform: PIC16F877A, 8 MHz XT oscillator
// Toolchain: MikroC PRO for PIC
// Author:  Ibrahim EL Khalil Chaida
// Date:    2020
//===============================================================================

#include "Soft_I2C.h"

// LCD pin mapping
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

// I²C lines (bit-bang)
sbit I2C_SCL at RC3_bit;
sbit I2C_SDA at RC4_bit;
sbit I2C_SCL_Direction at TRISC3_bit;
sbit I2C_SDA_Direction at TRISC4_bit;

// PCF8583 I²C addresses
#define RTC_WRITE_ADDR  0xA0  // PCF8583 write address
#define RTC_READ_ADDR   0xA1  // PCF8583 read address

// Utility: BCD → decimal
unsigned char bcdToDec(unsigned char bcd) {
    return ((bcd >> 4) * 10) + (bcd & 0x0F);
}

void main() {
    unsigned char sec_bcd, min_bcd, hr_bcd, day_bcd, mon_bcd, yr_bcd;
    unsigned char sec, min, hr, day, mon, yr;
    char line1[17], line2[17];

    // All AN pins digital
    ADCON1 = 0x0F;
    // Initialize I²C and LCD
    Soft_I2C_Init();
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);

    while (1) {
        // --- Point to seconds register (0x02) ---
        Soft_I2C_Start();
        Soft_I2C_Write(RTC_WRITE_ADDR);
        Soft_I2C_Write(0x02);

        // --- Repeated start & read 6 bytes: sec, min, hr, day, mon, yr ---
        Soft_I2C_RepeatedStart();
        Soft_I2C_Write(RTC_READ_ADDR);
        sec_bcd = Soft_I2C_Read(1);
        min_bcd = Soft_I2C_Read(1);
        hr_bcd  = Soft_I2C_Read(1);
        day_bcd = Soft_I2C_Read(1);
        mon_bcd = Soft_I2C_Read(1);
        yr_bcd  = Soft_I2C_Read(0);
        Soft_I2C_Stop();

        // Convert from BCD
        sec = bcdToDec(sec_bcd);
        min = bcdToDec(min_bcd);
        hr  = bcdToDec(hr_bcd);
        day = bcdToDec(day_bcd);
        mon = bcdToDec(mon_bcd);
        yr  = bcdToDec(yr_bcd);

        // Format strings: Date DD.MM.YYYY, Time HH:MM:SS
        sprintf(line1, "Date: %02u.%02u.20%02u", day, mon, yr);
        sprintf(line2, "Time: %02u:%02u:%02u", hr, min, sec);

        // Display on LCD
        Lcd_Out(1, 1, line1);
        Lcd_Out(2, 1, line2);

        Delay_ms(1000);
    }
}
