module RV32I(input wire clk);
	reg [3:0] stall = 4'b0000;
	
	//IF
	//out
	wire [31:0] IF_PC_OUT;
	wire [31:0] IF_INST_OUT;
	
	// ID
	//in
	reg [31:0] ID_PC_IN;
	reg [31:0] ID_INST_IN;
	//out
	wire [1:0] ID_CTRL_WB_OUT;
	wire [2:0] ID_CTRL_MEM_OUT;
	wire [3:0] ID_CTRL_EX_OUT;
	wire [31:0] ID_PC_OUT;
	wire [31:0] ID_REG1_OUT;
	wire [31:0] ID_REG2_OUT;
	wire [31:0] ID_IMM_OUT;
	wire [31:0] ID_INST_OUT;
	
	//EX
	//in
	reg [1:0] EX_CTRL_WB_IN;
	reg [2:0] EX_CTRL_MEM_IN;
	reg [3:0] EX_CTRL_EX_IN;
	reg [31:0] EX_PC_IN;
	reg [31:0] EX_REG1_IN;
	reg [31:0] EX_REG2_IN;
	reg [31:0] EX_IMM_IN;
	reg [31:0] EX_INST_IN;
	//out
	wire [1:0] EX_CTRL_WB_OUT;
	wire [2:0] EX_CTRL_MEM_OUT;
	wire [31:0] EX_PCIMM_OUT;
	wire [2:0] EX_COMPARE_OUT;
	wire [31:0] EX_ALURESULT_OUT;
	wire [31:0] EX_REG2_OUT;
	wire [31:0] EX_INST_OUT;
	
	//MEM
	//in
	reg [1:0] MEM_CTRL_WB_IN;
	reg [2:0] MEM_CTRL_MEM_IN;
	reg [31:0] MEM_PCIMM_IN;
	reg [2:0] MEM_COMPARE_IN;
	reg [31:0] MEM_ALURESULT_IN;
	reg [31:0] MEM_REG2_IN;
	reg [31:0] MEM_INST_IN;
	//out
	wire [1:0] MEM_CTRL_WB_OUT;
	wire [31:0] MEM_DATA_OUT;
	wire [31:0] MEM_ALURESULT_OUT;
	wire [31:0] MEM_INST_OUT;
	wire [31:0] MEM_PCIMM_OUT;
	wire [0:0] MEM_PCSRC_OUT;

	//WB
	//in
	reg [1:0] WB_CTRL_WB_IN;
	reg [31:0] WB_MEM_DATA_IN;
	reg [31:0] WB_ALURESULT_IN;
	reg [31:0] WB_INST_IN;
	//out
	wire [0:0] WB_CTRL_RegWrite_OUT;
	wire [31:0] WB_INST_OUT;
	wire [31:0] WB_DATA_OUT;
	
	//FWD
	wire [1:0] FWD_A_SELECT;
	wire [1:0] FWD_B_SELECT;	


	RV32I_IF InstructionFetch(	.clk(clk), 
										.PCIMM_IN(MEM_PCIMM_OUT), 
										.CTRL_PCSRC_IN(MEM_PCSRC_OUT), 
										.PC_OUT(IF_PC_OUT), 
										.INST_OUT(IF_INST_OUT));
	
	
	RV32I_ID InstructionDecode(.CTRL_RegWrite_IN(WB_CTRL_RegWrite_OUT),
										.RD_IN(WB_INST_OUT[11:7]), 
										.DATA_IN(WB_DATA_OUT), 
										.PC_IN(ID_PC_IN), 
										.INST_IN(ID_INST_IN), 
										.CTRL_WB_OUT(ID_CTRL_WB_OUT), 
										.CTRL_MEM_OUT(ID_CTRL_MEM_OUT),
										.CTRL_EX_OUT(ID_CTRL_EX_OUT),
										.PC_OUT(ID_PC_OUT), 
										.REG1_OUT(ID_REG1_OUT), 
										.REG2_OUT(ID_REG2_OUT), 
										.IMM_OUT(ID_IMM_OUT), 
										.INST_OUT(ID_INST_OUT));
	
	
	
	RV32I_EX Execute(	.CTRL_WB_IN(EX_CTRL_WB_IN), 
							.CTRL_MEM_IN(EX_CTRL_MEM_IN), 
							.CTRL_EX_IN(EX_CTRL_EX_IN), 
							.PC_IN(EX_PC_IN), 
							.REG1_IN(EX_REG1_IN), 
							.REG2_IN(EX_REG2_IN), 
							.IMM_IN(EX_IMM_IN), 
							.INST_IN(EX_INST_IN), 
							.CTRL_WB_OUT(EX_CTRL_WB_OUT), 
							.CTRL_MEM_OUT(EX_CTRL_MEM_OUT), 
							.PCIMM_OUT(EX_PCIMM_OUT), 
							.COMPARE(EX_COMPARE_OUT), 
							.ALURESULT(EX_ALURESULT_OUT), 
							.REG2_OUT(EX_REG2_OUT), 
							.INST_OUT(EX_INST_OUT),
							.EX_MEM_VAL(MEM_ALURESULT_IN),
							.MEM_WB_VAL(WB_DATA_OUT),
							.CTRL_MUX1(FWD_A_SELECT),
							.CTRL_MUX2(FWD_B_SELECT));
	
	
	RV32I_MEM Memory(	.CTRL_WB_IN(MEM_CTRL_WB_IN), 
							.CTRL_MEM_IN(MEM_CTRL_MEM_IN), 
							.PCIMM_IN(MEM_PCIMM_IN), //should this even go into memory?
							.COMPARE_IN(MEM_COMPARE_IN), 
							.ALURESULT_IN(MEM_ALURESULT_IN), 
							.REG2_IN(MEM_REG2_IN), 
							.INST_IN(MEM_INST_IN), 
							.CTRL_WB_OUT(MEM_CTRL_WB_OUT), 
							.MEM_OUT(MEM_DATA_OUT), 
							.ALURESULT_OUT(MEM_ALURESULT_OUT), 
							.INST_OUT(MEM_INST_OUT), 
							.PCIMM_OUT(MEM_PCIMM_OUT), //NEEDED???
							.PCSRC_OUT(MEM_PCSRC_OUT));
	
	
	RV32I_WB Writeback(	.CTRL_WB_IN(WB_CTRL_WB_IN), 
								.MEM_IN(WB_MEM_DATA_IN), 
								.ALURESULT_IN(WB_ALURESULT_IN), 
								.INST_IN(WB_INST_IN), 
								.CTRL_RegWrite_OUT(WB_CTRL_RegWrite_OUT), 
								.INST_OUT(WB_INST_OUT), 
								.DATA_OUT(WB_DATA_OUT));
	
	Forwarder RV32I_FWD(	.ID_EX_INST(EX_INST_IN), 
								.EX_MEM_REGWRITE(MEM_CTRL_WB_IN[1]), 
								.EX_MEM_INST(MEM_INST_IN), 
								.MEM_WB_REGWRITE(WB_CTRL_RegWrite_OUT), 
								.MEM_WB_INST(WB_INST_IN), 
								.FWD_A(FWD_A_SELECT), 
								.FWD_B(FWD_B_SELECT));
		
	always@(posedge clk) begin
		{ID_PC_IN, ID_INST_IN} <= (stall[0] == 0) ? {IF_PC_OUT, IF_INST_OUT} : 0;
		{EX_CTRL_WB_IN, EX_CTRL_MEM_IN, EX_CTRL_EX_IN, EX_PC_IN, EX_REG1_IN, EX_REG2_IN, EX_IMM_IN, EX_INST_IN} <= (stall[1] == 0) ? {ID_CTRL_WB_OUT, ID_CTRL_MEM_OUT, ID_CTRL_EX_OUT, ID_PC_OUT, ID_REG1_OUT, ID_REG2_OUT, ID_IMM_OUT, ID_INST_OUT} : 0;
		{MEM_CTRL_WB_IN, MEM_CTRL_MEM_IN, MEM_PCIMM_IN, MEM_COMPARE_IN, MEM_ALURESULT_IN, MEM_REG2_IN, MEM_INST_IN} <= (stall[2] == 0) ? {EX_CTRL_WB_OUT, EX_CTRL_MEM_OUT, EX_PCIMM_OUT, EX_COMPARE_OUT, EX_ALURESULT_OUT, EX_REG2_OUT, EX_INST_OUT} : 0;
		{WB_CTRL_WB_IN, WB_MEM_DATA_IN, WB_ALURESULT_IN, WB_INST_IN} <= (stall[3] == 0) ? {MEM_CTRL_WB_OUT, MEM_DATA_OUT, MEM_ALURESULT_OUT, MEM_INST_OUT} : 0;
	end
	
	initial begin
		{ID_PC_IN, ID_INST_IN} = 0;
		{EX_CTRL_WB_IN, EX_CTRL_MEM_IN, EX_CTRL_EX_IN, EX_PC_IN, EX_REG1_IN, EX_REG2_IN, EX_IMM_IN, EX_INST_IN} = 0;
		{MEM_CTRL_WB_IN, MEM_CTRL_MEM_IN, MEM_PCIMM_IN, MEM_COMPARE_IN, MEM_ALURESULT_IN, MEM_REG2_IN, MEM_INST_IN} = 0;
		{WB_CTRL_WB_IN, WB_MEM_DATA_IN, WB_ALURESULT_IN, WB_INST_IN} = 0;
	end
endmodule
/*
Branch prediction:
-BNE often taken
-running log of prev decisions
alternative idea:
-keep a saturating counter, T inc, N dec...

*/