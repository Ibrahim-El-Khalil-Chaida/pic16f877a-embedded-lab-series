# Lab 06: CAN Bus Communication & LCD Display

**PIC16F877A Embedded Lab Series**

**Source:**  
University of Science and Technology Mohamed Boudiaf, Oran, Algeria  
Faculty of Electrical Engineering, Electronics Department  
Master’s in Embedded Systems Electronics  

> _Original lab handout conducted in French._ :contentReference[oaicite:10]{index=10}:contentReference[oaicite:11]{index=11}

---

## 🎯 Objectives

1. **MCP2515 Interface**  
   Connect PIC16F877A to an external MCP2515 CAN controller via SPI and MCP2551 transceiver.

2. **Two-Node Ping-Pong**  
   • Node 1 (master, ID 12111) sends an initial byte (0x09).  
   • Node 2 (slave, ID 3) receives, increments, and echoes back.  
   • Both nodes display incoming values on PORTB and a 16×2 LCD.  

3. **CANSPI Library**  
   Use MikroC PRO’s CANSPI routines: `CANSPIInitialize`, `CANSPISetMask`, `CANSPISetFilter`, `CANSPIRead`, `CANSPIWrite`.

---

## 📁 Files

- `lab6_node1.c`  
  Master node implementation: sends/receives data, displays on PORTB & LCD.

- `lab6_node2.c`  
  Slave node implementation: receives, increments, echoes back, displays.

- `Lab06_CAN_LCD.pdf`  
  Original French lab handout.

---

## 🔧 Prerequisites

- **Hardware:**  
  - PIC16F877A development board (e.g., EasyPIC series)  
  - MCP2515 CAN controller + MCP2551 transceiver (terminated twisted-pair)  
  - 16×2 character LCD wired in 4-bit mode to PORTB (RB0–RB3 data, RB4=RS, RB5=EN)  
  - SPI lines: RC3=SCK, RC5=SDO, RC4=SDI, RC0=CS, RC2=RESET  

- **Software:**  
  - MikroC PRO for PIC (CANSPI & LCD libraries)  
  - MPLAB X or compatible programmer utility  

- **References:**  
  - PIC16F877A Datasheet (SPI & I/O configuration)  
  - MCP2515 Datasheet (CAN protocol & register map)  
  - Original lab PDF

---

## 🚀 Build & Run

1. **Clone & open** this lab folder in MikroC PRO.  
2. **Connect** one board with `lab6_node1.c` and another with `lab6_node2.c`.  
3. **Compile & flash** both PICs at 8 MHz XT.  
4. **Power on** both boards; observe:  
   - Node 1 → Node 2 → Node 1 ping-pong counter on PORTB & LCD.  
   - Both LCDs update in real time.

---

## 📝 How It Works

1. **Initialization**  
   - SPI1 to talk with MCP2515.  
   - `CANSPIInitialize(1,3,3,3,1, Can_Init_Flags)` to configure bit-timing & filters.  
   - Masks set to accept only the partner node’s ID.  

2. **Communication Loop**  
   - Node 1 sends an initial 0x09 via `CANSPIWrite`.  
   - Each node waits in `CANSPIRead()`, checks `Rx_ID`, then displays & increments.  

3. **LCD Output**  
   - Uses `Lcd_Out` to show “Rx from N# : XX” on line 2, line 1 shows node status.

---

## 📚 Learning Outcomes

- Interface external CAN controller via SPI.  
- Configure and use filters/masks for extended-ID frames.  
- Build robust two-node communication with handshaking.  
- Integrate CAN-bus data with human-readable LCD feedback.

---

## 🤝 Further Work

- Add error-status LEDs for bus-off or error-passive conditions.  
- Expand to a three-node network with one logger node.  
- Measure and plot CAN bus throughput or latency on LCD.
