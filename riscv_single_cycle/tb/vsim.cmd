# Compile all SystemVerilog files
# The -sv option tells vcs to compile using SystemVerilog syntax
vlog -sv \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/adder.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/alu.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/aluDecoder.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/cla_4bit_block.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/cla_32bit_adder.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/controller.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/data_mem.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/datapath.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/extend.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/flopr.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/instruction_mem.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/mainDecoder.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/mux2.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/mux3.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/register_file.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/riscvsingle.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/rtl/top.v \
    /home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_single_cycle/tb/testbench.v 

# Start the simulation with the testbench module
# The -voptargs=+acc option enables full access to all design objects for waveform viewing
vsim -voptargs=+acc testbench

# Clear all waves before adding new ones
# This is a good practice to ensure a clean waveform window
delete wave *

# Add waves to the waveform window, organized by logical groups
# Use 'add wave -group <group_name>' to create collapsible groups

# Group: Controller Signals
add wave -group {Controller Signals} \
sim:/testbench/dut/riscv/c/op \
sim:/testbench/dut/riscv/c/funct3 \
sim:/testbench/dut/riscv/c/funct7b5 \
sim:/testbench/dut/riscv/c/Zero \
sim:/testbench/dut/riscv/c/ResultSrc \
sim:/testbench/dut/riscv/c/MemWrite \
sim:/testbench/dut/riscv/c/PCSrc \
sim:/testbench/dut/riscv/c/ALUSrc \
sim:/testbench/dut/riscv/c/RegWrite \
sim:/testbench/dut/riscv/c/Jump \
sim:/testbench/dut/riscv/c/ImmSrc \
sim:/testbench/dut/riscv/c/ALUControl \
sim:/testbench/dut/riscv/c/ALUOp \
sim:/testbench/dut/riscv/c/Branch

# Group: Instruction Memory
add wave -group {Instruction Memory} \
sim:/testbench/dut/imem/A \
sim:/testbench/dut/imem/RD \
sim:/testbench/dut/imem/RAM

# Group: Register File (RF)
add wave -group {Register File (RF)} \
sim:/testbench/dut/riscv/dp/rf/clk \
sim:/testbench/dut/riscv/dp/rf/rA1 \
sim:/testbench/dut/riscv/dp/rf/rA2 \
sim:/testbench/dut/riscv/dp/rf/wA3 \
sim:/testbench/dut/riscv/dp/rf/wD3 \
sim:/testbench/dut/riscv/dp/rf/WE3 \
sim:/testbench/dut/riscv/dp/rf/RD1 \
sim:/testbench/dut/riscv/dp/rf/RD2 \
sim:/testbench/dut/riscv/dp/rf/RF

# Group: Sign Extension Unit
add wave -group {Sign Extension Unit} \
sim:/testbench/dut/riscv/dp/ImmExtnd/Instr \
sim:/testbench/dut/riscv/dp/ImmExtnd/ImmSrc \
sim:/testbench/dut/riscv/dp/ImmExtnd/ImmExt

# Group: Mux for ALU Source B
add wave -group {Mux for ALU Source B} \
sim:/testbench/dut/riscv/dp/SrcBmux/d0 \
sim:/testbench/dut/riscv/dp/SrcBmux/d1 \
sim:/testbench/dut/riscv/dp/SrcBmux/s \
sim:/testbench/dut/riscv/dp/SrcBmux/y

# Group: ALU (Arithmetic Logic Unit)
add wave -group {ALU (Arithmetic Logic Unit)} \
sim:/testbench/dut/riscv/dp/alu/A \
sim:/testbench/dut/riscv/dp/alu/B \
sim:/testbench/dut/riscv/dp/alu/ALUControl \
sim:/testbench/dut/riscv/dp/alu/Result \
sim:/testbench/dut/riscv/dp/alu/Zero

# Group: Data Memory
add wave -group {Data Memory} \
sim:/testbench/dut/dmem/clk \
sim:/testbench/dut/dmem/WE \
sim:/testbench/dut/dmem/A \
sim:/testbench/dut/dmem/WD \
sim:/testbench/dut/dmem/RD \
sim:/testbench/dut/dmem/RAM

# Group: Mux for Writeback Result
add wave -group {Mux for Writeback Result} \
sim:/testbench/dut/riscv/dp/resmux/d0 \
sim:/testbench/dut/riscv/dp/resmux/d1 \
sim:/testbench/dut/riscv/dp/resmux/d2 \
sim:/testbench/dut/riscv/dp/resmux/s \
sim:/testbench/dut/riscv/dp/resmux/y

# Group: Program Counter (PC) Register
add wave -group {Program Counter (PC) Register} \
sim:/testbench/dut/riscv/dp/PCreg/clk \
sim:/testbench/dut/riscv/dp/PCreg/reset \
sim:/testbench/dut/riscv/dp/PCreg/d \
sim:/testbench/dut/riscv/dp/PCreg/q

# Group: PC + 4 Adder
add wave -group {PC + 4 Adder} \
sim:/testbench/dut/riscv/dp/PCadd4/a \
sim:/testbench/dut/riscv/dp/PCadd4/b \
sim:/testbench/dut/riscv/dp/PCadd4/y

# Group: PC + Branch Target Adder
add wave -group {PC + Branch Target Adder} \
sim:/testbench/dut/riscv/dp/PCaddbranch/a \
sim:/testbench/dut/riscv/dp/PCaddbranch/b \
sim:/testbench/dut/riscv/dp/PCaddbranch/y