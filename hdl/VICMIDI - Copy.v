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

module VICMIDI(reset, clock, r_w, address, data, uart_en, mem_en, io, io_sel, flash_ce, ram_ce, we, oe, uart_ce, ram1,ram2,ram3, blk1, blk2, blk3, blk5, base, bank, midi_txd, midi_rxd, rs232_txd, rs232_rxd, txd, rxd, ser_sel, uart_irq, irq, nmi, uart_reset);
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

wire is_reg_addr_valid;
wire is_uart_addr_valid;
wire ram_ram_en;
wire blk1_ram_en;
wire blk2_ram_en;
wire blk3_ram_en;
wire blk5_ram_en;

wire ram_rom_en;
wire blk1_rom_en;
wire blk2_rom_en;
wire blk3_rom_en;
wire blk5_rom_en;

wire [3:0] cart_config1;
wire [7:0] cart_config2;
wire [7:0] ram_bank;
wire [7:0] blk1_bank;
wire [7:0] blk2_bank;
wire [7:0] blk3_bank;
wire [7:0] blk5_bank;
wire [7:0] reg_data;
wire [9:0] blk_bank;
wire [1:0] blk_address;
wire [7:0] bank_hi_data;
wire [6:0] reg_base;

// assigns
//assign io_uart = (io_sel ? io[3] : io[2]);
assign io_uart = io[3];

assign io_reg = io[2];

assign ram_sel = (!ram1 | !ram2 | !ram3); // active low

assign midi_txd = (ser_sel ? midi_rxd : txd);
assign rs232_txd = (ser_sel ? txd : rs232_rxd);
assign rxd = (ser_sel ? rs232_rxd : midi_rxd);

