module testbench(output err);
	reg clk = 0;
	always #10 clk = ~clk;
	
	RV32I DUT(.clk(clk));
endmodule