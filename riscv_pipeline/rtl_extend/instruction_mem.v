module instruction_mem (
    input   [31:0]   A,
    output  [31:0]   RD
);
    reg [31:0] RAM [63:0]; // // dung luong 256 byte 

    // initial begin
    //     $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/rtl_extend/riscvtest.txt", RAM);
    // end
    
    assign RD = RAM[A[31:2]]; // word aligend
endmodule