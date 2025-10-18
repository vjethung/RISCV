module top (
    input       clk, 
    input       reset,
    output  [31:0]  WriteData, 
    output  [31:0]  DataAdr,
    output          MemWrite
);
    wire [31:0] pc, instr, readdata;

    // instaintiate processor and memories 

    riscvsingle riscv(
        .clk(clk), 
        .reset(reset), 
        .PC(pc), 
        .Instr(instr), 
        .MemWrite(MemWrite), 
        .ALUResult(DataAdr),
        .WriteData(WriteData), 
        .ReadData(readdata)
    );
    instruction_mem imem(
        .A(pc), 
        .RD(instr)
    );
    data_mem dmem(
        .clk(clk), 
        .WE(MemWrite), 
        .A(DataAdr), 
        .WD(WriteData), 
        .RD(readdata)
    );
endmodule