module top (
    input       clk, 
    input       reset,
    output  [31:0]  StoreData, 
    output  [31:0]  DataAdr,
    output          MemWrite,
    // output  [3:0]  BE
    output [31:0] imem_addr,
    output [31:0] imem_data,
    output [31:0] dmem_addr, 
    output [31:0] dmem_wdata,
    output [31:0] dmem_rdata,
    output dmem_we
);
    wire [31:0] pc, instr, readdata; // StoreData, DataAdr;
    wire        memwriteM;
    wire [3:0]  BE;
    assign MemWrite = memwriteM;

    assign imem_addr = pc;
    assign imem_data = instr;
    assign dmem_addr = DataAdr;
    assign dmem_wdata = StoreData;
    assign dmem_rdata = readdata;
    assign dmem_we = memwriteM;
    // instaintiate processor and memories 

    riscvpipelined riscv(
        .clk(clk), 
        .reset(reset), 
        .Instr(instr), 
        .ReadData(readdata),

        .MemWriteM(memwriteM), 
        .PC(pc), 
        .DataAdr(DataAdr),
        .BE(BE),
        .StoreData(StoreData)
    );
    instruction_mem imem(
        .A(pc), 
        .RD(instr)
    );
    data_mem dmem(
        .clk(clk), 
        .WE(memwriteM), 
        .BE(BE),
        .A(DataAdr), 
        .WD(StoreData), 
        .RD(readdata)
    );
endmodule

// lệnh div đang bị lỗi - nên kh hỗ trợ