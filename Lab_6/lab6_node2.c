//===============================================================================
// File:    lab6_node2.c
// Purpose: CAN-bus slave node: receive from node 1, increment and echo back.
// Platform: PIC16F877A @ 8 MHz XT
// Toolchain: MikroC PRO for PIC
// Source:  University of Science and Technology Mohamed Boudiaf, Oran, Algeria
//          Faculty of Electrical Engineering, Electronics Department
//          Master’s in Embedded Systems Electronics
//          Original lab conducted in French :contentReference[oaicite:8]{index=8}:contentReference[oaicite:9]{index=9}
–=============================================================================

#include "CANSPI.h"
#include "LCD.h"           // MikroC PRO LCD library

// CAN flags and data buffer
unsigned char Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned char Rx_Data_Len;
char    RxTx_Data[8];
char    Msg_Rcvd;

// Node IDs
const long ID_1st = 12111, ID_2nd = 3;  // master=node1, slave=node2
long Rx_ID;

// MCP2515 SPI interface lines
sbit CanSpi_CS            at RC0_bit;
sbit CanSpi_CS_Direction  at TRISC0_bit;
sbit CanSpi_Rst           at RC2_bit;
sbit CanSpi_Rst_Direction at TRISC2_bit;

void main() {
    // Initialize I/O
    PORTB = 0;  TRISB = 0;          // PORTB outputs for data & LCD

    // Same flag setup as node1
    Can_Send_Flags = _CANSPI_TX_PRIORITY_0 
                   & _CANSPI_TX_XTD_FRAME 
                   & _CANSPI_TX_NO_RTR_FRAME;
    Can_Init_Flags = _CANSPI_CONFIG_SAMPLE_THRICE 
                   & _CANSPI_CONFIG_PHSEG2_PRG_ON 
                   & _CANSPI_CONFIG_XTD_MSG 
                   & _CANSPI_CONFIG_DBL_BUFFER_ON 
                   & _CANSPI_CONFIG_VALID_XTD_MSG 
                   & _CANSPI_CONFIG_LINE_FILTER_OFF;

    // Initialize SPI1 & MCP2515
    SPI1_Init();
    CANSPIInitialize(1,3,3,3,1, Can_Init_Flags);

    // Configure to accept only node1’s ID
    CANSPISetOperationMode(_CANSPI_MODE_CONFIG, 0xFF);
    CANSPISetMask   (_CANSPI_MASK_B1, -1, _CANSPI_CONFIG_XTD_MSG);
    CANSPISetMask   (_CANSPI_MASK_B2, -1, _CANSPI_CONFIG_XTD_MSG);
    CANSPISetFilter (_CANSPI_FILTER_B2_F3, ID_1st, _CANSPI_CONFIG_XTD_MSG);
    CANSPISetOperationMode(_CANSPI_MODE_NORMAL, 0xFF);

    // Initialize LCD
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1,1,"Node 2: Waiting");

    while (1) {
        // Read any incoming frame
        Msg_Rcvd = CANSPIRead(&Rx_ID, RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);
        if (Msg_Rcvd && (Rx_ID == ID_1st)) {
            // Show on PORTB
            PORTB = RxTx_Data[0];
            // And on LCD
            char buf[17];
            sprintf(buf, "Rx from N1: %u", RxTx_Data[0]);
            Lcd_Out(2,1, buf);

            // Increment and send back
            RxTx_Data[0]++;
            Delay_ms(10);
            CANSPIWrite(ID_2nd, RxTx_Data, 1, Can_Send_Flags);
        }
    }
}
