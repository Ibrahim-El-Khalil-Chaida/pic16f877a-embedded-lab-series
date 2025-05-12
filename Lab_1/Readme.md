# Lab 01: Timer0 Interrupts, Watchdog & Sleep Mode

---
**PIC16F877A Embedded Lab Series**

**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics  

> _Original lab handout was conducted in French._

---

## 🎯 Objectives

1. **Timer0 Interrupts**  
   Configure the 8-bit Timer0 with a 1:256 prescaler to generate periodic overflow interrupts and toggle LEDs on PORTB.

2. **Watchdog-Powered Sleep**  
   Enable the internal Watchdog Timer (WDT) with a 1:256 prescaler to periodically wake the PIC from Sleep and increment an LED pattern.

---

## 📁 Files

- `lab1_timer_interrupt.asm`  
  – Assembly code that sets up Timer0 overflow interrupts and toggles PORTB LEDs in the ISR.

- `lab1_watchdog_sleep.asm`  
  – Assembly code that assigns the prescaler to the WDT, enters Sleep mode, and increments PORTB on each WDT timeout.

- `Lab01_Timer_Watchdog_Sleep.pdf`  
  – Original lab handout (French).

---

## 🔧 Prerequisites

- **Hardware:** PIC16F877A development board (e.g., EasyPIC), LEDs with current-limiting resistors.  
- **Software:** MPLAB X IDE (or compatible assembler/simulator).  
- **Datasheet:** PIC16F877A for register and bit definitions.

---

## 🚀 Build & Run

1. **Open** the chosen `.asm` file in MPLAB X.  
2. **Assemble & Program** the PIC16F877A using your preferred toolchain.  
3. **Observe**:  
   - **Timer Interrupt version:** LEDs on PORTB toggle on each Timer0 overflow.  
   - **Watchdog version:** LEDs increment (binary count) each time the PIC wakes from Sleep.

---

## 📝 Detailed Overview

### Program 1: `lab1_timer_interrupt.asm`

- **Configuration Bits** disable WDT and set XT oscillator.  
- **INTCON**: GIE=1 (global enable), T0IE=1 (Timer0 interrupt).  
- **OPTION_REG**: PSA=0 (prescaler to Timer0), PS2..PS0=111 (1:256).  
- **ISR**: `COMF PORTB` toggles LEDs; `BCF T0IF` clears the interrupt flag.

### Program 2: `lab1_watchdog_sleep.asm`

- **Configuration Bits** enable WDT and XT oscillator.  
- **OPTION_REG**: PSA=1 (prescaler to WDT), PS2..PS0=111 (1:256).  
- **Main Loop**: `SLEEP` enters low-power mode; on WDT timeout wakes and executes `INCF PORTB`.

---

## 📚 Learning Outcomes

- Master Timer0 setup and interrupt handling on PIC microcontrollers.  
- Understand and leverage the internal Watchdog Timer for low-power wake-up.  
- Differentiate between polling, interrupt-driven, and sleep-wake architectures.

---

## 🤝 Further Work

- Integrate both techniques into a single application (e.g., toggle via Timer0, count via WDT).  
- Explore different prescaler values to change interrupt and wake-up rates.  
- Measure power consumption in Sleep vs. active modes.
```
