module prng(
    input clk,
    input rst_n,
    input [15:0] seed,
    output reg [15:0] data,
    output reg [15:0] c
);
    reg [15:0] data_next;
    integer i;
    reg reverse_num;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_next <= seed;
            c<=16'h0001;
            i <= 0;
        end
          else if(i==65534) begin
            i <= 0;
            c <= c+16'h0001;
            data <= seed+c;
        end
        else begin
            data_next <= {data_next[14:0], data_next[10] ^ data_next[12] ^ data_next[13] ^ data_next[15]};
            data <= data_next;
            i <= i+1;
        end
    end
endmodule
