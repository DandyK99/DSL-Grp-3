`timescale 1ns / 1ps
module top_module(sw,led);
input [2:0] sw;
output [1:0] led;

assign led[1]=1'b1;
// assign
assign led[0]= (sw[0] & sw[1]) || sw[2];

endmodule
