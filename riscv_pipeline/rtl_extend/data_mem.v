module data_mem (
    input           clk, WE,
    input [3:0]     BE,  // Byte-enable: 
    // BE[3] cho byte cao nhất (31:24), BE[0] cho byte thấp nhất (7:0)
    input [31:0]    A, WD,
    output [31:0]   RD
);
    reg [7:0] RAM [255:0];   // dung luong 256 byte 
    assign RD = {RAM[A+3], RAM[A+2], RAM[A+1], RAM[A]};

    always @(posedge clk) begin
        if (WE) begin
            if (BE[3]) 
                RAM[A+3] <= WD[31:24];
            else begin
            end
            if (BE[2]) 
                RAM[A+2] <= WD[23:16];
            else begin
            end
            if (BE[1]) 
                RAM[A+1] <= WD[15:8];
            else begin
                
            end
            if (BE[0])
                 RAM[A] <= WD[7:0];
            else begin
            end
        end
        else begin
        end
    end
endmodule

// 1 word contains 4 byte RISC-V byte-addressable memory