# Lab 05: I²C Bus & Real-Time Clock (PCF8583)

**PIC16F877A Embedded Lab Series**

**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics

> _Original lab handout conducted in French._

---

## 🎯 Objectives

1. **Software I²C**  
   Implement bit-banged I²C on RC3 (SCL) and RC4 (SDA) to communicate with the PCF8583P real-time clock/calendar.

2. **RTC Data Retrieval**  
   Read six BCD-encoded registers (seconds, minutes, hours, day, month, year) via I²C.

3. **LCD Display**  
   Convert BCD values to human-readable decimal and present:
   - **Line 1:** `Date: DD.MM.YYYY`  
   - **Line 2:** `Time: HH:MM:SS`  
   on a 16×2 character LCD in 4-bit mode.

---

## 📁 Files

- `lab5_i2c_rtc.c`  
  MikroC PRO C source with Soft I²C and LCD routines.

- `Soft_I2C.h` / `Soft_I2C.c`  
  Bit-bang I²C helper library (used by `lab5_i2c_rtc.c`).

- `Lab05_I2C_RTC.pdf`  
  Original French lab handout.

---

## 🔧 Prerequisites

- **Hardware:**  
  - PIC16F877A development board (e.g., EasyPIC)  
  - PCF8583P RTC module with pull-ups on SCL/SDA  
  - 16×2 character LCD wired in 4-bit mode to PORTB (RB0–RB3 data, RB4=RS, RB5=EN)  
- **Software:**  
  - MikroC PRO for PIC (Soft I²C & LCD libraries)  
  - MPLAB X or equivalent programmer utility  
- **References:**  
  - PIC16F877A Datasheet (I/O configuration & oscillator)  
  - PCF8583P Datasheet (register map & I²C protocol)  
  - Original lab PDF

---

## 🚀 Build & Run

1. **Open** `lab5_i2c_rtc.c` in MikroC PRO.  
2. **Ensure** oscillator set to 8 MHz XT.  
3. **Compile & Flash** the PIC16F877A.  
4. **Power On**:  
   - The LCD displays the current date and time read from the PCF8583, updating every second.

---

## 📝 How It Works

1. **Soft I²C Initialization**  
   - Configure RC3/RC4 as open-drain I²C lines.  
   - `Soft_I2C_Start()`, `Write(address)`, `Write(register)`, repeated start, `Read()` × 6, `Stop()`.

2. **BCD Conversion**  
   - High nibble × 10 + low nibble → decimal for each component.

3. **LCD Updates**  
   - Format strings with `sprintf` and `Lcd_Out` for two display lines.

---

## 📚 Learning Outcomes

- Master bit-banged I²C protocol on PIC microcontrollers.  
- Decode BCD-formatted time/date registers.  
- Integrate peripheral communication with user feedback on an LCD.

---

## 🤝 Further Work

- Switch to hardware MSSP I²C peripheral for efficiency.  
- Implement alarm interrupt using PCF8583’s alarm register.  
- Log timestamped events to external EEPROM via I²C.
