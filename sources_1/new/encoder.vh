////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef _ENCODER_VH_
`define _ENCODER_VH_

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam EGF_ORDER = 4;
localparam logic [EGF_ORDER : 0] EGF_PRI_POL = '{1, 0, 0, 1, 1};

////////////////////////////////////////////////////////////////////////////////////////////////////

//localparam RS_COR_CAP = 2;
localparam RS_COR_CAP = 3;

localparam RS_PAR_LEN = 2 * RS_COR_CAP;
localparam RS_COD_LEN = 2 ** EGF_ORDER - 1;
localparam RS_MES_LEN = RS_COD_LEN - RS_PAR_LEN;

//localparam logic [RS_PAR_LEN : 0][EGF_ORDER - 1 : 0] RS_GEN_POL = '{'b0001, 'b1101, 'b1100, 'b1000, 'b0111};
localparam logic [RS_PAR_LEN : 0][EGF_ORDER - 1 : 0] RS_GEN_POL = '{'b0001, 'b0111, 'b1001, 'b0011, 'b1100, 'b1010, 'b1100};

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam ENC_SYM_NUM = 4;

//localparam logic [RS_PAR_LEN - 1 : 0][$clog2(RS_COD_LEN) - 1 : 0] ENC_CON_STA = '{'d11, 'd12, 'd13, 'd14};
localparam logic [RS_PAR_LEN - 1 : 0][$clog2(RS_COD_LEN) - 1 : 0] ENC_CON_STA = '{'d7, 'd9, 'd10, 'd11, 'd12, 'd13};

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam SEL_PHA_NUM = 5;
localparam FOR_PHA_NUM = 4;

typedef enum logic [$clog2(SEL_PHA_NUM) - 1 : 0] {
    SEL_IDL,
    SEL_MES,
    SEL_PAR,
    SEL_MTP,
    SEL_PTM
} SEL_PHASE;

typedef enum logic [$clog2(FOR_PHA_NUM) - 1 : 0] {
    FOR_IDL,
    FOR_FIR,
    FOR_NOR,
    FOR_LAS
} FOR_PHASE;

////////////////////////////////////////////////////////////////////////////////////////////////////

`endif

////////////////////////////////////////////////////////////////////////////////////////////////////

