module datapath (
    input       clk, 
    input       reset,
    input [1:0] ResultSrc,
    input       PCSrc, 
    input       ALUSrc,
    input       RegWrite,
    input [1:0] ImmSrc,
    input [2:0] ALUControl,

    output          Zero,
    output [31:0]   PC,
    input [31:0]   Instr,
    output [31:0]   ALUResult, 
    output [31:0]   WriteData,
    input [31:0]    ReadData
);
    wire [31:0] PCNext, PCPlus4, PCTarget;
    wire [31:0] ImmExt;
    wire [31:0] SrcA, SrcB;
    wire [31:0] Result;

    //next PC logic
    flopr #(32) PCreg (
        .clk(clk), 
        .reset(reset), 
        .d(PCNext), 
        .q(PC)
    );
    adder PCadd4 (
        .a(PC), 
        .b(32'h0000_0004), 
        .y(PCPlus4)
    );
    adder PCaddbranch (
        .a(PC), 
        .b(ImmExt), 
        .y(PCTarget)
    );
    mux2 #(32) PCmux (
        .d0(PCPlus4),
        .d1(PCTarget),
        .s(PCSrc),
        .y(PCNext)
    );

    //register file logic
    register_file    rf(
        .clk(clk), 
        .WE3(RegWrite), 
        .rA1(Instr[19:15]), 
        .rA2(Instr[24:20]),
        .wA3(Instr[11:7]), 
        .wD3(Result), 
        .RD1(SrcA), 
        .RD2(WriteData)
    );

    extend ImmExtnd(
        .Instr(Instr[31:7]), 
        .ImmSrc(ImmSrc), 
        .ImmExt(ImmExt)
    );

    // ALU logic
    mux2 #(32)  SrcBmux(
        .d0(WriteData), 
        .d1(ImmExt), 
        .s(ALUSrc), 
        .y(SrcB)
    );
    alu alu(
        .A(SrcA), 
        .B(SrcB), 
        .ALUControl(ALUControl), 
        .Result(ALUResult),
        .Cout(), 
        .Zero(Zero)
    ); 
    mux3 #(32)  resmux(
        .d0(ALUResult), 
        .d1(ReadData), 
        .d2(PCPlus4), 
        .s(ResultSrc), 
        .y(Result)
    );
endmodule