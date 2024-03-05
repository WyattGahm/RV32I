module RV32I_MEM(input wire [1:0] CTRL_WB_IN, input wire [2:0] CTRL_MEM_IN, input wire [31:0] PCIMM_IN, input wire [2:0] COMPARE_IN, input wire [31:0] ALURESULT_IN, input wire [31:0] REG2_IN, input wire [31:0] INST_IN, output wire [1:0] CTRL_WB_OUT, output wire [31:0] MEM_OUT, output wire [31:0] ALURESULT_OUT, output wire [31:0] INST_OUT, output wire [31:0] PCIMM_OUT, output wire [0:0] PCSRC_OUT);
	//CTRL_MEM_IN = {Branch, MEMREAD,MEMWRITE}
	wire [0:0] IM_BRANCH;
	
	DataMemory RV32I_DataMemory(	.addr(ALURESULT_IN), 
											.data(REG2_IN), 
											.MemRead(CTRL_MEM_IN[1]), 
											.MemWrite(CTRL_MEM_IN[0]), 
											.out(MEM_OUT));
	BranchLogic RV32I_BranchLogic(.lt(COMPARE_IN[2]), 
											.eq(COMPARE_IN[1]), 
											.gt(COMPARE_IN[0]),
											.funct3(INST_IN[14:12]),
											.choice(IM_BRANCH));
	assign INST_OUT = INST_IN;
	assign ALURESULT_OUT = ALURESULT_IN;
	assign PCSRC_OUT = IM_BRANCH & CTRL_MEM_IN[2];
	assign PCIMM_OUT = PCIMM_IN;
	assign CTRL_WB_OUT = CTRL_WB_IN;
endmodule