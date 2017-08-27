module testbed;

	// == TEST BED FOR REGFILE ==

	reg [7:0] A;
	wire [7:0] B, C; 
	reg [2:0] in_adrr;
	reg [2:0] out_adrr1;
	reg [2:0] out_adrr2;
	reg clk = 1'b1;

	regFile8x8a m_reg(clk, in_adrr, A, out_adrr1, B, out_adrr2, C);

	initial
	begin	
		
		A=8'd7;
		in_adrr = 3'b000;
		out_adrr1 = 3'b000;
		out_adrr2 = 3'b001;
		#5 clk = 1'b0;
		#5 clk = 1'b1;

		in_adrr = 3'b001;
		A=8'd2;
		#5 clk = 1'b0;
		#5 clk = 1'b1;


		$display("B = %b" , B);
		$display("C = %b" , C);
		$finish;	
		
	end

endmodule

module regFile8x8a (
	input clk,    // Clock
	input [2:0] INaddr, // 
	input [7:0] IN,  // 
	input [2:0] OUT1addr,
	output [7:0] OUT1,
	input [2:0] OUT2addr,
	output [7:0] OUT2
);

reg [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

assign OUT1 = OUT1addr == 0 ? reg0 :
			  OUT1addr == 1 ? reg1 :
			  OUT1addr == 2 ? reg2 :
			  OUT1addr == 3 ? reg3 :
			  OUT1addr == 4 ? reg4 :
			  OUT1addr == 5 ? reg5 :
			  OUT1addr == 6 ? reg6 :
			  OUT1addr == 7 ? reg7 :
			  0;

assign OUT2 = OUT2addr == 0 ? reg0 :
			  OUT2addr == 1 ? reg1 :
			  OUT2addr == 2 ? reg2 :
			  OUT2addr == 3 ? reg3 :
			  OUT2addr == 4 ? reg4 :
			  OUT2addr == 5 ? reg5 :
			  OUT2addr == 6 ? reg6 :
			  OUT2addr == 7 ? reg7 :
			  0;

always @(negedge clk) 
begin
	case (INaddr)
		3'b000:reg0 = IN;
		3'b001:reg1 = IN;
		3'b010:reg2 = IN;
		3'b011:reg3 = IN;
		3'b100:reg4 = IN;
		3'b101:reg5 = IN;
		3'b110:reg6 = IN;
		3'b111:reg7 = IN;
	endcase
end

endmodule