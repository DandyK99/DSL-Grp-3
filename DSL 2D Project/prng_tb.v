`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2024 13:13:12
// Design Name: 
// Module Name: prng_tb
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


module prng_tb();
reg clk;
reg rstn;
reg [15:0]seed;
wire[15:0]data;
wire [15:0]c;

prng prng_u0(clk,rstn,seed,data,c);


initial begin
    seed <= 16'ha16f;
    clk =0;
    rstn =0;
end

always begin
    #1 clk=!clk;
end
integer fp;
initial begin 
    fp = $fopen("prng.txt","w");
    $fmonitor(fp,"0x%04h",data);
    #5 rstn = 1;
    #2000000 $stop;
    $fclose(fp);
    $finish;
end

endmodule
