module HazardForwarding(input clk
, input [4:0] rsD
, input [4:0] rtD
, input [4:0] writeRegM
, input [4:0] writeRegW
, input regWriteM
, input regWriteW
, output reg [1:0] forwardingA
, output reg [1:0] forwardingB
);
initial 
begin
    forwardingA = 0;
    forwardingB = 0;
end
always @(*) begin
    forwardingA = 0;
    forwardingB = 0;
    // EX/MEM and MEM/WB forwarding for rs
    if (regWriteM === 1 && writeRegM != 0 && rsD === writeRegM) 
    begin
        forwardingA = 2;
    end
    else if (regWriteW === 1 && writeRegW != 0 && rsD === writeRegW) 
    begin
        forwardingA = 1;
    end
    // EX/MEM and MEM/WB forwarding for rt
    if (regWriteM === 1 && writeRegM != 0 && rtD === writeRegM) 
    begin
        forwardingB = 2;
    end
    else if (regWriteW === 1 && writeRegW != 0 && rtD === writeRegW) 
    begin
        forwardingB = 1;
    end
end
endmodule