assign irq = (uart_irq ? 0 : 1'bz);  // negate IRQ from RS232
assign nmi = 1'bz;
assign uart_reset = !reset;


// 00 off
// 01	rom
// 10	ram
// 11 ram no write

assign ram_rom_en  = (cart_config1[1:0] == 'b01);
assign blk1_rom_en = (cart_config2[1:0] == 'b01);
assign blk2_rom_en = (cart_config2[3:2] == 'b01);
assign blk3_rom_en = (cart_config2[5:4] == 'b01);
assign blk5_rom_en = (cart_config2[7:6] == 'b01);

assign ram_ram_en  = (cart_config1[1] == 1);
assign blk1_ram_en = (cart_config2[1] == 1);
assign blk2_ram_en = (cart_config2[3] == 1);
assign blk3_ram_en = (cart_config2[5] == 1);
assign blk5_ram_en = (cart_config2[7] == 1);

assign ram_ram_write_en  = (cart_config1[1:0] == 'b10);
assign blk1_ram_write_en = (cart_config2[1:0] == 'b10);
assign blk2_ram_write_en = (cart_config2[3:2] == 'b10);
assign blk3_ram_write_en = (cart_config2[5:4] == 'b10);
assign blk5_ram_write_en = (cart_config2[7:6] == 'b10);

//assign reg_base = !(base);
assign reg_base = 0;

//assign reg_base = 0;

//assign flash_ce = ! (!mem_en & (((ram_sel & ram_rom_en) | (!blk1 & blk1_rom_en) | (!blk2 & blk2_rom_en) | (!blk3 & blk3_rom_en) | (!blk5 & blk5_rom_en)))); //active low
//assign flash_ce = ! ((((ram_sel & ram_rom_en) | (!blk1 & blk1_rom_en) | (!blk2 & blk2_rom_en) | (!blk3 & blk3_rom_en) | (!blk5 & blk5_rom_en)))); //active low
assign flash_ce = 1;

//assign ram_ce = ! ( !mem_en & (((ram_sel & ram_ram_en) | (!blk1 & blk1_ram_en) | (!blk2 & blk2_ram_en) | (!blk3 & blk3_ram_en) | (!blk5 & blk5_ram_en)))); //active low
assign ram_ce =  !((((ram_sel & ram_ram_en) | (!blk1 & blk1_ram_en) | (!blk2 & blk2_ram_en) | (!blk3 & blk3_ram_en) | (!blk5 & blk5_ram_en)))); //active low


assign we = !(!r_w & ((ram_ram_write_en & ram_sel) | (blk1_ram_write_en & !blk1) | (blk2_ram_write_en & !blk2) | (blk3_ram_write_en & !blk3) | (blk5_ram_write_en & !blk5))); // active low
assign oe = !(r_w);  // active low

//assign reg_ce = (!mem_en & !io_reg & !cart_config1[6] & is_reg_addr_valid); // active high
assign reg_ce = (!io_reg) & is_reg_addr_valid; // active high

//assign uart_ce = (!uart_en & !io_uart & is_uart_addr_valid); // active low
assign uart_ce = (!io_uart & is_uart_addr_valid); // active high

assign reg_write = (!r_w & reg_ce);

assign cart_config1_reg_ce = 	(reg_write & (address[2:0] == 0)); //active high
assign cart_config2_reg_ce = 	(reg_write & (address[2:0] == 1)); //active high
assign bank_hi_reg_ce = 		(reg_write & (address[2:0] == 2)); //active high
assign ram_bank_reg_ce = 		(reg_write & (address[2:0] == 3)); //active high
assign blk1_bank_reg_ce = 		(reg_write & (address[2:0] == 4)); //active high
assign blk2_bank_reg_ce = 		(reg_write & (address[2:0] == 5)); //active high
assign blk3_bank_reg_ce = 		(reg_write & (address[2:0] == 6)); //active high
assign blk5_bank_reg_ce = 		(reg_write & (address[2:0] == 7)); //active high

assign data = (r_w & reg_ce & clock ? reg_data : 8'bz);

reg [1:0]reset_ctr = 2'b0;
always @(negedge clock) 
  begin
    if(cart_config1_reg_ce & data[7])
	   reset_ctr <= 1;
    else if (reset_ctr != 0)
	   reset_ctr <= reset_ctr + 1;
  end
  
assign reset    =                (reset_ctr == 2'b10 ? 0 : 1'bz);
assign reset_in =                (reset_ctr != 0 ? 0 : !reset);


// instances
/*
	Config 1:
	0-1: RAM Config (00 = absent, 01 = ROM, 10 = RAM R/W, 11 = RAM RO)
	3:2: RAM high bank
	4: 0
	5: 0
	6: 0
	7: reset unit - write only
*/
register #(.WIDTH(4))	cart_config1_reg(clock, 0, cart_config1_reg_ce, {data[3:0]}, cart_config1);
/*
	Config 2:
	1-0: BLK1 Config (00 = absent, 01 = ROM, 10 = RAM R/W, 11 = RAM RO) $2000
	3-2: BLK2 Config (00 = absent, 01 = ROM, 10 = RAM R/W, 11 = RAM RO) $4000 
	5-4: BLK3 Config (00 = absent, 01 = ROM, 10 = RAM R/W, 11 = RAM RO) $6000
	7-6: BLK5 Config (00 = absent, 01 = ROM, 10 = RAM R/W, 11 = RAM RO) $a000 // default is BLK5 ROM enabled.
*/
register #(.RESET('b01000000))  cart_config2_reg(clock, reset_in, cart_config2_reg_ce, data, cart_config2);
register #(.WIDTH(8))	        bank_hi_reg(clock, reset_in, bank_hi_reg_ce, data[7:0], bank_hi_data);
register #(.WIDTH(8))	        ram_bank_reg(clock, reset_in, ram_bank_reg_ce, data, ram_bank);
register #(.WIDTH(8))	        blk1_bank_reg(clock, reset_in, blk1_bank_reg_ce, data, blk1_bank);
register #(.WIDTH(8))	        blk2_bank_reg(clock, reset_in, blk2_bank_reg_ce, data, blk2_bank);
register #(.WIDTH(8))	        blk3_bank_reg(clock, reset_in, blk3_bank_reg_ce, data, blk3_bank);
register #(.WIDTH(8))	        blk5_bank_reg(clock, reset_in, blk5_bank_reg_ce, data, blk5_bank);

comparator #(.WIDTH(7))	reg_address_comp(address[9:3], 7'b0, is_reg_addr_valid);
comparator #(.WIDTH(7))	uart_address_comp(address[9:3], reg_base, is_uart_addr_valid);

mux8_1 					   reg_mux(address[2:0], {3'b0,blk5_ram_write_en,cart_config1[3:0]}, cart_config2, bank_hi_data, ram_bank, blk1_bank, blk2_bank, blk3_bank, blk5_bank, reg_data);
mux4_1 #(.WIDTH(10))    blk_bank_mux(blk_address, {bank_hi_data[1:0],blk1_bank}, {bank_hi_data[3:2],blk2_bank}, {bank_hi_data[5:4],blk3_bank}, {bank_hi_data[7:6],blk5_bank}, blk_bank); 
mux2_1 #(.WIDTH(7))     bank_mux(ram_sel, blk_bank[6:0], ram_bank[6:0], bank);

encoder4_2					blk_encoder(!blk1,!blk2,!blk3,!blk5,blk_address);

endmodule
