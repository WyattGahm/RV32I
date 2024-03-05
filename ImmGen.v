module ImmGen(input wire [31:0] code, output reg [31:0] value);
	always@(*) begin
		case(code[6:0])
			7'b0110111:begin
				value = {code[31:12], 12'd0}; //U type (LUI)
			end
			7'b0010111:begin
				value = {code[31:12], 12'd0}; //U type (AUIPC)
			end
			7'b0010011:begin
				if(code[14:12] == 3'h3) begin
					value = {20'd0, code[31:20]};//I, zero extended
				end else begin
					value = {{20{code[31]}}, code[31:20]};//I, msb extended
				end
			end
			7'b0000011:begin
				if(code[14:12] == 3'h4 || code[14:12] == 3'h5) begin
					value = {20'd0, code[31:20]};//I, zero extended
				end else begin
					value = {{20{code[31]}}, code[31:20]};//I, msb extended
				end
			end
			7'b0100011: begin
				value = {{20{code[31]}}, code[31:25], code[11:7]};//S, msb extended
			end
			7'b1100011: begin
				if(code[14:12] == 3'h6 || code[14:12] == 3'h7) begin
					value = {19'd0, code[31], code[7], code[30:25], code[11:8], 1'b0};//B, zero extended
				end else begin
					value = {{19{code[31]}}, code[31], code[7], code[30:25], code[11:8], 1'b0};//B, msb extended
				end				
			end
			7'b1101111: value = {{11{code[31]}}, code[31], code[19:12], code[20], code[30:21], 1'b0}; //J msb extended
			default: value = 32'd0;
		endcase
	end
endmodule