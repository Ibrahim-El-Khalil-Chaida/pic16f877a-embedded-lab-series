# PIC16F877A Embedded Lab Series

**Collection of six hands-on embedded systems lab exercises for the PIC16F877A microcontroller, demonstrating timer interrupts, watchdog & sleep mode, ADC, serial communication, LCD & sensor interfacing, I²C, and CAN bus protocols.**

---

## 📚 Overview

This monolithic repository groups six progressive labs, each in its own folder with complete source code, detailed explanations, and hardware setup instructions:

1. **Timer Interrupts, Watchdog & Sleep Mode**  
2. **Analog-to-Digital Conversion (ADC)**  
3. **RS-232 Serial Communication & 7-Segment Display**  
4. **LCD Control & DS1820 Temperature Sensor**  
5. **I²C Bus & Real-Time Clock (PCF8583)**  
6. **CAN Bus Communication & LCD Display**

Each lab is designed to build practical skills in embedded-C and assembly on the PIC16F877A platform.

---

## 📂 Repository Structure
```

pic16f877a-embedded-lab-series/
├── Lab01\_Timer\_Watchdog\_Sleep/
│   ├── lab1\_timer\_interrupt.asm
│   ├── lab1\_watchdog\_sleep.asm
│   ├── Lab01\_Timer\_Watchdog\_Sleep.pdf
│   └── README.md
├── Lab02\_ADC\_Conversion/
│   ├── lab2\_adc.asm
│   ├── Lab02\_ADC\_Conversion.pdf
│   └── README.md
├── Lab03\_RS232\_7Segment/
│   ├── lab3\_rs232\_7segment.asm
│   ├── Lab03\_RS232\_7Segment.pdf
│   └── README.md
├── Lab04\_LCD\_DS1820/
│   ├── lab4\_lcd\_ds1820.c
│   ├── Lab04\_LCD\_DS1820.pdf
│   └── README.md
├── Lab05\_I2C\_RTC/
│   ├── lab5\_i2c\_rtc.c
│   ├── Lab05\_I2C\_RTC.pdf
│   └── README.md
├── Lab06\_CAN\_LCD/
│   ├── lab6\_node1.c
│   ├── lab6\_node2.c
│   ├── Lab06\_CAN\_LCD.pdf
│   └── README.md
└── README.md
```
</pre> 

  
---
- **Root README.md**: High-level overview and instructions.  
- **Lab-specific folders**: Each contains source files and a standalone README.

---

## 🔧 Prerequisites

- **Toolchains**  
  - MPLAB X IDE (or equivalent assembler/simulator)  
  - MikroC PRO for PIC (for Labs 4, 5, and 6)  

- **Hardware**  
  - PIC16F877A development board (e.g., EasyPIC series)  
  - LEDs, potentiometers, LCDs, 7-segment displays, sensors (as specified per lab)  
  - Communication cables (RS-232 null-modem, I²C pull-ups, CAN transceivers)

- **Datasheets & References**  
  - PIC16F877A Datasheet  
  - Peripheral component datasheets (PCF8583, DS1820, MCP2515, etc.)

---

## 🚀 Getting Started

1. **Clone the repository**  
   ```bash
   git clone https://github.com/your-username/pic16f877a-embedded-lab-series.git
   cd pic16f877a-embedded-lab-series

2. **Select a lab**
cd Lab01_Timer_Watchdog_Sleep
