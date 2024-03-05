module BranchLogic(input wire [2:0] funct3, input wire lt, input wire eq, input wire gt, output reg choice);
	always@(*) begin
		case(funct3)
			3'h0: if(eq == 1'b1) choice = 1'b1; //beq
			3'h1: if(eq == 1'b0) choice = 1'b1; //bne
			3'h4: if(lt == 1'b1) choice = 1'b1; //blt
			3'h5: if(gt == 1'b1 || eq == 1'b1) choice = 1'b1; //bge
			3'h6:	if(lt == 1'b1) choice = 1'b1; //bltu
			3'h7: if(gt == 1'b1 || eq == 1'b1) choice = 1'b1; //bgeu
			default: choice = 1'b0;
		endcase
	end
endmodule