module Mux4(input wire [31:0] A, input wire [31:0] B, input wire [31:0] C, input wire [31:0] D, input wire [1:0] S, output reg [31:0] OUT);
	always@(*) begin
		case(S)
			2'b00: OUT = A;
			2'b01: OUT = B;
			2'b10: OUT = C;
			2'b11: OUT = D;
		endcase
	end
	
	initial OUT = 32'd0;
endmodule