module register_file (
    input           clk,
    input [4:0]     rA1,
    input [4:0]     rA2,     // read ports adderss 
    input [4:0]     wA3,         // wirte port address
    input [31:0]    wD3,
    input           WE3,
    output [31:0]   RD1,
    output [31:0]   RD2     
);
    reg [31:0] RF [31:0];
    
    always @(posedge clk) begin
        RF[31'b0] <= 0;
        if (WE3 & (wA3!=0)) begin
            RF[wA3] <= wD3;
        end
        else begin
            
        end
    end

    assign RD1 = (rA1 != 0) ? RF[rA1] : 32'b0;
    assign RD2 = (rA2 != 0) ? RF[rA2] : 32'b0; 

endmodule