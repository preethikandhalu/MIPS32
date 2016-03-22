module IM(addr, clk, IMInstr, LabelSE, LabelSESL2, RS1, RS2, RD, OpCode, FuncCode); 
	input [31:0] addr;  
	input clk;
	output reg [31:0] IMInstr, LabelSE, LabelSESL2;
	output reg [4:0] RS1, RS2, RD;
	output reg [5:0] OpCode, FuncCode;
	reg [31:0] mem [255:0];    
	initial begin  
		$readmemh("project.txt", mem);   
	end 
	always @( posedge clk) begin   
		IMInstr=mem[addr[31:0]]; 
		LabelSE={{16{IMInstr[15]}},IMInstr[15:0]};	//Sign Extend
		RS1=IMInstr[25:21];
		RS2=IMInstr[20:16];
		RD=IMInstr[15:11];
		OpCode=IMInstr[31:26];
		FuncCode=IMInstr[5:0];		
	end 
endmodule
