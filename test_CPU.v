`timescale 100fs/100fs

module testbench ();
  reg clk;
  CPU cpu(clk);

  initial begin
    forever begin // period 200
      clk=0;
      #100
      clk=1;
      #100
      clk=0;
      end
   end 
endmodule