`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:21 11/17/2013 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module vicmidi(reset, clock, r_w, address, data, uart_en, mem_en, io, io_sel, flash_ce, ram_ce, we, oe, uart_ce, ram1,ram2,ram3, blk1, blk2, blk3, blk5, base, bank, midi_txd, midi_rxd, rs232_txd, rs232_rxd, txd, rxd, ser_sel, uart_irq, irq, nmi, uart_reset, led, switch);
inout reset;
input clock;
input r_w;
input [9:0]address;
inout [7:0]data;
input uart_en;
input mem_en;
input [3:2] io;
input io_sel;
output flash_ce;
output ram_ce;
output uart_ce;
output we;
output oe;
input ram1;
input ram2;
input ram3;
input blk1;
input blk2;
input blk3;
input blk5;
input [6:0]base;
output [6:0]bank;

output  midi_txd;
input   midi_rxd;
output  rs232_txd;
input   rs232_rxd;
input   txd;
output  rxd;
input   ser_sel;
input   uart_irq;
output  irq;
output  nmi;
output  uart_reset;

output led;
input [1:0]switch;

wire [7:0] reg_data;
wire reg_data_read;
wire reset_out;
wire data_read;  // we don't use this...

//wire is_uart_addr_valid;

// assigns
assign io_uart = 						(io_sel ? io[3] : io[2]);

assign midi_txd = 					(ser_sel ? 0 : txd);
assign rs232_txd = 					(ser_sel ? txd : rs232_rxd);
assign rxd = 							(ser_sel ? rs232_rxd : midi_rxd);

assign irq = 							(uart_irq ? 0 : 1'bz);  // negate IRQ from RS232
assign nmi = 							1'bz;
//assign reg_base = !(base);
assign reg_base = 0;
assign uart_reset = 					!reset;
assign uart_ce = 						(!uart_en & !io_uart & (address[9:3] == 7'b0)); // active high
//assign uart_ce = (!io_uart & is_uart_addr_valid); // active high

assign reset =                	(!reset_out ? 0 : 1'bz);  // reset_out is active low

assign data = 							(reg_data_read ? reg_data : 8'bz);


MemExpander #(.WIDTH(6))			MemExpander1((mem_en & !uart_ce),  // on except when uart is accessed.
                                              reset, 
                                              reset_out, 
															 clock, 
															 r_w, 
															 address, 
															 data, 
															 reg_data, 
															 reg_data_read, 
															 io, 
															 flash_ce, 
															 ram_ce, 
															 we, 
															 oe, 
															 ram1, 
															 ram2, 
															 ram3, 
															 blk1, 
															 blk2, 
															 blk3, 
															 blk5, 
															 bank[5:0],
															 led,
															 switch,
															 data_read
															);

//comparator #(.WIDTH(7))	uart_address_comp(address[9:3], reg_base, is_uart_addr_valid);

endmodule
