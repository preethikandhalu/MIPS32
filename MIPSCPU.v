module MIPSCPU (CLOCK, RESET, IMINSTRUCTION, Data1A, mux1B, ALUoutmux2in1DMAddr, RS1Read1, RS2Read2mux3in1, mux3writereg, mux2writedata, Data2mux1in1DMDataIn, DataOutmux2in2, pcout);

	//Input and Outputs
	input CLOCK;
	input RESET;
	output [31:0] IMINSTRUCTION;
	output [31:0] Data1A;
	output [31:0] mux1B;
	output [31:0] ALUoutmux2in1DMAddr;
	output [4:0] RS1Read1;
	output [4:0] RS2Read2mux3in1;
	output [4:0] mux3writereg;
	output [31:0] mux2writedata;
	output [31:0] Data2mux1in1DMDataIn;
	output [31:0] DataOutmux2in2;
	output [31:0] pcout;
	
	//INTERCONNECTIONS
	wire [4:0] mux3writereg;				
	wire [31:0] mux2writedata;				
	wire [4:0] RS1Read1;						
	wire [4:0] RS2Read2mux3in1;			
	wire [4:0] RDInput2;						
	
	wire [31:0] Data1A;						
	wire [31:0] Data2mux1in1DMDataIn;	
	wire [31:0] mux1B;						
	wire [31:0] LabelSEmux1in2;			
	
	wire [31:0] ALUoutmux2in1DMAddr;		
	wire [31:0] DataOutmux2in2;
	
	wire [5:0] opcode;
	wire [1:0] aluop;
	wire [3:0] aluctl;
	wire [5:0] funcode;
	
	wire cu1, cu2, cu3, rfwe, dmwe, dmre, beq, zero;
	
	wire [31:0] pcout, pcin;
	
	//PROGRAM COUNTER (PC)
	PC pc1(
	.rst(RESET),
	.clk(CLOCK),
	.PCin(pcin),
	.PCout(pcout)
	);
	
	//INSTRUCTION MEMORY (IM)
	IM im1(
	.addr(pcout),
	.clk(CLOCK),
	.IMInstr(IMINSTRUCTION),
	.LabelSE(LabelSEmux1in2),
	.RS1(RS1Read1),
	.RS2(RS2Read2mux3in1),
	.RD(RDInput2),
	.OpCode(opcode),
	.FuncCode(funcode)
	);
	
	//REGISTER FILE (RF)
	REGISTERFILE regfile1(
	.Read1(RS1Read1),
	.Read2(RS2Read2mux3in1),
	.WriteReg(mux3writereg),
	.WriteData(mux2writedata),
	.RegWrite(rfwe),
	.Data1(Data1A),
	.Data2(Data2mux1in1DMDataIn),
	.clock(CLOCK)
	);
	
	//ARITHMETIC LOGIC UNIT (ALU)
	ALU alu1(
	.ALUctl(aluctl),
	.A(Data1A),
	.B(mux1B),
	.ALUOut(ALUoutmux2in1DMAddr),
	.Zero(zero)
	); 
	
	//DATA MEMORY (DM)
	DM dm1(
	.DataIn(Data2mux1in1DMDataIn),
	.DataOut(DataOutmux2in2),
	.Addr(ALUoutmux2in1DMAddr),
	.WriteEnable(dmwe),
	.ReadEnable(dmre),
	.Clk(CLOCK)
	);
	
	//MAIN CONTROL
	MainControl mc1(
	.OpCode(opcode),
	.ALUOp(aluop),
	.CU1(cu1),
	.CU2(cu2),
	.CU3(cu3),
	.beq(beq),
	.RFwe(rfwe),
	.DMwe(dmwe),
	.DMre(dmre)
	);
	
	//ALU CONTROL
	ALUControl aluctl1(
	.ALUOp(aluop),
	.FuncCode(funcode),
	.ALUCtl(aluctl)
	);
	
	//MULTIPLEXOR 1. SECOND INPUT TO THE ALU
	MUX2TO1 mux1(
	.Input1(Data2mux1in1DMDataIn),
	.Input2(LabelSEmux1in2),
	.Selector(cu1),
	.Out(mux1B)
	);
	
	//MULTIPLEXOR 2. WRITE DATA INPUT IN RF
	MUX2TO1 mux2(
	.Input1(ALUoutmux2in1DMAddr),
	.Input2(DataOutmux2in2),
	.Selector(cu2),
	.Out(mux2writedata)
	);
	
	//MULTIPLEXOR 3. WRITE REGISTER INPUT IN RF
	MUX2TO15 mux3(
	.Input1(RS2Read2mux3in1),
	.Input2(RDInput2),
	.Selector(cu3),
	.Out(mux3writereg)
	);
	
	//MULTIPLEXOR FOR BRANCH.
	MUX2TO1 Beq(
	.Input1(pcout),
	.Input2(pcout+LabelSEmux1in2),
	.Selector(beq & zero),
	.Out(pcin)
	);
		
endmodule
