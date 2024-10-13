////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

module encoder (
    input clk,
    input rst_n,
    input [ENC_SYM_NUM * EGF_ORDER - 1 : 0] data_in,
    output logic [ENC_SYM_NUM * EGF_ORDER - 1 : 0] data_out
);

    logic [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] enc_data;
    
    logic [$clog2(RS_COD_LEN) - 1 : 0] con_counter;
    logic con_stall;
    
    SEL_PHASE sel_phase;
    logic [$clog2(ENC_SYM_NUM + 1) - 1 : 0] sel_request;
    logic [$clog2(ENC_SYM_NUM) - 1 : 0] sel_offset;
    
    FOR_PHASE for_phase;
    logic [$clog2(ENC_SYM_NUM + 1) - 1 : 0] for_request;
    logic [$clog2(2 * ENC_SYM_NUM - 1) - 1 : 0] for_offset;
    
    logic [2 * ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] buf_data;
    logic [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data;
    logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data;
    logic [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] sel_data;

////////////////////////////////////////////////////////////////////////////////////////////////////

    enc_controller controller (
        .clk(clk),
        .rst_n(rst_n),
        .con_counter(con_counter),
        .con_stall(con_stall),
        .sel_phase(sel_phase),
        .sel_request(sel_request),
        .sel_offset(sel_offset),
        .for_phase(for_phase),
        .for_request(for_request),
        .for_offset(for_offset)
    );
    
    enc_buffer buffer (
        .clk(clk),
        .rst_n(rst_n),
        .con_stall(con_stall),
        .enc_data(enc_data),
        .buf_data(buf_data)
    );
    
    enc_formatter formatter (
        .clk(clk),
        .rst_n(rst_n),
        .for_phase(for_phase),
        .for_request(for_request),
        .for_offset(for_offset),
        .enc_data(enc_data),
        .buf_data(buf_data),
        .for_data(for_data)
    );
    
    enc_processor processor (
        .clk(clk),
        .rst_n(rst_n),
        .for_phase(for_phase),
        .for_data(for_data),
        .pro_data(pro_data)
    );
    
    enc_selector selector (
        .clk(clk),
        .rst_n(rst_n),
        .sel_phase(sel_phase),
        .sel_request(sel_request),
        .sel_offset(sel_offset),
        .enc_data(enc_data),
        .buf_data(buf_data),
        .pro_data(pro_data),
        .sel_data(sel_data)
    );

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            enc_data = '0;
        end else if (!con_stall) begin
            for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
                enc_data[i] <= data_in[(i + 1) * EGF_ORDER - 1 -: EGF_ORDER];
            end
        end else begin
            enc_data <= enc_data;
        end
    end
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            enc_data = '0;
        end else begin
            for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
                data_out[(i + 1) * EGF_ORDER - 1 -: EGF_ORDER] = sel_data[i];
            end
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////