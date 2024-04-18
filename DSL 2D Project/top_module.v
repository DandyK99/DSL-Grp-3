`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Singapore University of Tech and Design
// Engineer: Xiang Maoyang 
// Create Date: 11/27/2023 11:09:18 AM
// Design Name: 
// Module Name: Top Module
// Project Name: Stop Watch
// Target Devices: CMOD A7 FPGA BOARD
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////
module top_module(
        input seed,
        input sysclk,
        input [1:0] btn,
        output pio37,
        output pio38,
        output pio39,
        output pio40,
        output pio41,
        output pio42,
        output pio43,
        output pio44,
        output pio45,
        output pio46,
        output pio47,
        output pio48

);
      
wire rstn;
assign rstn = ~btn[1];
wire plusn;
assign plusn = ~btn[0];
wire CLK500Hz,CLK50Hz,CLK1Hz;
wire [15:0] data;

clock_tree clk_tree_u0(
    .CLK12MHZ(sysclk),
    .rstn(rstn),
    .plusn(plusn),
    .CLK500Hz(CLK500Hz),
    .CLK1Hz(CLK1Hz) 
);

prng prng_u0(CLK1Hz,rstn,seed,data);

segment segment_u0(rstn,CLK500Hz,data,{pio43,pio46,pio47,pio37},{pio40,pio38,pio45,pio42,pio41,pio39,pio48,pio44});


endmodule

