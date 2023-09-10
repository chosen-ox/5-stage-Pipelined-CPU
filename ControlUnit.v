module controlUnit(input [5:0]op
, input [5:0]func

,output reg isJ // whether the instruction is J
,output reg isJAL// whether the instruction is JAL
,output reg isJR // whether the instruction is JR
,output reg regWrite
,output reg memToReg
,output reg memWrite
,output reg memRead
,output reg branch
,output reg shiftD // whether ALU needs shift amount
,output reg [5:0]opD
,output reg [5:0]funcD
,output reg aluSrc
,output reg regDst);
    initial
    begin
        isJ=0;
        isJAL=0;
        isJR=0;
        regWrite=0;
        memToReg=0;
        memWrite=0;
        memRead=0;
        branch=0;
        shiftD=0;
        aluSrc=0;
        regDst=0;
    end
    always @(op or func) 
    begin
        isJ=0;
        isJAL=0;
        isJR=0;
        regWrite=0;
        memToReg=0;
        memWrite=0;
        memRead=0;
        branch=0;
        shiftD=0;
        aluSrc=0;
        regDst=0;
        opD = op;
        funcD = func;
        case (op)
            6'b000000://Rtype MIPS instruction
            begin
                regWrite = 1;
                regDst = 1;
                case(func)
                    6'b001000: begin
                        isJR = 1;
                        regWrite = 0;
                        regDst = 0;
                    end
                    6'b000000: shiftD = 1;
                    6'b000011: shiftD = 1;
                    6'b000010: shiftD = 1;
                endcase
            end
            6'b001000:  //addi
                begin
                    regWrite = 1'b1;
                    aluSrc = 1'b1;
                end

            6'b001001:  //addiu
                begin
                    regWrite = 1'b1;
                    aluSrc = 1'b1;
                end
            
            6'b001100:  //andi
                begin
                    regWrite = 1'b1;
                    aluSrc = 1'b1;
                end
            
            6'b001101: //ori
                begin
                    regWrite = 1'b1;
                    aluSrc = 1'b1;
                end
            
            6'b001110: //xori
                begin
                    regWrite = 1'b1;
                    aluSrc = 1'b1;
                end
            
            6'b000100: //beq N
                begin
                    branch = 1;
                end

            6'b000101: //bne N
                begin
                    branch = 1;
                end
            
            6'b100011: //lw
                begin
                    memRead = 1'b1;
                    regWrite = 1'b1;
                    aluSrc = 1'b1; 
                    memToReg = 1'b1;
                end
            6'b101011: //sw
                begin
                    memWrite = 1'b1;
                    aluSrc = 1'b1; 
                end
            6'b000010: //j
                begin
                    isJ = 1'b1;
                end
            6'b000011: //jal
                begin
                    isJAL = 1'b1;
                end
        endcase
    end
endmodule