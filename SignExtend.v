module signExtend16 (input [15:0] in
, output reg [31:0] out);
    always @(*)
    begin
        out = (in[15] == 1) ? {16'b1111111111111111, in} : {16'b0000000000000000, in};
    end
endmodule // signExtend
module signExtend26 (input [25:0] in
, output reg [31:0] out);
    always @(*)
    begin
        out = {16'b0000000000000000, in};
    end
endmodule // signExtend for 26-bit