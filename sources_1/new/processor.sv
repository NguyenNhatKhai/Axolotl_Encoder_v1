////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

function logic [EGF_ORDER - 1 : 0] egf_mul (
    input [EGF_ORDER - 1 : 0] data_in_0,
    input [EGF_ORDER - 1 : 0] data_in_1
);

    logic redundant_bit;
    logic [EGF_ORDER - 1 : 0] returned_data;
    redundant_bit = '0;
    returned_data = '0;

    for (int i = 0; i < EGF_ORDER; i ++) begin
        redundant_bit = returned_data[EGF_ORDER - 1];
        for (int j = EGF_ORDER - 1; j >= 0; j --) begin
            returned_data[j] = returned_data[j - 1] ^ (redundant_bit & EGF_PRI_POL[j]) ^ (data_in_0[j] & data_in_1[EGF_ORDER - i - 1]);
        end
        returned_data[0] = (redundant_bit & EGF_PRI_POL[0]) ^ (data_in_0[0] & data_in_1[EGF_ORDER - i - 1]);
    end
    
    return returned_data;

endfunction

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_pro_partly (
    input [RS_MES_LEN % ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data,
    output logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_partly
);

    always_comb begin
        logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_temp;
        pro_data_temp = '0;
        for (int i = RS_MES_LEN % ENC_SYM_NUM - 1; i >= 0; i --) begin
            for (int j = RS_PAR_LEN - 1; j > 0; j --) begin
                pro_data_partly[j] = pro_data_temp[j - 1] ^ egf_mul(for_data[i] ^ pro_data_temp[RS_PAR_LEN - 1], RS_GEN_POL[j]);
            end
            pro_data_partly[0] = egf_mul(for_data[i] ^ pro_data_temp[RS_PAR_LEN - 1], RS_GEN_POL[0]);
            for (int j = RS_PAR_LEN - 1; j >= 0; j --) begin
                pro_data_temp[j] = pro_data_partly[j];
            end
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_pro_fully (
    input [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data,
    input [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_reg,
    output logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_fully
);

    always_comb begin
        logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_temp;
        pro_data_temp = pro_data_reg;
        for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
            for (int j = RS_PAR_LEN - 1; j > 0; j --) begin
                pro_data_fully[j] = pro_data_temp[j - 1] ^ egf_mul(for_data[i] ^ pro_data_temp[RS_PAR_LEN - 1], RS_GEN_POL[j]);
            end
            pro_data_fully[0] = egf_mul(for_data[i] ^ pro_data_temp[RS_PAR_LEN - 1], RS_GEN_POL[0]);
            for (int j = RS_PAR_LEN - 1; j >= 0; j --) begin
                pro_data_temp[j] = pro_data_fully[j];
            end
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_processor (
    input clk,
    input rst_n,
    input PRO_PHASE pro_phase,
    input [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data,
    output logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data
);

    logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_reg;
    logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_partly;
    logic [RS_PAR_LEN - 1 : 0][EGF_ORDER - 1 : 0] pro_data_fully;

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            pro_data_reg <= '0;
        end else begin
            pro_data_reg <= pro_data;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    enc_pro_partly partly (
        .for_data(for_data[RS_MES_LEN % ENC_SYM_NUM - 1 : 0]),
        .pro_data_partly (pro_data_partly)
    );

    enc_pro_fully fully (
        .for_data(for_data),
        .pro_data_reg(pro_data_reg),
        .pro_data_fully(pro_data_fully)
    );

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (pro_phase == PRO_FIR) begin
            pro_data = pro_data_partly;
        end else if (pro_phase == PRO_NOR) begin
            pro_data = pro_data_fully;
        end else if (pro_phase == PRO_LAS) begin
            pro_data = pro_data_fully;
        end else begin
            pro_data = pro_data_reg;
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////