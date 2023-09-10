module regFile (input regWriteW
, input [4:0] writeRegW
, input [31:0] resultW
, input [4:0] src1
, input [4:0] src2
, input isJ
, input isJR
, input isJAL
, input [31:0] pc
, output reg [31:0] rd1
, output reg [31:0] rd2
);
    reg [31:0] regMem [31:0];
    integer i;
    initial 
    begin 
        for (i = 0; i < 32; i = i + 1) 
            regMem[i] = 0;
    end
    always @ (*) 
    begin
        if (regWriteW == 1) 
            regMem[writeRegW] = resultW;
        if (!isJ && !isJAL && !isJR) 
        begin
            rd1 = regMem[src1];
            rd2 = regMem[src2];
        end
        if (isJAL) 
            regMem[31] = (pc - 1) * 4;
    end
endmodule  