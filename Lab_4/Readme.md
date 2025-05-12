# Lab 04: LCD Control & DS1820 Temperature Sensor

**PIC16F877A Embedded Lab Series**

**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics

> _Original lab handout conducted in French._

---

## 🎯 Objectives

1. **LCD 4-bit Interfacing**  
   Initialize and drive a 16×2 character LCD in 4-bit mode using the MikroC PRO library: clear display, hide cursor, and write text.

2. **Custom Characters & Text Shifting**  
   Define one custom character in CGRAM and implement simple left/right text shifts.

3. **DS1820 One-Wire Temperature**  
   - Perform One-Wire reset, SKIP ROM, CONVERT T, and READ SCRATCHPAD commands.  
   - Decode the 12-bit two’s-complement temperature and format it as “±YY.Y °C”.  
   - Update the display once per second.

---

## 📁 Files

- `lab4_lcd_ds1820.c`  
  C source (MikroC PRO) with LCD and DS1820 routines.

- `Lab04_LCD_DS1820.pdf`  
  Original lab handout (French).

---

## 🔧 Prerequisites

- **Hardware:**  
  - PIC16F877A development board (e.g., EasyPIC)  
  - 16×2 LCD (DB4–DB7 → RB0–RB3; RS→RB4; EN→RB5)  
  - Dallas DS1820 sensor wired to RA5 with pull-up resistor  
  - Potentiometer for LCD contrast  

- **Software:**  
  - MikroC PRO for PIC (LCD & One_Wire libraries)  
  - MPLAB X or programmer utility  

- **References:**  
  - PIC16F877A Datasheet (I/O & oscillator setup)  
  - DS1820 Datasheet (One-Wire commands & timing)  
  - MikroC PRO Library Manual

---

## 🚀 Build & Run

1. **Open** `lab4_lcd_ds1820.c` in MikroC PRO.  
2. **Configure** oscillator to 8 MHz XT.  
3. **Compile & Flash** the PIC16F877A.  
4. **Power On** and observe:  
   - “Temp (C):” on line 1.  
   - Real-time temperature “±YY.Y” on line 2, updated every second.

---

## 📚 Learning Outcomes

- Interface a character LCD in 4-bit mode.  
- Create custom characters and implement text shifts.  
- Communicate with One-Wire sensors and process two’s-complement data.  
- Integrate libraries in embedded-C for rapid prototyping.

---

## 🤝 Further Work

- Display full 12-bit resolution (0.0625 °C) with two decimal places.  
- Add multiple DS18x20 sensors on the same bus and display each temperature.  
- Implement an on-screen menu navigated via push-buttons.
