////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_formatter (
    input [$clog2(ENC_SYM_NUM + 1) - 1 : 0] for_request,
    input [$clog2(2 * ENC_SYM_NUM - 1) - 1 : 0] for_offset,
    input [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] enc_data,
    input [2 * ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] buf_data,
    output logic [ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data
);

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        logic [3 * ENC_SYM_NUM - 1 : 0][EGF_ORDER - 1 : 0] for_data_temp;
        for_data_temp = {buf_data, enc_data};
        for (int i = ENC_SYM_NUM - 1; i >= 0; i --) begin
            if (i >= for_request) begin
                for_data[i] = '0;
            end else begin
                for_data[i] = for_data_temp[i + for_offset];
            end
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////