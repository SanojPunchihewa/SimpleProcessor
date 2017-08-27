// Author : Sanoj Punchihewa

module testbed;

	// == TESTBED FOR 2's COMPLIMENT ==

	reg [7:0] DataIN;
	wire [7:0] Out; 

	CMPL my_compli(DataIN, Out);

	initial
	begin	
		
		DataIN=8'b00000011;			
		#1
		$display("DataIN = %b COMPL = %b" , DataIN, Out);
		$finish;	
		
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
