module RV32I_WB(input wire [1:0] CTRL_WB_IN, input wire [31:0] MEM_IN, input wire [31:0] ALURESULT_IN, input wire [31:0] INST_IN, output wire [0:0] CTRL_RegWrite_OUT, output wire [31:0] INST_OUT, output wire [31:0] DATA_OUT);
	//CTRL_WB_IN = {regwrite, memtoReg}
	assign DATA_OUT = (CTRL_WB_IN[0] == 1) ? MEM_IN : ALURESULT_IN;
	assign CTRL_RegWrite_OUT = CTRL_WB_IN[1];
	assign INST_OUT = INST_IN;
endmodule