module extend (
    input       [31:7]      Instr,
    input       [1:0]       ImmSrc,
    output reg  [31:0]      ImmExt
);
    always @(Instr or ImmSrc) begin
        case (ImmSrc)
            2'b00: // I type (Data processing with immediate and loads) 
                ImmExt = {{20{Instr[31]}}, Instr[31:20]}; // 12 bit-signed immediate
            2'b01: // S type (Stores) 
                ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            2'b10: // B type (Branhes)
                ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            2'b11: // I type (Jumps)
                ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21] , 1'b0};
            default: 
                ImmExt = 32'b0;
        endcase
    end    
endmodule