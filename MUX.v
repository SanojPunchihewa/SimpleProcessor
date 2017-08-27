module testbed;

	// == TESTBED FOR MUX ==

	reg [7:0] Data1, Data2;
	wire [7:0] Out; 
	reg control;

	MUX my_mux(Data1, Data2, control, Out);

	initial
	begin	
		
		Data1=8'b00000011;
		Data2=8'b00000001;
		control=1'b0;
		#1
		$display("control = %b => Data1 = %b Data2 = %b OUT = %b" , control, Data1, Data2, Out);
		control=1'b1;
		#1
		$display("control = %b => Data1 = %b Data2 = %b OUT = %b" , control, Data1, Data2, Out);
		$finish;	
		
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