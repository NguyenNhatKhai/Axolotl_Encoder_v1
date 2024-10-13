////////////////////////////////////////////////////////////////////////////////////////////////////

`include "encoder.vh"

////////////////////////////////////////////////////////////////////////////////////////////////////

module enc_controller (
    input clk,
    input rst_n,
    output logic [$clog2(RS_COD_LEN) - 1 : 0] con_counter,
    output logic con_stall,
    output SEL_PHASE sel_phase,
    output logic [$clog2(ENC_SYM_NUM + 1) - 1 : 0] sel_request,
    output logic [$clog2(ENC_SYM_NUM) - 1 : 0] sel_offset,
    output FOR_PHASE for_phase,
    output logic [$clog2(ENC_SYM_NUM + 1) - 1 : 0] for_request,
    output logic [$clog2(2 * ENC_SYM_NUM - 1) - 1 : 0] for_offset
);

    logic con_stall_reg;
    logic [$clog2(ENC_SYM_NUM) - 1 : 0] sel_offset_reg;
    logic [$clog2(2 * ENC_SYM_NUM - 1) - 1 : 0] for_offset_reg;

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            con_counter <= '0;
        end else if (con_counter > RS_COD_LEN - ENC_SYM_NUM) begin
            con_counter <= con_counter + ENC_SYM_NUM - RS_COD_LEN;
        end else begin
            con_counter <= con_counter + ENC_SYM_NUM;
        end
    end
    
////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            con_stall_reg <= '0;
        end else begin
            con_stall_reg <= con_stall;
        end
    end

    always_comb begin
        logic [RS_PAR_LEN - 1 : 0] con_stall_temp;
        for (int i = 0; i < RS_PAR_LEN; i++) begin
            con_stall_temp[i] = (con_counter == ENC_CON_STA[i]);
        end
        con_stall = |con_stall_temp;
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (con_counter == '0) begin
            sel_phase = SEL_IDL;
        end else if (con_counter < ENC_SYM_NUM) begin
            sel_phase = SEL_PTM;
        end else if (con_counter <= RS_MES_LEN) begin
            sel_phase = SEL_MES;
        end else if (con_counter < RS_MES_LEN + ENC_SYM_NUM) begin
            sel_phase = SEL_MTP;
        end else if (con_counter <= RS_COD_LEN) begin
            sel_phase = SEL_PAR;
        end else begin
            sel_phase = SEL_IDL;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (sel_phase == SEL_IDL) begin
            sel_request = '0;
        end else if (sel_phase == SEL_MES) begin
            sel_request = ENC_SYM_NUM;
        end else if (sel_phase == SEL_PAR) begin
            sel_request = '0;
        end else if (sel_phase == SEL_MTP) begin
            sel_request = RS_MES_LEN + ENC_SYM_NUM - con_counter;
        end else if (sel_phase == SEL_PTM) begin
            sel_request = con_counter;
        end else begin
            sel_request = '0;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            sel_offset_reg <= '0;
        end else begin
            sel_offset_reg <= sel_offset;
        end
    end
    
    always_comb begin
        if (con_counter == ENC_SYM_NUM) begin
            sel_offset = '0;
        end else if (sel_phase == SEL_IDL) begin
            sel_offset = '0;
        end else if (con_stall_reg) begin
            sel_offset = sel_offset_reg - sel_request;
        end else begin
            sel_offset = sel_offset_reg + ENC_SYM_NUM - sel_request;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (con_counter < RS_MES_LEN % ENC_SYM_NUM) begin
            for_phase = FOR_IDL;
        end else if (con_counter < ENC_SYM_NUM + RS_MES_LEN % ENC_SYM_NUM) begin
            for_phase = FOR_FIR;
        end else if (con_counter < RS_MES_LEN) begin
            for_phase = FOR_NOR;
        end else if (con_counter < RS_MES_LEN + ENC_SYM_NUM) begin
            for_phase = FOR_LAS;
        end else begin
            for_phase = FOR_IDL;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_comb begin
        if (for_phase == FOR_IDL) begin
            for_request = '0;
        end else if (for_phase == FOR_FIR) begin
            for_request = RS_MES_LEN % ENC_SYM_NUM;
        end else if (for_phase == FOR_NOR) begin
            for_request = ENC_SYM_NUM;
        end else if (for_phase == FOR_LAS) begin
            for_request = ENC_SYM_NUM;
        end else begin
            for_request = '0;
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            for_offset_reg <= '0;
        end else begin
            for_offset_reg <= for_offset;
        end
    end

    always_comb begin
        if (con_counter == ENC_SYM_NUM) begin
            for_offset = ENC_SYM_NUM - RS_MES_LEN % ENC_SYM_NUM;
        end else if (con_stall_reg) begin
            for_offset = for_offset_reg - for_request;
        end else begin
            for_offset = for_offset_reg + ENC_SYM_NUM - for_request;
        end
    end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////