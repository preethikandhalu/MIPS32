module MainControl (OpCode, ALUOp, CU1, CU2, CU3, beq, RFwe, DMwe, DMre);
	input [5:0] OpCode;
	output reg [1:0] ALUOp;
	output reg CU1;	//ALUinput2
	output reg CU2;	//RFWriteDataInput
	output reg CU3;	//RFRDInput
	output reg beq;
	output reg RFwe;
	output reg DMwe;
	output reg DMre;
	
	always@(OpCode) begin
		if (OpCode==0) begin		//arithmetic operations (R type)
			CU1=0;
			CU2=0;
			CU3=1;
			beq=0;
			RFwe=1;
			DMwe=0;
			DMre=0;
			ALUOp=0;
		end
		
		else if (OpCode==4) begin		//beq
			CU1=0;
			//CU2 AND CU3 DOESN'T MATTER
			beq=1;
			RFwe=0;
			DMwe=0;
			DMre=0;
			ALUOp=1;
		end
		
		else if (OpCode==35) begin		//lw
			CU1=1;
			CU2=1;
			CU3=0;
			beq=0;
			RFwe=1;
			DMwe=0;
			DMre=1;
			ALUOp=0;
		end
		
		else if (OpCode==43) begin		//sw
			CU1=1;
			//CU2 AND CU3 DOESN'T MATTER			
			beq=0;
			RFwe=0;
			DMwe=1;
			DMre=0;
			ALUOp=0;
		end
	end
endmodule
