module testbed;

	// == TESTBED FOR ALU ==

	reg [7:0] Data1, Data2;
	wire [7:0] Out; 
	reg [2:0] select;

	alu my_alu(Out, Data1, Data2, select);

	initial
	begin	
		
		Data1=8'b00000011;
		Data2=8'b00000001;
		select=3'b010;
		#5
		$display("select = %b => Data1 = %b Data2 = %b OUT = %b" , select, Data1, Data2, Out);
		$finish;	
		
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