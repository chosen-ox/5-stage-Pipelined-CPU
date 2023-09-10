cc = iverilog
flags = -o
test = test_CPU.v
main: $(test) Adder.v ALU.v ControlUnit.v CPU.v InstructionRAM.v MainMemory.v MUX.v PipeRegister.v Register.v Shift.v SignExtend.v HazardForwarding.v 
	$(cc) $(flags) $@ $^  
clean:
	rm -f main 

