module RV32I_EX(input wire [1:0] CTRL_WB_IN, input wire [2:0] CTRL_MEM_IN, input wire [3:0] CTRL_EX_IN, input wire [31:0] PC_IN, input wire [31:0] REG1_IN, input wire [31:0] REG2_IN, input wire [31:0] IMM_IN, input wire [31:0] INST_IN, output wire [1:0] CTRL_WB_OUT, output wire [2:0] CTRL_MEM_OUT, output wire [31:0] PCIMM_OUT, output wire [2:0] COMPARE, output wire [31:0] ALURESULT, output wire [31:0] REG2_OUT, output wire [31:0] INST_OUT, input wire [31:0] EX_MEM_VAL, input wire [31:0] MEM_WB_VAL, input wire [1:0] CTRL_MUX1, input wire [1:0] CTRL_MUX2);
	wire [31:0] ALU_IM;
	wire [31:0] ALU_OPERAND_A;
	wire [31:0] ALU_OPERAND_B;
	
	Mux2 RV32I_ALUMux(.A(REG2_IN), .B(IMM_IN), .select(CTRL_EX_IN[0]), .Out(ALU_IM));
	Mux4 FWD1(.A(REG1_IN), .B(MEM_WB_VAL), .C(EX_MEM_VAL), .D(32'd0), .S(CTRL_MUX1), .OUT(ALU_OPERAND_A));
	Mux4 FWD2(.A(ALU_IM), .B(MEM_WB_VAL), .C(EX_MEM_VAL), .D(32'd0), .S(CTRL_MUX2), .OUT(ALU_OPERAND_B));
	ALU2 RV32I_ALU(.A(ALU_OPERAND_A), .B(ALU_OPERAND_B), .ALUControl(CTRL_EX_IN[3:1]), .Result(ALURESULT), .compare(COMPARE));
	
	assign PCIMM_OUT = PC_IN + IMM_IN;
	assign INST_OUT = INST_IN;
	assign REG2_OUT = REG2_IN;
	assign CTRL_WB_OUT = CTRL_WB_IN;
	assign CTRL_MEM_OUT = CTRL_MEM_IN;
endmodule