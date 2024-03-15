`timescale 1ns / 1ps

module stopwatch_tb;

    // Parameters
    parameter CLK_PERIOD = 2; // Clock period in ns

    // Signals
    reg rstn;
    reg add;
    reg clk1hz;
    wire [15:0] bcd_num;
    wire led_r;
    wire led_o;
    wire led_g;

    // Instantiate the stopwatch module
    stopwatch stopwatch_inst (
        .rstn(rstn),
        .add(add),
        .clk1hz(clk1hz),
        .bcd_num(bcd_num),
        .led_r(led_r),
        .led_o(led_o),
        .led_g(led_g)
    );

    // Clock generation
    always #((CLK_PERIOD / 2)) clk1hz = ~clk1hz;

    // Initial values
    initial begin
        // Initialize inputs
        rstn = 1;
        add = 0;
        clk1hz = 0;

        // Reset
        #10;
        rstn = 0;
        #10;
        rstn = 1;

        // Test scenario
        // Add 5 seconds
        #100;
        add = 1;
        #10;
        add = 0;

        // Wait for the stopwatch to count
        #400;

        // Assertion: Verify the BCD numbers are correctly updated
        $display("BCD Number: %d", bcd_num);
        assert(bcd_num == 16'b0011_0010_0000_0000) // Expected: 5200

        // Add more time
        #100;
        add = 1;
        #10;
        add = 0;

        // Wait for the stopwatch to count
        #400;

        // Assertion: Verify the BCD numbers are correctly updated
        $display("BCD Number: %d", bcd_num);
        assert(bcd_num == 16'b0011_1000_0000_0000) // Expected: 8000

        // Add more time than allowed
        #100;
        add = 1;
        #10;
        add = 0;

        // Wait for the stopwatch to count
        #400;

        // Assertion: Verify the BCD numbers are correctly updated
        $display("BCD Number: %d", bcd_num);
        assert(bcd_num == 16'b0011_1000_0000_0000) // Expected: 8000 (No change)

        // Finish simulation
        #100;
        $finish;
    end

endmodule