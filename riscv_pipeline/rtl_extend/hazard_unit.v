module hazard_unit (
    input   [4:0]   Rs1D, Rs1E,
    input   [4:0]   Rs2D, Rs2E,
    input   [4:0]   RdE, RdM, RdW,
    input           RegWriteM, RegWriteW,
    input           PCSrcE,
    input           ResultSrcE0,
    input           doneDiv,
    input   [4:0]   ALUControl,

    output     StallF, StallD,
    output     FlushD, FlushE,
    output  reg [1:0] ForwardAE, ForwardBE
);
    wire lwStall;
    
    always @(Rs1D or Rs2D or Rs1E or Rs2E or RdE or RdM or RdW or RegWriteM or RegWriteW or PCSrcE or ResultSrcE0) begin
        if (((Rs1E == RdM) & RegWriteM) & (Rs1E != 0)) begin
            ForwardAE = 2'b10;
        end 
        else if (((Rs1E == RdW) & RegWriteW) & (Rs1E != 0)) begin
            ForwardAE = 2'b01;
        end
        else begin
            ForwardAE = 2'b00;
        end
        

        if (((Rs2E == RdM) & RegWriteM) & (Rs2E != 0)) begin
            ForwardBE = 2'b10;
        end 
        else if (((Rs2E == RdW) & RegWriteW) & (Rs2E != 0)) begin
            ForwardBE = 2'b01;
        end
        else begin
            ForwardBE = 2'b00;
        end
    end

    assign lwStall = ResultSrcE0 & ((Rs1D == RdE) | (Rs2D == RdE));  

    assign StallF = lwStall | (~doneDiv);
    assign StallD = lwStall | (~doneDiv);

    assign FlushD = PCSrcE;
    assign FlushE = lwStall | PCSrcE;
endmodule