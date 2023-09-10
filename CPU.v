module CPU(input clk);

wire ENABLE, RESET;
wire [31:0] PCadd;
assign ENABLE = 1'b1;
assign RESET = 1'b0;
assign PCadd = 32'h1;
wire[31:0]  PC, PCJ, PCJR;
wire [31:0] PCF;
wire [31:0] PCPLUS4F;
wire [31:0] PCPLUS4D;
wire [31:0] PCBranchM;
wire [31:0] PCJumpM;
wire [31:0] InstrF;
wire [31:0] InstrD;
wire [3:0] Counter;
wire PCSrcM, Jump, isJRM;
wire [31:0] ShiftjAddrM, rd1M;

assign PCSrcM = ZeroM & branchM;
assign Jump = isJM | isJALM;
PCMux PCmux(clk, rd1M/4, ShiftjAddrM, PCBranchM, PCPLUS4F, isJRM, Jump, PCSrcM, PC);
InstructionRAM instructionRAM(RESET, ENABLE, PC, InstrF);
Adder adder1(PC, PCadd, PCPLUS4F);

wire [3:0] counter;
wire [3:0] IDEXcounter;
wire [3:0] EXMEMcounter;

IFID ifid(clk, InstrF, PCPLUS4F, InstrD, PCPLUS4D, counter);//IFID
wire [5:0] Op, Func;
wire [4:0] src1, src2, rs, rt, rd, sa, writeRegW;
wire [31:0] resultW;
wire [15:0] imm;
wire [25:0] jAddr;
wire regWriteW;
wire [31:0] rd1;
wire [31:0] rd2;
assign Op = InstrD[31:26]; 
assign Func = InstrD[5:0];
assign src1 = InstrD[25:21];
assign src2 = InstrD[20:16];
assign sa = InstrD[10:6];
assign rt = InstrD[20:16];
assign rd = InstrD[15:11];
assign imm = InstrD[15:0];
assign jAddr = InstrD[25:0];
wire isJ, isJAL, isJR, regWrite, memToReg, memWrite, memRead, branch, shiftD, aluSrc, regDst;
regFile regfile(regWriteW, writeRegW, resultW, src1, src2, isJ, isJR, isJAL, PCPLUS4D, rd1, rd2);

wire [5:0] opD, funcD;
controlUnit controlunit(Op, Func, isJ, isJAL, isJR, regWrite, memToReg, memWrite, memRead, branch, shiftD, opD, funcD, aluSrc, regDst);

wire [31:0] SignimmD, SignjAddrD;
signExtend16 signextend16(imm, SignimmD);
signExtend26 signextend26(jAddr, SignjAddrD);

wire regDstE, shiftE, regWriteE;
wire [31:0] rd1E, rd2E, PCPLUS4E;
wire [4:0] rtE, rdE, saE, writeRegE;
wire [4:0] rsO, rtO;
wire [5:0] opE, funcE;
wire [31:0] SignimmE, SignjAddrE;

IDEX idex(clk, sa, isJ, isJAL, isJR, regWrite, memToReg, memWrite, memRead, branch, shiftD, opD, funcD, aluSrc, regDst, PCPLUS4D, rd1, rd2, rt, rd, SignimmD, SignjAddrD, src1, src2,
               saE, isJE, isJALE, isJRE, regWriteE, memToRegE, memWriteE, memReadE, branchE, shiftE, opE, funcE, aluSrcE, regDstE, PCPLUS4E, rd1E, rd2E, rtE, rdE, SignimmE, SignjAddrE, rsO, rtO);//IDEX

wire [31:0] ALUOut, regAE, regBE, ALUOutM;
wire [31:0] ShiftjAddrE, ShiftimmE, PCPLUS4O;
wire [1:0] forwardingA, forwardingB;
wire [4:0] writeRegM;
wire Zero, regWriteM, memToRegM;
wire [31:0] rd1EH, rd2EH, writeDataM, readDataM;

Mux3to1 mux3to1A(rd1E, resultW, ALUOutM, forwardingA, memToRegM, readDataM, rd1EH);
Mux3to1 mux3to1B(rd2E, resultW, ALUOutM, forwardingB, memToRegM, readDataM, rd2EH);
HazardForwarding hazardforwarding(clk, rsO, rtO, writeRegM, writeRegW, regWriteM, regWriteW, forwardingA, forwardingB); 

Mux2to1_5 mux2to1_5(rdE, rtE, regDstE, writeRegE);
Mux2to1 mux2to1A({27'b0, saE}, rd1EH, shiftE, regAE);
Mux2to1 mux2to1B(SignimmE, rd2EH, aluSrcE, regBE);
shiftModule shiftmodule(SignimmE, ShiftimmE);
Adder adder2(SignimmE, PCPLUS4E, PCPLUS4O);

ALU alu(regAE, regBE, opE, funcE, ALUOut, Zero);

wire isJM, isJALM, memWriteM, memReadM, branchM, ZeroM;
EXMEM exmem(clk, isJE, isJALE, isJRE, regWriteE, memToRegE, memWriteE, memReadE, branchE, Zero, ALUOut, rd2EH, writeRegE, PCPLUS4O, SignjAddrE, rd1EH, 
                 isJM, isJALM, isJRM, regWriteM, memToRegM, memWriteM, memReadM, branchM, ZeroM, ALUOutM, writeDataM, writeRegM, PCBranchM, ShiftjAddrM, rd1M);//EXMEM

wire [64:0] EDIT_SERIAL;
assign EDIT_SERIAL = {memWriteM, ALUOutM, writeDataM};
MainMemory mainmemory(counter, RESET, ENABLE, ALUOutM, EDIT_SERIAL, readDataM);


wire memToRegW;
wire [31:0] ALUOutW, readDataW;
MEMWB memwb(clk, regWriteM, memToRegM, ALUOutM, readDataM, writeRegM, regWriteW, memToRegW, ALUOutW, readDataW, writeRegW);

Mux2to1 mux2to1C(readDataW, ALUOutW, memToRegW, resultW);
endmodule



