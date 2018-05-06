`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:00 12/08/2013 
// Design Name: 
// Module Name:    mux 
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

`ifndef _mux_v
`define _mux_v

/*module mux8_4_1(addr, bank1, bank2, bank3, bank4, q);
input [1:0]addr;
input [7:0]bank1;
input [7:0]bank2;
input [7:0]bank3;
input [7:0]bank4;
output [7:0] q;
reg [7:0] q;

always @*
	case (addr)
	  0 : q = bank1;
	  1 : q = bank2;
	  2 : q = bank3;
	  3 : q = bank4;
	endcase

endmodule
*/
module mux2_1(addr, d0, d1, q);

parameter WIDTH = 8;

input addr;
input [WIDTH-1:0]d0;
input [WIDTH-1:0]d1;
output [WIDTH-1:0] q;

wire [WIDTH-1:0] tbl [0:1];

assign tbl[0] = d0;
assign tbl[1] = d1;

assign q = tbl[addr];
endmodule

module mux4_1(addr, d0, d1, d2, d3, q);

parameter WIDTH = 8;

input [1:0]addr;
input [WIDTH-1:0]d0;
input [WIDTH-1:0]d1;
input [WIDTH-1:0]d2;
input [WIDTH-1:0]d3;
output [WIDTH-1:0] q;

wire [WIDTH-1:0] tbl [0:3];

assign tbl[0] = d0;
assign tbl[1] = d1;
assign tbl[2] = d2;
assign tbl[3] = d3;

assign q = tbl[addr];
endmodule

module mux8_1(addr, d0, d1, d2, d3, d4, d5, d6, d7, q);

parameter WIDTH = 8;

input [2:0]addr;
input [WIDTH-1:0]d0;
input [WIDTH-1:0]d1;
input [WIDTH-1:0]d2;
input [WIDTH-1:0]d3;
input [WIDTH-1:0]d4;
input [WIDTH-1:0]d5;
input [WIDTH-1:0]d6;
input [WIDTH-1:0]d7;
output [WIDTH-1:0] q;

wire [WIDTH-1:0] tbl [0:7];

assign tbl[0] = d0;
assign tbl[1] = d1;
assign tbl[2] = d2;
assign tbl[3] = d3;
assign tbl[4] = d4;
assign tbl[5] = d5;
assign tbl[6] = d6;
assign tbl[7] = d7;

assign q = tbl[addr];
endmodule

/*
module module mux (#parameter  WIDTH           = 8,
            #parameter  CHANNELS        = 4) (

    input   [(CHANNELS*WIDTH)-1:0]      in_bus,
    input   [clogb2(CHANNELS-1)-1:0]    sel,   

    output  [WIDTH-1:0]                 out
    );

integer i;
    
reg     [WIDTH-1:0] input_array [0:CHANNELS-1];

assign  out = input_array[sel];

always @*
    for(i=0; i<CHANNELS; i=i+1)
        input_array[i] = in_bus[(i*WIDTH)+:WIDTH];


//define the clogb2 function
function integer clogb2;
  input depth;
  integer i,result;
  begin
    for (i = 0; 2 ** i < depth; i = i + 1)
      result = i + 1;
    clogb2 = result;
  end
endfunction

endmodule
*/

`endif