`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:22 11/07/2015 
// Design Name: 
// Module Name:    MemExpander 
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
module MemExpander(enable, reset_in, reset_out, clock, r_w, address, data_in, reg_data, reg_data_read, io, flash_ce, ram_ce, we, oe, ram1, ram2, ram3, blk1, blk2, blk3, blk5, bank, led, switch, data_read);
parameter WIDTH = 10 ;
parameter MEMEXPANDER_ID = 0;

parameter LO_WIDTH = (WIDTH > 8 ? 8 : WIDTH);
parameter HI_WIDTH = (WIDTH > 8 ? WIDTH - 8 : 1); // really should be 0, but then HI_WIDTH-1 = -1, which messes things up.
parameter TOP_BIT_WIDTH = (WIDTH < 8 ? 8 - WIDTH : 0);

input enable;
input reset_in;
output reset_out;
input clock;
input r_w;
input [9:0]address;
input [7:0]data_in;
output [7:0]reg_data;
output reg_data_read;
input [3:2]io;
output flash_ce;
output ram_ce;
output we;
output oe;
input ram1;
input ram2;
input ram3;
input blk1;
input blk2;
input blk3;
input blk5;
output [WIDTH-1:0]bank;
output led;
input [1:0]switch;
output data_read;

wire ram_ram_en;
wire io2_ram_en;
wire io3_ram_en;
wire blk1_ram_en;
wire blk2_ram_en;
wire blk3_ram_en;
wire blk5_ram_en;

wire ram_rom_en;
wire io2_rom_en;
wire io3_rom_en;
wire blk1_rom_en;
wire blk2_rom_en;
wire blk3_rom_en;
wire blk5_rom_en;

wire ram_write_en;
wire io2_write_en;
wire io3_write_en;
wire blk1_write_en;
wire blk2_write_en;
wire blk3_write_en;
wire blk5_write_en;

wire regs_hidden;
wire unhide_regs;
wire [5:0] cart_config1;
wire [7:0] cart_config2;
wire [LO_WIDTH-1:0] ram_bank_lo;
wire [HI_WIDTH-1:0] ram_bank_hi;
wire [LO_WIDTH-1:0] io_bank_lo;
wire [HI_WIDTH-1:0] io_bank_hi;
wire [LO_WIDTH-1:0] blk1_bank_lo;
wire [HI_WIDTH-1:0] blk1_bank_hi;
wire [LO_WIDTH-1:0] blk2_bank_lo;
wire [HI_WIDTH-1:0] blk2_bank_hi;
wire [LO_WIDTH-1:0] blk3_bank_lo;
wire [HI_WIDTH-1:0] blk3_bank_hi;
wire [LO_WIDTH-1:0] blk5_bank_lo;
wire [HI_WIDTH-1:0] blk5_bank_hi;

wire [7:0] reg_data_lo;
wire [7:0] reg_data_hi;

wire [WIDTH-1:0] blk_bank;
wire [WIDTH-1:0] blk_io_bank;
wire [1:0] blk_address;


// assigns
assign ram_sel = (!ram1 | !ram2 | !ram3); // active high
assign io_sel = (!io[2] | !io[3]); // active high

// 00 off
// 01	rom
// 10	ram no write
// 11 ram

assign ram_rom_en  = 			(cart_config1[1:0] == 1);
assign io2_rom_en  = 			(cart_config1[3:2] == 1);
assign io3_rom_en  = 			(cart_config1[5:4] == 1);
assign blk1_rom_en = 			(cart_config2[1:0] == 1);
assign blk2_rom_en = 			(cart_config2[3:2] == 1);
assign blk3_rom_en = 			(cart_config2[5:4] == 1);
assign blk5_rom_en = 			(cart_config2[7:6] == 1);

assign ram_ram_en  = 			(cart_config1[1] == 1);
assign io2_ram_en  = 			(cart_config1[3] == 1);
assign io3_ram_en  = 			(cart_config1[5] == 1);
assign blk1_ram_en = 			(cart_config2[1] == 1);
assign blk2_ram_en = 			(cart_config2[3] == 1);
assign blk3_ram_en = 			(cart_config2[5] == 1);
assign blk5_ram_en = 			(cart_config2[7] == 1);

assign ram_write_en  = 			(cart_config1[0] == 1);
assign io2_write_en  = 			(cart_config1[2] == 1);
assign io3_write_en  = 			(cart_config1[4] == 1);
assign blk1_write_en = 			(cart_config2[0] == 1);
assign blk2_write_en = 			(cart_config2[2] == 1);
assign blk3_write_en = 			(cart_config2[4] == 1);
assign blk5_write_en = 			(cart_config2[6] == 1);

assign reg_ce =               (enable & !regs_hidden & !io[3] & (address[9:4] == 'b111111)); // active high

assign flash_ce = 				!(enable
                                & ((ram_sel & ram_rom_en) 
											  | (!io[2] & io2_rom_en) 
											  | (!reg_ce & !io[3] & io3_rom_en) // carve out for cart registers
											  | (!blk1 & blk1_rom_en) 
											  | (!blk2 & blk2_rom_en) 
											  | (!blk3 & blk3_rom_en) 
											  | (!blk5 & blk5_rom_en)
											 )
										  ); //active low
assign ram_ce =  					!(enable 
										  & ((ram_sel & ram_ram_en)
                                   | (!io[2] & io2_ram_en)
											  | (!reg_ce & !io[3] & io3_ram_en) // carve out for cart registers
											  | (!blk1 & blk1_ram_en)
											  | (!blk2 & blk2_ram_en)
											  | (!blk3 & blk3_ram_en)
											  | (!blk5 & blk5_ram_en)
											 )
										 ); //active low
assign we = 						!(clock 
                                & !r_w
                                & ((ram_write_en & ram_sel)
										     | (io2_write_en & !io[2])
											  | (io3_write_en & !io[3])
											  | (blk1_write_en & !blk1)
											  | (blk2_write_en & !blk2)
											  | (blk3_write_en & !blk3)
											  | (blk5_write_en & !blk5)
										    )
										  ); // active low
assign oe = 						!(r_w);  // active low

assign reg_write = (!r_w & reg_ce);
assign data_read = !oe & (!flash_ce | !ram_ce);
assign reg_data_read = r_w & reg_ce & clock;

assign cart_config0_reg_ce = 	   (reg_write & (address[3:0] == 0)); //active high
assign cart_config1_reg_ce = 	   (reg_write & (address[3:0] == 1)); //active high
assign cart_config2_reg_ce = 	   (reg_write & (address[3:0] == 2)); //active high
assign ram_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 4)); //active high
assign io_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 6)); //active high
assign blk1_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 8)); //active high
assign blk2_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 10)); //active high
assign blk3_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 12)); //active high
assign blk5_bank_reg_lo_ce = 		(reg_write & (address[3:0] == 14)); //active high

reg [1:0]reset_ctr = 2'b0;
always @(negedge clock) 
  begin
    if(cart_config0_reg_ce & data_in[6])
	   reset_ctr <= 1;
    else if (reset_ctr != 0)
	   reset_ctr <= reset_ctr + 1;
  end
  
assign reset_out =              	(reset_ctr == 2'b10 ? 0 : 1);
assign reset_reg =               (reset_ctr != 0 ? 0 : !reset_in);

// instances
/*
	Config 0:
	0: LED (R/W)
	1: switch 0 (RO)
	2: switch 1 (RO)
	6: soft_reset (WO)
	7: Hide registers (WO)
*/
register #(.WIDTH(1))				cart_config0_led_reg(clock, reset_reg, cart_config0_reg_ce, data_in[0], led);

assign unhide_reg_ce = 	         (!io[3] & r_w & (address[9:8] == 'b11)); //active high
wire [1:0]state;
fsm                              fsm1(clock & unhide_reg_ce, reset_reg, address[7:0], state);
assign unhide_regs =             (unhide_reg_ce & clock & (state == 3));

register #(.WIDTH(1))				cart_config0_hide_reg(clock, reset_reg | unhide_regs, cart_config0_reg_ce, data_in[7], regs_hidden);


/*
	Config 1:
	0-1: RAM Config (00 = absent, 01 = ROM, 10 = RAM R/O, 11 = RAM R/W) $0400,$0800,$0C00
	3-2: IO2 Config
	5-4: IO3 Config
*/
register #(.WIDTH(6))				cart_config1_reg(clock, reset_reg, cart_config1_reg_ce, data_in[5:0], cart_config1);
/*
	Config 2:
	1-0: BLK1 Config (00 = absent, 01 = ROM, 10 = RAM R/O, 11 = RAM R/W) $2000
	3-2: BLK2 Config (00 = absent, 01 = ROM, 10 = RAM R/O, 11 = RAM R/W) $4000 
	5-4: BLK3 Config (00 = absent, 01 = ROM, 10 = RAM R/O, 11 = RAM R/W) $6000
	7-6: BLK5 Config (00 = absent, 01 = ROM, 10 = RAM R/O, 11 = RAM R/W) $a000 // default is BLK5 ROM enabled.
*/
register #(.WIDTH(7))				cart_config2_reg(clock, reset_reg, cart_config2_reg_ce, {data_in[7],data_in[5:0]}, {cart_config2[7],cart_config2[5:0]});

reg autostart;
assign cart_config2[6] = autostart;

always @ (negedge clock, posedge reset_reg)
  begin
  if(reset_reg)
		autostart <= switch[0];
  else if( cart_config2_reg_ce)
	   autostart <= data_in[6];
  end

register #(.WIDTH(LO_WIDTH), .RESET(1))				ram_bank_reg_lo(clock, reset_reg, ram_bank_reg_lo_ce, data_in, ram_bank_lo);
generate
  if(WIDTH > 8)
  begin
    assign ram_bank_reg_hi_ce = 			(reg_write & (address[3:0] == 5)); //active high
	 register #(.WIDTH(HI_WIDTH))					ram_bank_reg_hi(clock, reset_reg, ram_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], ram_bank_hi);
  end
  else
    assign ram_bank_hi = 0;
endgenerate	 
register #(.WIDTH(LO_WIDTH), .RESET(2))				io_bank_reg_lo(clock, reset_reg, io_bank_reg_lo_ce, data_in, io_bank_lo);
generate
  if(WIDTH > 8)
 begin
    assign io_bank_reg_hi_ce = 			(reg_write & (address[3:0] == 7)); //active high
    register #(.WIDTH(HI_WIDTH))					io_bank_reg_hi(clock, reset_reg, io_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], io_bank_hi);
  end
  else
    assign io_bank_hi = 0;
endgenerate
register #(.WIDTH(LO_WIDTH), .RESET(3))				blk1_bank_reg_lo(clock, reset_reg, blk1_bank_reg_lo_ce, data_in, blk1_bank_lo);
generate
  if(WIDTH > 8)
  begin
    assign blk1_bank_reg_hi_ce = 		(reg_write & (address[3:0] == 9)); //active high
    register #(.WIDTH(HI_WIDTH))					blk1_bank_reg_hi(clock, reset_reg, blk1_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], blk1_bank_hi);
  end
  else
    assign blk1_bank_hi = 0;
endgenerate
register #(.WIDTH(LO_WIDTH), .RESET(4))				blk2_bank_reg_lo(clock, reset_reg, blk2_bank_reg_lo_ce, data_in, blk2_bank_lo);
generate
  if(WIDTH > 8)
  begin
    assign blk2_bank_reg_hi_ce = 		(reg_write & (address[3:0] == 11)); //active high
    register #(.WIDTH(HI_WIDTH))					blk2_bank_reg_hi(clock, reset_reg, blk2_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], blk2_bank_hi);
  end
  else
    assign blk2_bank_hi = 0;
endgenerate
register #(.WIDTH(LO_WIDTH), .RESET(5))				blk3_bank_reg_lo(clock, reset_reg, blk3_bank_reg_lo_ce, data_in, blk3_bank_lo);
generate
  if(WIDTH > 8)
  begin
    assign blk3_bank_reg_hi_ce = 		(reg_write & (address[3:0] == 13)); //active high
    register #(.WIDTH(HI_WIDTH))					blk3_bank_reg_hi(clock, reset_reg, blk3_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], blk3_bank_hi);
  end
  else
    assign blk3_bank_hi = 0;
endgenerate
register #(.WIDTH(LO_WIDTH))				blk5_bank_reg_lo(clock, reset_reg, blk5_bank_reg_lo_ce, data_in, blk5_bank_lo);
generate
  if(WIDTH > 8)
  begin
    assign blk5_bank_reg_hi_ce = 		(reg_write & (address[3:0] == 15)); //active high
    register #(.WIDTH(HI_WIDTH))					blk5_bank_reg_hi(clock, reset_reg, blk5_bank_reg_hi_ce, data_in[HI_WIDTH-1:0], blk5_bank_hi);
  end
  else
    assign blk5_bank_hi = 0;
endgenerate

mux8_1 					            		reg_lo_mux(address[2:0],
														        {switch[1], switch[0], led}, 
																  cart_config1, 
														        cart_config2, 
														        MEMEXPANDER_ID, 
														        {{(TOP_BIT_WIDTH){1'b0}},ram_bank_lo}, 
														        ram_bank_hi, 
														        {{(TOP_BIT_WIDTH){1'b0}},io_bank_lo}, 
														        io_bank_hi, 
														        reg_data_lo
														       );

generate
  if(WIDTH > 8)
  begin
  mux8_1 					            		reg_hi_mux(address[2:0],
                                                  blk1_bank_lo, 
														        blk1_bank_hi, 
														        blk2_bank_lo, 
														        blk2_bank_hi, 
														        blk3_bank_lo, 
														        blk3_bank_hi, 
														        blk5_bank_lo,
														        blk5_bank_hi, 
														        reg_data_hi
														       );
  end
  else
  begin
  
    wire [WIDTH-1:0]reg_data_hi_lo;
    mux4_1 #(.WIDTH(WIDTH))           		reg_hi_mux(address[2:1],
                                                     blk1_bank_lo, 
														           blk2_bank_lo,
														           blk3_bank_lo, 
														           blk5_bank_lo,
														           reg_data_hi_lo
														          );
    mux2_1 #(.WIDTH(WIDTH))  				   reg_hi_mux2(address[0],reg_data_hi_lo, 0, reg_data_hi);
	 
   /* mux8_1 #(.WIDTH(WIDTH))            	reg_hi_mux(address[2:0],
                                                  blk1_bank_lo, 
														        0,
														        blk2_bank_lo, 
														        0, 
														        blk3_bank_lo, 
														        0, 
														        blk5_bank_lo,
														        0, 
														        reg_data_hi
														       );*/
  end
endgenerate

mux2_1   				            			reg_mux(address[3],reg_data_lo, {{(TOP_BIT_WIDTH){1'b0}}, reg_data_hi}, reg_data);

mux4_1 #(.WIDTH(WIDTH))            			blk_bank_mux(blk_address, 
                                                       {blk1_bank_hi,blk1_bank_lo}, 
																		 {blk2_bank_hi,blk2_bank_lo}, 
																		 {blk3_bank_hi,blk3_bank_lo}, 
																		 {blk5_bank_hi,blk5_bank_lo}, 
																		 blk_bank
																		); 
mux2_1 #(.WIDTH(WIDTH))            			blk_io_bank_mux(io_sel, 
																			 blk_bank, 
																			 {io_bank_hi, io_bank_lo}, 
																			 blk_io_bank
																			);
mux2_1 #(.WIDTH(WIDTH))            			bank_mux(ram_sel, 
																	blk_io_bank, 
																	{ram_bank_hi,ram_bank_lo}, 
																	bank
																  );

encoder4_2					        				blk_encoder(!blk1,!blk2,!blk3,!blk5,blk_address);


endmodule

module fsm(clock, reset, data, state);

output reg [1:0] state;
input clock;
input [7:0] data;
input reset;

always @(negedge clock, posedge reset)
begin
  if(reset)
		state <= 0;
  else
  begin
		case(state)
			0:
				if(data == 8'h55)
					state <= 1;
			1:
				if(data == 8'haa)
					state <= 2;
				else
					state <= 0;
			2:
				if(data == 8'h01)
					state <= 3;
				else
					state <= 0;
			default:
				state <= 0;
		endcase
	end
end
endmodule

