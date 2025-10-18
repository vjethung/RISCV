module data_mem (
    input           clk, WE,
    input [31:0]    A, WD,
    output [31:0]   RD
);
    reg [31:0] RAM [63:0];   // dung luong 256 byte 
    assign RD = RAM[A[31:2]]; // word aligend

    always @(posedge clk) begin
        if (WE) begin
            RAM[A[31:2]] <= WD;
        end
        else begin
            
        end
    end
endmodule

// 1 word contains 4 byte RISC-V byte-addressable memory