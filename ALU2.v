module ALU2(input wire [31:0] A, input wire [31:0] B, input wire [2:0] ALUControl, output reg [31:0] Result, output wire [2:0] compare);
	always@(*) begin
		case(ALUControl)
			3'b000: Result = A + B;
			3'b001: Result = A - B;
			3'b010: Result = A & B;
			3'b011: Result = A | B;
			3'b100: Result = A ^ B;
			3'b101: Result = A << B[4:0];
			3'b110: Result = A >> B[4:0];
			3'b111: Result = A >>> B;
			default: Result = 32'd0;
		endcase
	end
	
	assign compare = {A < B, A == B, A > B};
	
	initial Result = 32'd0;
endmodule