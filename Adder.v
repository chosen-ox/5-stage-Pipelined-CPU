// get the sum of two numbers
module Adder(input [31:0] add1 
, input [31:0] add2
, output reg [31:0] sum
);
    always @(*) begin
        begin
            sum = add1 + add2;
        end
    end
endmodule