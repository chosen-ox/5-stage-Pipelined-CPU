module ALU(regA, regB, opE, funcE, ALUOutM, ZeroM);
    input[31:0] regA, regB; // the address of regA is 00000, the address of regB is 00001
    output[31:0] ALUOutM;
    output reg ZeroM;
    input [5:0] opE, funcE;
    reg ALUOutM;
    reg signed [31:0] tempRegAS, tempRegBS;// get the sign of regA and regB
    initial begin
        ZeroM = 0;
    end
    always @(*) 
    begin
        tempRegAS = regA;
        tempRegBS = regB;          
        case (opE)
            6'b000000://Rtype MIPS instruction
            begin
                case (funcE)
                    6'b100000: //add
                    begin
                        ALUOutM = tempRegAS + tempRegBS;
                    end
                    6'b100001://addu
                    begin
                        ALUOutM = regA + regB;
                    end
                    6'b100100://and
                    begin
                        ALUOutM = regA & regB;
                    end
                    6'b100010://sub
                    begin
                        ALUOutM = tempRegAS - tempRegBS;
                    end
                    6'b100011://subu
                    begin
                        ALUOutM = regA - regB;
                    end
                    6'b100111://nor
                    begin
                        ALUOutM = ~(regA | regB);
                    end
                    6'b100101://or
                    begin    
                        ALUOutM = regA | regB;
                    end
                    6'b100110://xor
                    begin
                        ALUOutM = regA ^ regB;
                    end
                    6'b101010://slt
                    begin
                        ALUOutM = regA < regB;
                    end    
                    6'b0://sll
                    begin
                        ALUOutM = regB << regA;
                    end
                    6'b000100://sllv
                    begin
                        ALUOutM = regB << regA;
                    end
                    6'b000010://srl
                    begin
                        ALUOutM = regB >> regA;
                    end
                    6'b000110://srlv
                    begin
                        ALUOutM = regB >> regA;
                    end
                    6'b000011://sra
                    begin
                        ALUOutM = tempRegBS >>> regA;
                    end
                    6'b000111://srav
                    begin
                        ALUOutM = tempRegBS >>> regA;
                    end
                endcase
            end
            6'b001000://addi
                begin
                    ALUOutM = tempRegAS + tempRegBS;
                end
            6'b001001://addiu
                begin
                    ALUOutM = tempRegAS + tempRegBS;
                end
            6'b001100://andi
                begin
                    ALUOutM = regA & {16'b0, regB[15:0]};//zero extend
                end
            6'b001101://ori
                begin
                    ALUOutM = regA | {16'b0, regB[15:0]};
                end
            6'b001110://xori
                begin
                    ALUOutM = regA ^ {16'b0, regB[15:0]};
                end
            6'b000100://beq
                begin
                    ZeroM = (regA == regB);
                end
            6'b000101://bne
                begin
                    ZeroM = (regA != regB);
                end
            6'b100011://lw
                begin
                    ALUOutM = (regA + regB)/4;// byte address to word address
                end
            6'b101011://sw
                begin
                    ALUOutM = (regA + regB)/4;
                end
        endcase
    end
endmodule