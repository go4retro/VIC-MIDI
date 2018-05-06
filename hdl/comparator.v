`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:11:01 12/14/2013 
// Design Name: 
// Module Name:    comparator 
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
`ifndef _comparator_v
`define _comparator_v
module comparator (a, b, equal);
parameter WIDTH = 8 ;

input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
output equal;

  assign equal = (a == b);
endmodule
`endif