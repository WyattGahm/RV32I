module Mux2(input [31:0] A, input [31:0] B, input [0:0] select, output [31:0] Out);
	assign Out = (select == 1'b0) ? A : B; 
endmodule