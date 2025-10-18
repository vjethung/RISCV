module controller (
    input           clk, reset,
    input   [6:0]   op,
    input   [2:0]   funct3,
    input   [6:0]   funct7,
    // input           Equal, notEqual,
    // input           LT, GE,
    input           ALUbranch,
    input           FlushE,
    input           doneDiv,

    output reg [2:0]    ResultSrcW,
    output reg          RegWriteW,

    output reg [1:0]    writeSelectM,
    output reg [2:0]    readSelectM,
    output reg          RegWriteM,
    output reg          MemWriteM,
    
    output reg          PCTargetSrcE,
    output              ResultSrcE0,
    output reg [4:0]    ALUControlE,
    output reg          ALUSrcE,
    output              PCSrcE,

    output  [2:0]       ImmSrcD
);
    wire [1:0]  ALUOp;
    wire [1:0]  writeSelectD;
    wire [2:0]  readSelectD; 
    wire        PCTargetSrcD;  
    wire        RegWriteD;          
    wire [2:0]  ResultSrcD; 
    wire        MemWriteD;
    wire        JumpD; 
    wire        BranchD;
    wire [4:0]  ALUControlD;
    wire        ALUSrcD;   
    
    reg [1:0]   writeSelectE;
    reg [2:0]   readSelectE; 
    
    reg         RegWriteE;
    reg [2:0]   ResultSrcE;
    reg         MemWriteE;
    reg         JumpE;
    reg         BranchE;

    reg [2:0]   ResultSrcM;

    mainDecoder md(
        .op(op), 
        .funct3(funct3),
        .PCTargetSrc(PCTargetSrcD), 
        .RegWrite(RegWriteD),
        .ResultSrc(ResultSrcD), 
        .MemWrite(MemWriteD), 
        .Jump(JumpD),  
        .Branch(BranchD),
        .ALUSrc(ALUSrcD),
        .ImmSrc(ImmSrcD),
        .ALUOp(ALUOp),
        .writeSelect(writeSelectD),
        .readSelect(readSelectD)
    );

    aluDecoder ad(
        .op5(op[5]),
        .funct3(funct3),
        .funct7(funct7),  
        .ALUOp(ALUOp), 
        .ALUControl(ALUControlD)
    );

    assign PCSrcE = (BranchE & ALUbranch) | JumpE;
    assign ResultSrcE0 = ResultSrcE[0];

    wire clrD;
    assign clrD = FlushE;
    // Decode/Execute pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            writeSelectE <= 0;
            readSelectE <= 0;
            PCTargetSrcE <= 0;
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;
        end
        else if (clrD) begin
            writeSelectE <= 0;
            readSelectE <= 0;
            PCTargetSrcE <= 0;
            RegWriteE <= 0;
            ResultSrcE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUControlE <= 0;
            ALUSrcE <= 0;
        end
        else begin
            writeSelectE <= writeSelectD;
            readSelectE <= readSelectD;
            PCTargetSrcE <= PCTargetSrcD;
            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
        end
    end
    // Execute/Memory pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            writeSelectM <= 0;
            readSelectM <= 0;
            RegWriteM <= 0;
            ResultSrcM <= 0;
            MemWriteM <= 0;
        end
        else begin
            writeSelectM <= writeSelectE;
            readSelectM <= readSelectE;
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
        end
    end
    // Memory/Writeback pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
        end
        else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
        end
    end
endmodule