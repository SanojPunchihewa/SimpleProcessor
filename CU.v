module testbed;

	// == TESTBED FOR CU ==

	reg [31:0] instruct;
	wire [2:0] in_adrr;
	wire [2:0] out_adrr1;
	wire [2:0] out_adrr2;
	wire [2:0] select;
	wire data2_compli_control, immediate_control;

	CU myCU(instruct, out_adrr1, out_adrr2, in_adrr, select, data2_compli_control, immediate_control);

	initial
	begin
					// 00000000							op_code
					// 		   00000000					destination
					//   			   00000000			source 2
					//   					   00000000	source 1	
		instruct = 32'b00001000000000000000000000000010;
		#1 
		$display("out_addr_1 = %b", out_adrr1);
		$display("out_addr_2 = %b", out_adrr2);
		$display("in_addr    = %b", in_adrr);
		$display("select     = %b", select);
		$display("immediate  = %b", immediate_control);
		$display("data2_comp = %b", data2_compli_control);

	end

endmodule

module CU (
	input [31:0] instruction,
	output [2:0] OUT1addr,
	output [2:0] OUT2addr,
	output [2:0] INaddr,	
	output [2:0] select,
	output data2_compli_control,
	output immediate_control
);

reg select, OUT1addr, OUT2addr, INaddr, data2_compli_control, immediate_control;

always @(instruction) 
begin
	select = instruction[26:24];
	INaddr = instruction[18:16];
	OUT1addr = instruction[2:0];
	OUT2addr = instruction[10:8];
	immediate_control = 1'b0;
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