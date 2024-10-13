////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef _ENCODER_VH_
`define _ENCODER_VH_

////////////////////////////////////////////////////////////////////////////////////////////////////

//localparam EGF_ORDER = 4;
//localparam logic [EGF_ORDER : 0] EGF_PRI_POL = '{1, 0, 0, 1, 1};

//localparam RS_COR_CAP = 2;
//localparam RS_PAR_LEN = 2 * RS_COR_CAP;
//localparam RS_COD_LEN = 2 ** EGF_ORDER - 1;
//localparam RS_MES_LEN = RS_COD_LEN - RS_PAR_LEN;
//localparam logic [RS_PAR_LEN : 0][EGF_ORDER - 1 : 0] RS_GEN_POL = '{'b0001, 'b1101, 'b1100, 'b1000, 'b0111};

//localparam ENC_SYM_NUM = 4;
//localparam logic [RS_PAR_LEN - 1 : 0][$clog2(RS_COD_LEN) - 1 : 0] ENC_CON_STA = '{'d11, 'd12, 'd13, 'd14};

////////////////////////////////////////////////////////////////////////////////////////////////////

//localparam EGF_ORDER = 4;
//localparam logic [EGF_ORDER : 0] EGF_PRI_POL = '{1, 0, 0, 1, 1};

//localparam RS_COR_CAP = 3;
//localparam RS_PAR_LEN = 2 * RS_COR_CAP;
//localparam RS_COD_LEN = 2 ** EGF_ORDER - 1;
//localparam RS_MES_LEN = RS_COD_LEN - RS_PAR_LEN;
//localparam logic [RS_PAR_LEN : 0][EGF_ORDER - 1 : 0] RS_GEN_POL = '{'b0001, 'b0111, 'b1001, 'b0011, 'b1100, 'b1010, 'b1100};

//localparam ENC_SYM_NUM = 4;
//localparam logic [RS_PAR_LEN - 1 : 0][$clog2(RS_COD_LEN) - 1 : 0] ENC_CON_STA = '{'d7, 'd9, 'd10, 'd11, 'd12, 'd13};

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam EGF_ORDER = 8;
localparam logic EGF_PRI_POL[EGF_ORDER : 0] = '{1, 0, 1, 1, 1, 0, 0, 0, 1};

localparam RS_COR_CAP = 8;
localparam RS_PAR_LEN = 2 * RS_COR_CAP;
localparam RS_COD_LEN = 2 ** EGF_ORDER - 1;
localparam RS_MES_LEN = RS_COD_LEN - RS_PAR_LEN;
localparam logic [RS_PAR_LEN : 0][EGF_ORDER - 1 : 0] RS_GEN_POL = '{'b00000001, 'b01110110, 'b00110100, 'b01100111, 'b00011111, 'b01101000, 'b01111110, 'b10111011, 'b11101000, 'b00010001, 'b00111000, 'b10110111, 'b00110001, 'b01100100, 'b01010001, 'b00101100, 'b01001111};

localparam ENC_SYM_NUM = 4;
localparam logic [RS_PAR_LEN - 1 : 0][$clog2(RS_COD_LEN) - 1 : 0] ENC_CON_STA = '{'d239, 'd240, 'd241, 'd242, 'd243, 'd244, 'd245, 'd246, 'd247, 'd248, 'd249, 'd250, 'd251, 'd252, 'd253, 'd254};

////////////////////////////////////////////////////////////////////////////////////////////////////

localparam SEL_PHA_NUM = 5;
localparam PRO_PHA_NUM = 4;

typedef enum logic [$clog2(SEL_PHA_NUM) - 1 : 0] {
    SEL_IDL,
    SEL_MES,
    SEL_PAR,
    SEL_MTP,
    SEL_PTM
} SEL_PHASE;

typedef enum logic [$clog2(PRO_PHA_NUM) - 1 : 0] {
    PRO_IDL,
    PRO_FIR,
    PRO_NOR,
    PRO_LAS
} PRO_PHASE;

////////////////////////////////////////////////////////////////////////////////////////////////////

`endif

////////////////////////////////////////////////////////////////////////////////////////////////////

