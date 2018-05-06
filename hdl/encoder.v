`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:56:44 12/15/2013 
// Design Name: 
// Module Name:    encoder 
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
module encoder4_2 ( x0 ,x1 ,x2 ,x3 ,y );

input x0,x1,x2,x3;
output [1:0]y ;

assign y[0] = x1 | x3;
assign y[1] = x2 | x3;

endmodule
