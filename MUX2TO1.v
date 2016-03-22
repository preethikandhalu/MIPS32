module MUX2TO1 (Input1, Input2, Selector, Out);
	input [31:0] Input1, Input2;
	input Selector;
	output reg[31:0] Out;
	
	always@(Input1, Input2, Selector) begin
	if(Selector==0) 
		Out=Input1;

	else if(Selector==1) 
		Out=Input2;

	end
	
endmodule
