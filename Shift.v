module shiftModule(A, Q);
    input [31:0] A; // input
    output reg [31:0] Q; // output
    always @(*)
    begin
        Q = A << 2;
    end
endmodule
