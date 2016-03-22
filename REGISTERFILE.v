module REGISTERFILE (Read1, Read2, WriteReg, WriteData, RegWrite, Data1, Data2, clock);
	input[4:0]Read1, Read2, WriteReg;	//the register numbers to read or write
	input[31:0]WriteData;					//data to write
	input RegWrite, clock;					//RegWrite-the write control, the clock to trigger write
	output[31:0]Data1, Data2;				//the register values read
	reg[31:0] RF[31:0];						//32 registers each 32 bits long
	
	initial begin
		RF[0]=0;
		RF[1]=12;
		RF[2]=43;
		RF[3]=0;
		RF[4]=0;
	end
	
	assign Data1=RF[Read1];
	assign Data2=RF[Read2];	
	always begin @(posedge clock) if (RegWrite)RF[WriteReg]<=WriteData;
	end
endmodule
