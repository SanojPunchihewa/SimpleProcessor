module testbed;

	// == TESTBED FOR INSTRUCTION REGISTER ==

	reg clk;
	reg [2:0] Read_Addr;
	wire [31:0] instruction; 

	regInstructions myRegInstr(clk, Read_Addr, instruction);

	initial
	begin
		
		clk = 1'b0;
		Read_Addr = 3'b000;
		$monitor("Read_Addr = %b => instr = %b", Read_Addr, instruction);
		
	end

	always #1 clk = ~clk;
	
	initial
	begin
		#5 $finish;
	end

endmodule

module regInstructions (
	input clk,    
	input [2:0] Read_Addr, 
	output [31:0] instruction
	
);

reg [31:0] instruction;

				   //  00000000							op_code
				   // 		   00000000					destination
				   //   			   00000000			source 2
				   //  			     	       00000000	source 1
reg [31:0] step1 = 32'b00001000000001000000000011111111;		// loadi 4, X, 0xFF
reg [31:0] step2 = 32'b00001000000001100000000010101010;		// loadi 6, X, 0xAA
reg [31:0] step3 = 32'b00001000000000110000000010111011;		// loadi 3, X, 0xBB
reg [31:0] step4 = 32'b00000001000001010000011000000011;		// add   5, 6, 3
reg [31:0] step5 = 32'b00000010000000010000010000000101;		// and   1, 4, 5
reg [31:0] step6 = 32'b00000011000000100000000100000110;		// or    2, 1, 6 
reg [31:0] step7 = 32'b00000000000001110000000000000010;		// mov   7, x, 2
reg [31:0] step8 = 32'b00001001000001000000011100000011;		// sub   4, 7, 3

always @(negedge clk) 
begin
	case (Read_Addr)
		3'd0:instruction = step1;
		3'd1:instruction = step2;
		3'd2:instruction = step3;
		3'd3:instruction = step4;
		3'd4:instruction = step5;
		3'd5:instruction = step6;
		3'd6:instruction = step7;
		3'd7:instruction = step8;
		default : /* default */;
	endcase
end

endmodule