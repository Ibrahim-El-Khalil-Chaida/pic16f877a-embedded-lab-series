# Lab 02: Analog-to-Digital Conversion (ADC)

**Platform:** PIC16F877A  
**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics  

> _Original lab conducted in French._

---

## 🎯 Objectives

1. **Configure the 10-bit ADC** on AN0 (RA0) to sample a 0–5 V potentiometer.  
2. **Read & isolate** the upper 8 bits (MSB) of the conversion result and drive PORTD LEDs.  
3. **Convert** the 8-bit result (0–255) to decimal (tens & units).  
4. **Display** the decimal result on two multiplexed 7-segment displays using PORTB for segments and RA1/RA2 for digit enables.

---

## 📁 Files

- `lab2_adc.asm`  
  Assembly source implementing ADC sampling, MSB LED output, decimal conversion, and two-digit multiplexed display.

- `Lab02_ADC_Conversion.pdf`  
  Original French lab handout.

---

## 🔧 Prerequisites

- **Hardware:**  
  - PIC16F877A development board (e.g., EasyPIC series)  
  - Potentiometer on AN0 (RA0) with 0–5 V range  
  - 8 LEDs on PORTD for MSB display  
  - Two common-cathode 7-segment displays wired to PORTB (segments a–g) and RA1/RA2 (digit enables)  
- **Software:** MPLAB X IDE (or compatible assembler)

---

## 🚀 Build & Run

1. **Open** `lab2_adc.asm` in MPLAB X.  
2. **Assemble & Program** the PIC16F877A.  
3. **Rotate** the potentiometer on RA0:  
   - **PORTD LEDs** reflect the top 8 bits of the ADC result (0–255).  
   - **7-Segment Displays** show the exact decimal value, updating at ≈10 Hz.

---

## 📝 How It Works

1. **ADCON1** configures AN0 as analog input; others as digital.  
2. **ADCON0** turns on the ADC, selects AN0 channel.  
3. Main loop:  
   - Start conversion (`GO` bit).  
   - Poll `GO` until completion.  
   - **MSB** (`ADRESH`) → `PORTD`.  
   - **Decimal conversion** via repeated subtraction (`DivLoop`).  
   - **Multiplex** tens & units on two 7-segment displays (`DispLoop`).  

---

## 📚 Learning Outcomes

- Master ADC initialization and polling on PIC16F877A.  
- Perform integer division in assembly for decimal display.  
- Implement simple time-multiplexing for multi-digit 7-segment displays.  

---

## 🤝 Further Work

- Use ADC interrupts instead of polling to free CPU time.  
- Extend display to show full 10-bit resolution (0–1023) on three digits.  
- Experiment with different ADC clock sources for speed/accuracy trade-offs.
