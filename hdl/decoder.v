`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:06 12/15/2013 
// Design Name: 
// Module Name:    decoder 
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
module decoder3_8 ( x, y);

input [2:0] x;
output [7:0] y;

reg [7:0] y;

always @ (x)
begin
	case(x)
		0: y = 'b00000001;
		1: y = 'b00000010;
		2: y = 'b00000100;
		3: y = 'b00001000;
		4: y = 'b00010000;
		5: y = 'b00100000;
		6: y = 'b01000000;
		7: y = 'b10000000;
	endcase
end
endmodule
