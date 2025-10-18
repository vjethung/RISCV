module register_file (
    input           clk,
    //input           reset,
    input [4:0]     rA1,
    input [4:0]     rA2,    // read ports adderss 
    input [4:0]     wA3,    // wirte port address
    input [31:0]    wD3,
    input           WE3,
    output [31:0]   RD1,
    output [31:0]   RD2     
);
    reg [31:0] RF [31:0];
    // integer i;
    always @(negedge clk) begin
        // if (reset) begin
        //     for (i = 0; i < 32; i = i + 1) begin
        //         RF[i] <= 32'b0;
        //     end
        // end
        // else begin
        //     if (WE3) begin
        //         RF[wA3] <= wD3;
        //     end
        //     else begin
        //     end
        // end
        if (WE3) begin
            RF[wA3] <= wD3;
        end
        else begin
        end
    end

    assign RD1 = (rA1 != 0) ? RF[rA1] : 32'b0;
    assign RD2 = (rA2 != 0) ? RF[rA2] : 32'b0; 

endmodule