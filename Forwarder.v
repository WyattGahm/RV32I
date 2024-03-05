module Forwarder(input wire [31:0] ID_EX_INST, input wire EX_MEM_REGWRITE, input wire [31:0] EX_MEM_INST, input wire MEM_WB_REGWRITE, input wire [31:0] MEM_WB_INST, output reg [1:0] FWD_A, output reg [1:0] FWD_B);
	//ID/EX
	wire [4:0] ID_EX_RD;
	wire [4:0] ID_EX_RS1;
	wire [4:0] ID_EX_RS2;
	assign ID_EX_RD = ID_EX_INST[11:7];
	assign ID_EX_RS1 = ID_EX_INST[19:15];
	assign ID_EX_RS2 = ID_EX_INST[24:20];
	//EX/MEM
	wire [4:0] EX_MEM_RD;
	wire [4:0] EX_MEM_RS1;
	wire [4:0] EX_MEM_RS2;
	assign EX_MEM_RD = EX_MEM_INST[11:7];
	assign EX_MEM_RS1 = EX_MEM_INST[19:15];
	assign EX_MEM_RS2 = EX_MEM_INST[24:20];
	//MEM/WB
	wire [4:0] MEM_WB_RD;
	wire [4:0] MEM_WB_RS1;
	wire [4:0] MEM_WB_RS2;
	assign MEM_WB_RD = MEM_WB_INST[11:7];
	assign MEM_WB_RS1 = MEM_WB_INST[19:15];
	assign MEM_WB_RS2 = MEM_WB_INST[24:20];
	
	
	//logic stolen from Kit
	always@(*) begin
		FWD_A = 2'b00;
		FWD_B = 2'b00;
		//mem stage fwd
		if(MEM_WB_REGWRITE == 1'b1) begin
			if(MEM_WB_RD != 5'd0) begin
				if(EX_MEM_REGWRITE == 1'b1 && EX_MEM_RD != 5'd0 && EX_MEM_RD == ID_EX_RS1) begin
					//forwarding would cause a conflict regardless
				end else begin
					if(MEM_WB_RD == ID_EX_RS1) begin
						FWD_A = 2'b01;
					end
				end
				if(EX_MEM_REGWRITE == 1'b1 && EX_MEM_RD != 5'd0 && EX_MEM_RD == ID_EX_RS2) begin
					//forwarding would cause a conflict regardless
				end else begin
					if(MEM_WB_RD == ID_EX_RS2) begin
						FWD_B = 2'b01;
					end
				end
			end
		end
		//ex stage fwd
		if(EX_MEM_REGWRITE == 1'b1) begin
			if(EX_MEM_RD != 5'd0) begin
				if(EX_MEM_RD == ID_EX_RS1) begin
					FWD_A = 2'b10;
				end
				if(EX_MEM_RD == ID_EX_RS2) begin
					FWD_B = 2'b10;
				end
			end
		end
	end
	//HAZARD? WHEN DO WE RESET FWD MUX CTRL VALS
	
	initial begin
		FWD_A = 2'b00;
		FWD_B = 2'b00;
	end
	
endmodule