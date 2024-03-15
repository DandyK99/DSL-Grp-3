`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2024 13:07:28
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input rstn,
    input add,
    input clk1hz,
    output  [15:0] bcd_num,
    output led_r,
    output led_o,
    output led_g
    );
reg [31:0] count;         // Counter for time in clock cycles
reg [7:0] seconds;         // Output seconds
reg LEDR;
reg LEDO;
reg LEDG;
assign led_r = LEDR;
assign led_o = LEDO;
assign led_g = LEDG;

always @(posedge clk1hz or negedge rstn) begin
    if (!rstn || count >50) begin
        count <= 0;                // Reset count on reset signal
        seconds <= 8'd30;         // Initialize countdown to 100 seconds
        LEDR <= 0;
        LEDO <= 0;
        LEDG <= 0;
        
    end
    else begin
    if(count< 30) begin
    LEDR <= 1;
        if (add && seconds<8'd25) 
            seconds <= seconds + 5; // Add 5 seconds when the button is pressed
        else if (add && seconds>8'd25)
            seconds <= 8'd30;
        else begin
            seconds <= seconds - 1; // Decrement seconds
        end
    end
    else if(count<35) begin
    
    LEDR <= 0;
    LEDO <= 1;
    end
    else if(count<50) begin
    LEDO <=0;
    LEDG <=1;
    end
    count <= count + 1;          // Increment count
    end
end
//When DIG4 on, BCD Number Display at this moment is bcd_num[3:0];
//When DIG3 on, BCD Number Display at this moment is bcd_num[7:4]; 
//When DIG2 on, BCD Number Display at this moment is bcd_num[11:8];
//When DIG1 on, BCD Number Display at this moment is bcd_num[15:12];
assign  bcd_num[15:12]  = seconds/1000;
assign  bcd_num[11:8]   = (seconds%1000)/100;
assign  bcd_num[7:4]    = (seconds%100)/10;
assign  bcd_num[3:0]    = seconds%10;

endmodule
