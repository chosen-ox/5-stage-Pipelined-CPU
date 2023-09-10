module IFID(input clk
, input [31:0] instruction
, input [31:0] pc

, output reg [31:0] instruction_out
, output reg [31:0] pc_out
, output reg [3:0] counter);
    reg flag = 0; 
    reg [31:0] cycle;
    initial begin 
        counter = 3; 
        cycle = 0;
    end 
    always @(posedge clk)
    begin
        cycle = cycle + 1;
        if (counter == 0)
            $display("cycle: %d", cycle);
        if (counter == 0)
            $finish;
        if (flag)
            counter = counter - 1;
        if (instruction == 32'hffffffff) 
            flag = 1;
        else
        begin
            instruction_out <= instruction;
            pc_out <= pc;
        end
    end
endmodule

module IDEX(input clk
, input [4:0] saD
, input isJ
, input isJAL
, input isJR
, input regWriteD
, input memToRegD
, input memWriteD
, input memReadD
, input branchD
, input shiftD
, input [5:0] opD
, input [5:0] funcD
, input aluSrcD
, input regDstD
, input [31:0] pcD
, input [31:0] rd1
, input [31:0] rd2
, input [4:0] rtD
, input [4:0] rdD
, input [31:0] immD
, input [31:0] jAddrD
, input [4:0] rs
, input [4:0] rt

, output reg [4:0] saE
, output reg isJE
, output reg isJALE
, output reg isJRE
, output reg regWriteE
, output reg memToRegE
, output reg memWriteE
, output reg memReadE
, output reg branchE
, output reg shiftE
, output reg [5:0]opE
, output reg [5:0]funcE
, output reg aluSrcE
, output reg regDstE
, output reg [31:0] pcE
, output reg [31:0] rd1E
, output reg [31:0] rd2E
, output reg [4:0] rtE
, output reg [4:0] rdE
, output reg [31:0] immE
, output reg [31:0] jAddrE
, output reg [4:0] rsO
, output reg [4:0] rtO);
    always @(posedge clk)
    begin
        begin
            saE <= saD;
            isJE <= isJ;
            isJALE <= isJAL;
            isJRE <= isJR;
            regWriteE <= regWriteD;
            memToRegE <= memToRegD;
            memWriteE <= memWriteD;
            memReadE <= memReadD;
            branchE <= branchD;
            shiftE <= shiftD;
            opE <= opD;
            funcE <= funcD;
            aluSrcE <= aluSrcD;
            regDstE <= regDstD;
            pcE <= pcD;
            rd1E <= rd1;
            rd2E <= rd2;
            rtE <= rtD;
            rdE <= rdD;
            immE <= immD;
            jAddrE <= jAddrD;
            rsO <= rs;
            rtO <= rt;
        end
    end    
endmodule
module EXMEM(input clk
, input isJ
, input isJAL
, input isJR
, input regWriteE
, input memToRegE
, input memWriteE
, input memReadE
, input branchE
, input ZeroE
, input [31:0] ALUOutE
, input [31:0] writeDataE
, input [4:0] writeRegE
, input [31:0] pcE
, input [31:0] ShiftjAddrE
, input [31:0] rd1E

, output reg isJM
, output reg isJALM
, output reg isJRM
, output reg regWriteM
, output reg memToRegM
, output reg memWriteM
, output reg memReadM
, output reg branchM
, output reg ZeroM
, output reg [31:0] ALUOutM
, output reg [31:0] writeDataM
, output reg [4:0] writeRegM
, output reg [31:0] pcM
, output reg [31:0] ShiftjAddrM
, output reg [31:0] rd1M);
    reg [3:0] Counter;
    initial begin
        Counter = 0;// counter for jump and branch
    end
    always @(posedge clk)
    begin
        if (Counter > 0) begin
            Counter = Counter - 1;// decrease one per clock
            isJM <= 0;
            isJALM <= 0;
            isJRM <= 0;
            regWriteM <= 0;
            memToRegM <= 0;
            memWriteM <= 0;
            memReadM <= 0;
            branchM <= 0;
            ZeroM <= 0;
            ALUOutM <= 0;
            writeDataM <= 0;
            writeRegM <= 0;
            pcM <= 0;
            ShiftjAddrM <= 0;
            rd1M <= rd1E;
        end
        else begin
        if ((branchE & ZeroE) | isJAL | isJ | isJR) 
        begin
            Counter = 3;
        end
        isJM <= isJ;
        isJALM <= isJAL;
        isJRM <= isJR;
        regWriteM <= regWriteE;
        memToRegM <= memToRegE;
        memWriteM <= memWriteE;
        memReadM <= memReadE;
        branchM <= branchE;
        ZeroM <= ZeroE;
        ALUOutM <= ALUOutE;
        writeDataM <= writeDataE;
        writeRegM <= writeRegE;
        pcM <= pcE;
        ShiftjAddrM <= ShiftjAddrE;
        rd1M <= rd1E;
        end
    end
endmodule
module MEMWB(input clk
, input regWriteM
, input memtoRegM
, input [31:0] ALUOutM
, input [31:0] readDataM
, input [4:0] writeRegM

, output reg regWriteW
, output reg memtoRegW
, output reg [31:0] ALUOutW
, output reg [31:0] readDataW
, output reg [4:0] writeRegW);
    always @(posedge clk)
    begin
        regWriteW <= regWriteM;
        memtoRegW <= memtoRegM;
        ALUOutW <= ALUOutM;
        readDataW <= readDataM;
        writeRegW <= writeRegM;
    end
endmodule
