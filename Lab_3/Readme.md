# Lab 03: RS-232 Serial Communication & 7-Segment Display

**PIC16F877A Embedded Lab Series**

**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics

> _Original lab handout conducted in French._

---

## 🎯 Objectives

1. **USART Setup**  
   Configure the PIC16F877A’s USART for asynchronous RS-232 at 9600 bps, 8-bit data, no parity, 1 stop bit (8N1).

2. **Interrupt-Driven Receive**  
   Enable the receive interrupt (`RCIF`) to capture incoming bytes without polling.

3. **Loopback & PC Test**  
   Validate functionality by looping TX→RX and by communicating with a PC terminal.

4. **Visual Output**  
   - **PORTD LEDs**: Display the 8-bit value of each received byte in binary.  
   - **Multiplexed 7-Segment Displays**: Show the decimal value (00–255) using two digits.

---

## 📁 Files

- `lab3_rs232_7segment.asm`  
  Assembly source implementing USART, receive ISR, loopback, and multiplexed display.

- `Lab03_RS232_7Segment.pdf`  
  Original French lab handout.

---

## 🔧 Prerequisites

- **Hardware:**  
  - PIC16F877A development board (e.g., EasyPIC series)  
  - RS-232 transceiver (MAX232) or direct-level adapter  
  - DB9 null-modem cable or onboard loopback jumpers  
  - 8 LEDs on PORTD  
  - Two common-cathode 7-segment displays wired to PORTB (segments) and RA1/RA2 (digit enables)  

- **Software:**  
  - MPLAB X IDE (or compatible assembler)  
  - Terminal emulator (e.g., PuTTY, HyperTerminal) set to 9600 bps, 8N1  

- **References:**  
  - PIC16F877A Datasheet (USART & I/O registers)  
  - Original lab PDF for timing diagrams and connection details

---

## 🚀 Build & Run

1. **Open** `lab3_rs232_7segment.asm` in MPLAB X.  
2. **Assemble & Program** the PIC16F877A.  
3. **Loopback Test:**  
   - Enable TX→RX jumper.  
   - Reset the PIC—typed bytes are reflected on LEDs and displays.  
4. **PC Test:**  
   - Connect to a PC via null-modem cable.  
   - Launch your terminal at 9600 bps, 8N1.  
   - Type characters; observe hardware update in real time.

---

## 📝 How It Works

1. **USART Initialization**  
   - `SPBRG = 25`, `BRGH = 1` → 9600 bps @4 MHz.  
   - `TXSTA`: asynchronous, high-speed, transmitter enabled.  
   - `RCSTA`: serial port enabled, continuous receive.

2. **Receive ISR**  
   - On `RCIF`, read `RCREG`, clear errors (`OERR`) & flag.  
   - Output 8-bit value to `PORTD`.  
   - Convert to decimal digits (tens & units) via repeated subtraction.

3. **Multiplexing Loop**  
   - Forever alternate RA1/RA2 enables.  
   - Use `GetPattern` to generate 7-segment codes for digits 0–9.  
   - Short `Delay` (~1 ms) per digit for a stable display.

---

## 📚 Learning Outcomes

- Configure and use the PIC’s hardware USART for RS-232.  
- Implement interrupt-driven data reception.  
- Perform binary-to-decimal conversion in assembly.  
- Drive multiplexed 7-segment displays for numeric output.

---

## 🤝 Further Work

- Transmit an ACK/NACK back to the sender.  
- Handle overrun/framing errors with indicator LEDs.  
- Extend to display ASCII characters (A–Z) on a 14-segment module.
