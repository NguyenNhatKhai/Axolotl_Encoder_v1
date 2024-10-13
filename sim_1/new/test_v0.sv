////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
localparam CLOCK_TICK = 5;
localparam CLOCK_MARGIN = 1;

////////////////////////////////////////////////////////////////////////////////////////////////////

module test();

    logic clk;
    logic rst_n;
    logic [ENC_SYM_NUM * EGF_ORDER - 1 : 0] data_in;
    logic [ENC_SYM_NUM * EGF_ORDER - 1 : 0] data_out;
    
    encoder test (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    initial begin
        clk = 0;
        forever #CLOCK_TICK clk = ~clk;
    end
    
    initial begin
        rst_n <= #(0 * CLOCK_TICK) 0;
        rst_n <= #(21 * CLOCK_TICK + CLOCK_MARGIN) 1;
    end

    initial begin
        #(20 * CLOCK_TICK + CLOCK_MARGIN);
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(2 * CLOCK_TICK) data_in = 16'b0000000100100011;
        #(2 * CLOCK_TICK) data_in = 16'b0100010101100111;
        #(2 * CLOCK_TICK) data_in = 16'b1000100110101011;
        #(2 * CLOCK_TICK) data_in = 16'b1100110111101111;
        #(100 * CLOCK_TICK) $finish;
    end   

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////