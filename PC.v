module testbed;

	// == TESTBED FOR PC ==

	reg clk, reset;
	wire [2:0] Out; 

	PC my_pc(clk, reset, Out);

	initial
	begin
		
		reset = 1'b0;
		clk = 1'b0;
		$monitor("Read_Addr = %b", Out);
		
	end

	always #1 clk = ~clk;
	
	initial
	begin
		#10 $finish;
	end

	initial
	begin
		#5 reset = 1'b1;
	end

endmodule

module PC (

	input clk,    // Clock
	input reset,
	output [2:0] Read_addr
	
);

reg [2:0] Read_addr = 3'b000;

always @(negedge clk)
begin
	if(~reset)
		Read_addr <= Read_addr + 1'b1;
	else
		Read_addr <= 3'b000;
end

endmodule