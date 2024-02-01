`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 18:12:23
// Design Name: 
// Module Name: full_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module full_adder(sw,led);

input [2:0] sw;
output [1:0] led;

assign led[0]= sw[0]^sw[1]^sw[2];
assign led[1]= (sw[0]& sw[1]) | ((sw[0] ^ sw[1]) & sw[2]);

endmodule
