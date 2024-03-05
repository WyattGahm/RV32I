module RV32I_ID(	input wire [0:0] CTRL_RegWrite_IN, 
						input wire [4:0] RD_IN, 
						input wire [31:0] DATA_IN, 
						input wire [31:0] PC_IN, 
						input wire [31:0] INST_IN, 
						output wire [1:0] CTRL_WB_OUT, 
						output wire [2:0] CTRL_MEM_OUT, 
						output wire [3:0] CTRL_EX_OUT, 
						output wire [31:0] PC_OUT, 
						output wire [31:0] REG1_OUT, 
						output wire [31:0] REG2_OUT, 
						output wire [31:0] IMM_OUT, 
						output wire [31:0] INST_OUT);
						
	Registers RV32I_Registers(	//.clk(clk),
										.read1(INST_IN[19:15]), 
										.read2(INST_IN[24:20]), 
										.write(RD_IN), 
										.write_data(DATA_IN), 
										.out1(REG1_OUT), 
										.out2(REG2_OUT), 
										.RegWrite(CTRL_RegWrite_IN));
	
	ImmGen RV32I_ImmGen(	.code(INST_IN), .value(IMM_OUT));
	//CTRL_EX = {ALUControl, ALUSrc}
	//CTRL_MEM_IN = {Branch, MEMREAD,MEMWRITE}
	//CTRL_WB_IN = {regwrite, memtoReg}
	Control RV32I_Control(	.opcode(INST_IN[6:0]), 
									.funct3(INST_IN[14:12]), 
									.funct7(INST_IN[31:25]), 
									.Branch(CTRL_MEM_OUT[2]), 
									.MemRead(CTRL_MEM_OUT[1]), 
									.MemtoReg(CTRL_WB_OUT[0]), 
									.ALUOp(CTRL_EX_OUT[3:1]), 
									.MemWrite(CTRL_MEM_OUT[0]), 
									.ALUSrc(CTRL_EX_OUT[0]), 
									.RegWrite(CTRL_WB_OUT[1]));
	assign PC_OUT = PC_IN;
	assign INST_OUT = INST_IN;
endmodule