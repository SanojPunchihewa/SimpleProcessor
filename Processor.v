// Author : Sanoj Punchihewa

module testbed;

	// == TESTBED FOR CPU ==

	reg clk, reset;
	wire [31:0] instruction;
	wire [2:0] out_addr1, out_addr2, in_addr, select;
	wire [3:0] ReadAddr;
	wire data2_compli_control, immediate_control;
	wire [7:0] dataIN, dataSRC1, dataSRC2, dataSRC2_COMPLI, data2, data1, immediate_value;

	PC myPC(clk, reset, ReadAddr);
	regInstructions myRegInstr(clk, ReadAddr, instruction);
	CU myCU(instruction, out_addr1, out_addr2, in_addr, select, data2_compli_control, immediate_control, immediate_value);
	regFile8x8a mREG(clk, in_addr, dataIN, out_addr1, dataSRC1, out_addr2, dataSRC2);
	CMPL myCMPL(dataSRC2, dataSRC2_COMPLI);
	MUX mMUX_C(dataSRC2, dataSRC2_COMPLI, data2_compli_control, data2);
	MUX mMUX_I(dataSRC1, immediate_value, immediate_control, data1);
	alu mALU(dataIN, data1, data2, select);

	initial
	begin

		$dumpfile("wavedata.vcd");
	    $dumpvars(0,testbed);
		
		clk = 1'b0;
		reset = 1'b0;
		$monitor("DataIn = %b", dataIN);
		
	end

	always #1 clk = ~clk;
	
	initial
	begin
		#16 $finish;
	end

endmodule

module PC (

	input clk,    // Clock
	input reset,
	output [3:0] Read_addr
	
);

reg [3:0] Read_addr = 4'b0000;

always @(negedge clk)
begin
	if(~reset)
		Read_addr <= Read_addr + 1'b1;
	else
		Read_addr <= 4'b0000;
end

endmodule

module regInstructions (
	input clk,    
	input [3:0] Read_Addr, 
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
		4'd0:instruction = step1;
		4'd1:instruction = step2;
		4'd2:instruction = step3;
		4'd3:instruction = step4;
		4'd4:instruction = step5;
		4'd5:instruction = step6;
		4'd6:instruction = step7;
		4'd7:instruction = step8;
		default : /* default */;
	endcase
end

endmodule

module CU (
	input [31:0] instruction,
	output [2:0] OUT1addr,
	output [2:0] OUT2addr,
	output [2:0] INaddr,	
	output [2:0] select,
	output data2_compli_control,
	output immediate_control,
	output [7:0] immediate_value
);

reg select, OUT1addr, OUT2addr, INaddr, data2_compli_control, immediate_control, immediate_value;

always @(instruction) 
begin
	select = instruction[26:24];
	INaddr = instruction[18:16];
	OUT1addr = instruction[2:0];
	OUT2addr = instruction[10:8];
	immediate_control = 1'b0;
	immediate_value = instruction[7:0];
	data2_compli_control = 1'b0;
	case (instruction[27:24])
		4'b1000:
			// load	
			immediate_control = 1'b1;
			//$display("oper = LOAD");
		4'b1001:						
			// sub
			// use the 2's comp
			data2_compli_control = 1'b1;
			//$display("oper = SUB");
		default : ;
	endcase
	
end

endmodule

module regFile8x8a (
	input clk,    			
	input [2:0] INaddr, 
	input [7:0] IN,
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

module CMPL (
	input [7:0] Data,    
	output [7:0] out	
);

reg out;

always @(Data)
begin
	out = ~Data + 8'b00000001;
end

endmodule

module MUX (
	input [7:0] Data1,    
	input [7:0] Data2, 
	input control,
	output [7:0] out	
);

reg out;

always @(Data1, Data2, control)
begin
	case (control)
		1'b1:out = Data2;
		default :out = Data1;
	endcase

end

endmodule

module alu(out, DATA1, DATA2, Select);

input [7:0] DATA1, DATA2;
input [2:0] Select;
output [7:0] out;
reg out;

always @(DATA1, DATA2, Select)
	begin
	//$display("opcode = %b" ,Select);
	case(Select)
	3'b000:out = DATA1;
	3'b001:out = DATA1+DATA2;
	3'b010:out = DATA1 & DATA2;
	3'b011:out = DATA1 | DATA2;
	default:$display("Err in OpCode");
	endcase
	//$display("op = %b => %b %b = %b",Select, DATA1, DATA2, out);
end
endmodule

