////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_selector (
    input clk,
    input rst_n,
    input SEL_PHASE sel_phase,
    input [$clog2(ENC_SYM_NUM + 1) - 1 : 0] sel_request,
    input [$clog2(ENC_SYM_NUM) - 1 : 0] sel_offset,
    input [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] enc_data,
    input [2 * ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] buf_data,
    input [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data,
    output logic [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] sel_data
);

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        logic [3 * ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] sel_data_temp;
        sel_data_temp = {buf_data, enc_data};
        if (sel_phase == SEL_MES) begin
            sel_data = sel_data_temp[ENC_SYM_NUM - 1 + sel_offset -: ENC_SYM_NUM];
        end else if (sel_phase == SEL_PAR) begin
            sel_data = pro_data[RS_PAR_LEN - 1 -: ENC_SYM_NUM];
        end else if (sel_phase == SEL_MTP) begin
            for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
                if (i >= ENC_SYM_NUM - sel_request) begin
                    sel_data[i] = sel_data_temp[i + sel_offset + sel_request - ENC_SYM_NUM];
                end else begin
                    sel_data[i] = pro_data[i + sel_request + RS_PAR_LEN - ENC_SYM_NUM];
                end
            end
        end else if (sel_phase == SEL_PTM) begin
            for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
                if (i >= sel_request) begin
                    sel_data[i] = pro_data[i + RS_PAR_LEN - ENC_SYM_NUM];
                end else begin
                    sel_data[i] = sel_data_temp[i + sel_offset];
                end
            end
        end else begin
            sel_data = '0;
        end
    end

endmodule
    
////////////////////////////////////////////////////////////////////////////////////////////////////