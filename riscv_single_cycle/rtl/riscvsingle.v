module riscvsingle (
    input       clk, 
    input       reset,
    output  [31:0]  PC,
    input   [31:0]  Instr,
    output          MemWrite,
    output  [31:0]  ALUResult, 
    output  [31:0]  WriteData,
    input   [31:0]  ReadData
);

    wire        alusrc, pcsrc, regwrite, jump, zero;
    wire [1:0]  resultsrc, immsrc;
    wire [2:0]  alucontrol;

    controller c(
        .op(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7b5(Instr[30]),
        .Zero(zero),
        .ResultSrc(resultsrc),
        .MemWrite(MemWrite),
        .PCSrc(pcsrc),
        .ALUSrc(alusrc),
        .RegWrite(regwrite),
        .Jump(jump),
        .ImmSrc(immsrc),
        .ALUControl(alucontrol)
    );
    datapath dp (
        .clk(clk),
        .reset(reset),
        .ResultSrc(resultsrc),
        .PCSrc(pcsrc),
        .ALUSrc(alusrc),
        .RegWrite(regwrite),
        .ImmSrc(immsrc),
        .ALUControl(alucontrol),
        .Zero(zero),
        .PC(PC),
        .Instr(Instr),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );
endmodule