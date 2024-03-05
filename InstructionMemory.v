module InstructionMemory(input wire [31:0] addr, output reg [31:0] data);
	reg [31:0] rom [7:0]; //8 word memory
	
	always@(*) begin
		data = rom[addr[31:2]]; //TODO fix this! we want a byte based indexing scheme here
	end
	
	initial begin
		rom[0] = 32'h00128293; //addi t0, t0, 1
		rom[1] = 32'h00228313; //addi t1, t0, 2
		rom[2] = 32'h00330393; //addi t2, t1, 3
		rom[3] = 32'h00438e13; //addi t3, t2, 4
		rom[4] = 32'd0; //nop
		rom[5] = 32'd0; //nop
		rom[6] = 32'd0; //nop
		rom[7] = 32'd0; //nop
		data = 32'd0;
	end
endmodule