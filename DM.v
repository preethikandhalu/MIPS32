module DM (DataIn, DataOut, Addr, WriteEnable, ReadEnable, Clk);
	input [31:0]Addr, DataIn;
	input WriteEnable, ReadEnable, Clk;
	output [31:0] DataOut;
	reg [31:0] DataOut;
	reg [31:0] DM[1023:0];
	
	initial begin
		DM[12]=49;
	end
	
	always @(negedge Clk) begin
		if(ReadEnable==1 && WriteEnable==0)
			DataOut=DM[Addr];
	end
	
	
	always @(posedge Clk) begin
		if(WriteEnable==1 && ReadEnable==0)
			DM[Addr]=DataIn;
	end

endmodule
