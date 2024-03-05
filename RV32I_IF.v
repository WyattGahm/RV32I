module RV32I_IF(input clk, input wire [31:0] PCIMM_IN, input wire [0:0] CTRL_PCSRC_IN, output wire [31:0] PC_OUT, output wire [31:0] INST_OUT);
	reg [31:0] PC = 32'd0;
	wire [31:0] PC_NEW;
	InstructionMemory RV32I_InstructionMemory(.addr(PC), .data(INST_OUT));
	Mux2 PCMUX(.A(PC + 32'd4),.B(PCIMM_IN), .select(CTRL_PCSRC_IN), .Out(PC_NEW));
	always@(posedge clk) begin
		PC <= PC_NEW;
	end
	assign PC_OUT = PC;
endmodule