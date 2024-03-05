module RV32I_IF_ID(input clk, input [31:0] PC_IF, input [31:0] INST_IF, output [31:0] PC_ID, output [31:0] INST_ID);
	initial begin 
		PC_ID = 32'd0;
		INST_ID = 32'd0;
	end
	
	always@(posedge clk) begin
		//logic to flush pipeline???
		PC_ID <= PC_IF;
		INST_ID <= INST_IF;
	end
endmodule