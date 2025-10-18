module riscvpipelined (
    input           clk, 
    input           reset,
    input   [31:0]  Instr,
    input   [31:0]  ReadData,

    output          MemWriteM,
    output  [31:0]  PC,
    output  [31:0]  DataAdr,
    output [3:0]    BE,
    output [31:0]   StoreData
);
    wire        regwriteW, regwriteM, memwriteM, alusrcE, 
                pcsrcE, ALUbranch, doneDiv;
    wire [1:0]  writeSelectM;
    wire [2:0]  readSelectM; 
    wire [2:0]  immsrcD;
    wire [2:0]  resultsrcW;
    wire        PCTargetSrcE;
    wire        resultsrcE0;  
    wire [4:0]  alucontrolE;  
    wire [31:0] InstrD;
    wire        flushE;

    assign MemWriteM = memwriteM;

    controller c(
        .clk(clk),
        .reset(reset),
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        // .Equal(Equal),
        // .notEqual(notEqual),
        // .LT(LT),
        // .GE(GE),
        .ALUbranch(ALUbranch),
        .FlushE(flushE),
        .doneDiv(doneDiv),

        .ResultSrcW(resultsrcW),
        .RegWriteW(regwriteW),
        .writeSelectM(writeSelectM),
        .readSelectM(readSelectM),
        .RegWriteM(regwriteM),
        .MemWriteM(memwriteM),
        
        .PCTargetSrcE(PCTargetSrcE),
        .ResultSrcE0(resultsrcE0),
        .ALUControlE(alucontrolE),
        .ALUSrcE(alusrcE),
        .PCSrcE(pcsrcE),
        .ImmSrcD(immsrcD)
    );
    datapath dp (
        .clk(clk),
        .reset(reset),

        .RegWriteW(regwriteW),
        .RegWriteM(regwriteM),
        .ResultSrcW(resultsrcW),
        .writeSelectM(writeSelectM),
        .readSelectM(readSelectM),
        .PCTargetSrcE(PCTargetSrcE),
        .ResultSrcE0(resultsrcE0),
        .PCSrcE(pcsrcE),
        .ALUControlE(alucontrolE),
        .ALUSrcE(alusrcE),
        .ImmSrcD(immsrcD),

        .InstrF(Instr),
        .ReadDataM(ReadData),

        // .Equal(Equal),
        // .notEqual(notEqual),
        // .GE(GE),
        // .LT(LT),
        .ALUbranch(ALUbranch),
        .PCF(PC),
        .InstrD(InstrD),

        .ALUResultM_out(DataAdr),
        .ByteEnable(BE),
        .StoreData(StoreData),
        .CLRD(flushE)
    );
endmodule