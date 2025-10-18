module aluDecoder (
    input           opb5,
    input   [2:0]   funct3,
    input           funct7b5,
    input   [1:0]   ALUOp,
    output reg [2:0]    ALUControl
);
    wire RtypeSub;
    assign RtypeSub = funct7b5 & opb5;  // TRUE for R-type subtract

    always @(ALUOp or funct3 or RtypeSub) begin
        case (ALUOp)
            2'b00:  ALUControl = 3'b000;  // add 
            2'b01:  ALUControl = 3'b001;  // sub 
            2'b10: begin  // R- or I-type
                case (funct3)
                    3'b000: begin
                        if (RtypeSub) 
                            ALUControl = 3'b001; // SUB
                        else 
                            ALUControl = 3'b000; // add, addi
                    end 
                    3'b010: ALUControl = 3'b101; // slt, lti
                    3'b110: ALUControl = 3'b011; // or, ori
                    3'b111: ALUControl = 3'b010; // and, andi
                    default: ALUControl = 3'bxxx; // ???
                endcase
            end
            default: ALUControl = 3'bxxx;
        endcase
    end
endmodule