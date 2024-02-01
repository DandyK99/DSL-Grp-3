`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2024 13:18:24
// Design Name: 
// Module Name: buf_tb
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
reg [2:0] sw;
wire [1:0] led;

top_module i1(sw,led);

initial 
    begin
        sw[0]=0 ; sw[1]=0 ; sw[2]= 0;
        #10 sw[0] =1; sw[1] =0; sw[2] =0;
        #10 sw[0] =0; sw[1] =1; sw[2] =0;
        #10 sw[0] =1; sw[1] =1; sw[2] =0;
        #10 sw[0] =0; sw[1] =0; sw[2] =1;
        #10 sw[0] =1; sw[1] =0; sw[2] =1;
        #10 sw[0]=0; sw[1] =1; sw[2] =1;
        #10 sw[0] =1; sw[1] =1; sw[2] =1;
        
      
        
        
        #10 $stop;
    end
       
        

endmodule
