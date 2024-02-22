`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2024 18:16:53
// Design Name: 
// Module Name: top_tb
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


module top_tb();

    reg clk;
    reg btnR;    //BTNR - RESET System;
    reg btnL;      //BTNP - Pause System;
    wire [6:0] seg;// 7-Segment - Segment[6:0];
    wire dp;      // 7-Segment - Segment-DP;
    wire [3:0] an; // 7-Segment - Common Anode;

top_module i1(clk,btnR,btnL,seg,dp,an);
   
    initial clk=0; always #5 clk=!clk;
    initial
            begin 
            btnR=0; btnL=0;
            #100000000 btnR=0; btnL=1;
            #100000000  btnR=1; btnL=0;
            #100000000  btnR=0; btnL=1;
            #15 $stop;
            #15 $finish; 
            end
endmodule