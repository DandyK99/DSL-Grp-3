module top_module(
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
        output pio48,
        output [1:0] led,
        input vp_in,
        input vn_in,
        input [1:0] xa_n,
        input [1:0] xa_p,
        input uart_txd_in,    // UART transmitter input signal
        output uart_rxd_out  // UART receiver output signal
);
// LED configuration to display UART TX and RX activity
assign led[0] = uart_rxd_out;
assign led[1] = uart_txd_in;

wire rstn,start;
assign rstn = ~btn[1];
assign start = ~btn[0];
wire CLK500Hz,CLK1Hz;

// UART clock
wire clk_uart, clk_tx_event, clk_data_proc;
clock_div clock_div_u0(
    .clkout(clk_uart),
    .rstn(rstn),
    .clksrc(sysclk)
);
defparam clock_div_u0.FREQ_INPUT = 12_000_000; // Input frequency to the clock divider
defparam clock_div_u0.FREQ_OUTPUT = 9_600;     // Output frequency for UART operations

// Clock for TX event
clock_div clock_div_u1(
    .clkout(clk_tx_event),
    .rstn(rstn),
    .clksrc(sysclk)
);
defparam clock_div_u1.FREQ_INPUT = 12_000_000; // Input frequency
defparam clock_div_u1.FREQ_OUTPUT = 4;       // Output frequency for TX event timing

// Clock for data processing
clock_div clock_div_u3(
    .clkout(clk_data_proc),
    .rstn(rstn),
    .clksrc(sysclk)
);
defparam clock_div_u3.FREQ_INPUT = 12_000_000; // Input frequency
defparam clock_div_u3.FREQ_OUTPUT = 2;       // Output frequency for data processing

clock_div clk_div_u1(rstn,sysclk,CLK500Hz);
clock_div clk_div_u2(rstn,CLK500Hz,CLK1Hz);
clock_div clk_div_u3(rstn,CLK500Hz,CLK10Hz);
defparam clk_div_u1.FREQ_INPUT  = 12_000_000;
defparam clk_div_u1.FREQ_OUTPUT = 500;
defparam clk_div_u2.FREQ_INPUT  = 500;
defparam clk_div_u2.FREQ_OUTPUT = 1;
defparam clk_div_u3.FREQ_INPUT  = 500;
defparam clk_div_u3.FREQ_OUTPUT = 10;

// UART protocol instance for transmitting data with parameter configuration for parity
localparam UART_PARITY = 1'b0; // Parity configuration, 0 for even parity
reg uart_tx_ready;
wire uart_tx_vaild;
reg [7:0] uart_tx_data;

// reg [7:0] display_buffer;
reg [15:0] Segment_data;
drv_segment segment_u0(rstn,CLK500Hz,Segment_data,{pio43,pio46,pio47,pio37},{pio40,pio38,pio45,pio42,pio41,pio39,pio48,pio44});

localparam PIN15_ADDR = 8'h14;  //VAUX4;
localparam PIN16_ADDR = 8'h1C;  //VAUX12;

wire enable;                     //enable into the xadc to continuosly get data out
reg [6:0] Address_in = 7'h14;    //Adress of register in XADC drp corresponding to data
wire ready;                      //XADC port that declares when data is ready to be taken
wire [15:0] ADC_data;                //XADC data   
wire [15:0] random_num;
        
xadc_wiz_0 xadc_u0
(
    .daddr_in(PIN16_ADDR),        // Address bus for the dynamic reconfiguration port
    .dclk_in(sysclk),             // Clock input for the dynamic reconfiguration port
    .den_in(enable),              // Enable Signal for the dynamic reconfiguration port
    .di_in(0),                    // Input data bus for the dynamic reconfiguration port
    .dwe_in(0),                   // Write Enable for the dynamic reconfiguration port
    .vauxp12(xa_p[1]),
    .vauxn12(xa_n[1]),
    .vauxp4(xa_p[0]),
    .vauxn4(xa_n[0]),  
    .busy_out(),                 // ADC Busy signal
    .channel_out(),              // Channel Selection Outputs
    .do_out(ADC_data),           // Output data bus for dynamic reconfiguration port
    .drdy_out(ready),            // Data ready signal for the dynamic reconfiguration port
    .eoc_out(enable),            // End of Conversion Signal
    .vp_in(vp_in),               // Dedicated Analog Input Pair
    .vn_in(vn_in)
);

prng prng_u0(CLK1Hz,rstn,ADC_data,random_num);

reg [15:0] cnter;
reg odd;
always @(negedge rstn or posedge clk_data_proc) begin
    if (!rstn) begin
        cnter <= 8'h00;
        uart_tx_data <= 8'h00;
        odd <= 1'b0;
    end else begin
        odd <= ~odd;
        //cnter = 16'h1111;
        cnter <= random_num; //Allow you to transmit number to PC; 
        uart_tx_data <= !odd ? cnter[15:8] : cnter[7:0];
        //cnter <= odd ? cnter + 1'b1 : cnter;
        //You can replace cnter with your random number generator;
        //e.g. a 16 bits wire [15:0] rng_number;
           
    end
end

// Control logic for UART transmission readiness based on TX event clock and reset signal
always @(posedge clk_tx_event or negedge rstn) begin
    if (!rstn) begin
        uart_tx_ready <= 1'b0;
    end else begin
        if (uart_tx_vaild) begin
            uart_tx_ready <= 1'b0;
        end else begin
            uart_tx_ready <= 1'b1;
        end
    end
end

uart_tx uart_tx_u0(
    .clk(clk_uart),
    .ap_rstn(rstn),
    .ap_ready(uart_tx_ready),
    .ap_vaild(uart_tx_vaild),
    .tx(uart_rxd_out),
    .pairty(UART_PARITY),
    .data(uart_tx_data)
);

always @(posedge CLK1Hz) begin
    Segment_data <= random_num;
    
end

endmodule