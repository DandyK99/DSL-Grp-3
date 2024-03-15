`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2024 11:59:47
// Design Name: 
// Module Name: top_module
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


module top_module(
        input sysclk,
        input [1:0] btn,
        output pio34,//LED
        output pio35,//LED
        output pio36,//LED
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
        output pio48,
        output [1:0] led
    );
    
wire rstn;
wire add;
assign rstn = ~btn[1];
assign add = btn[0];
wire CLK500Hz,CLK50Hz,CLK1Hz;
wire [15:0] bcd_tim;

clock_tree clk_tree_u0(
    .CLK12MHZ(sysclk),
    .rstn(rstn),
    .CLK500Hz(CLK500Hz),
    .CLK1Hz(CLK1Hz) 
);
reg addr;
always @(posedge CLK500Hz)
addr <= add;

stopwatch stopwatch_u0(rstn,addr,CLK1Hz,bcd_tim,pio34,pio35,pio36);

Segment segment_u0(rstn,CLK500Hz,bcd_tim,{pio43,pio46,pio47,pio37},{pio40,pio38,pio45,pio42,pio41,pio39,pio48,pio44});

assign led[0] = CLK1Hz;
assign led[1] = ~CLK1Hz;

endmodule
