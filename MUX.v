module PCMux(clk, a, b, c, d, A, B, C, out);// This module choose the value assigned to the PC ptr.
    input clk;
    input [31:0] a, b, c, d;
    input A, B, C;
    output [31:0] out;
    reg start;
    reg out;
    initial begin
        start = 1;
        out = 0;
    end
    always @(posedge clk)
    begin
        if (start == 1)
        begin 
            start = 0;
        end
        else
        begin
            if (A == 1) out = a; // JR
            else if (B == 1) out = b; // J or JAL
            else if (C == 1) out = c; // BEQ or BNE
            else out = d; // PC + 4
        end
    end
endmodule

module Mux2to1(a, b, sel, out);
    input [31:0] a, b;
    input sel;
    output [31:0] out;
    reg out;
    always @(sel or a or b)
    begin
        out = (sel)?a:b;
    end
endmodule
module Mux2to1_5(a, b, sel, out);// mux for writeReg
    input [4:0] a, b;
    input sel;
    output [4:0] out;
    reg out;
    always @(sel or a or b)
    begin
        out = (sel)?a:b;
    end
endmodule
module Mux3to1(a, b, c, sel, memtoRegM, readDataM, out);
    input [31:0] a, b, c, readDataM;
    input [1:0] sel;
    input memtoRegM;
    output reg [31:0] out;
    always @(*) begin
        case (sel)
            0: out = a;
            1: out = b;
            2: out = (memtoRegM)?readDataM:c; //this aims to handle hazards about sw
        endcase
    end
endmodule