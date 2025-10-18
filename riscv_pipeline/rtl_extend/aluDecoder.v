module aluDecoder (
    input           op5,
    input   [2:0]   funct3,
    input   [6:0]   funct7,
    input   [1:0]   ALUOp,
    output reg [4:0]    ALUControl
);
    always @(ALUOp or funct3 or op5 or funct7) begin
        if (ALUOp == 2'b00) begin
            ALUControl = 5'b00000; // I-type (lb, lh, lw, lbu, lhu), S-type, U-type
        end
        else if (ALUOp == 2'b01) begin // B-type
            case (funct3)
                3'b000: ALUControl = 5'b10010; // beq
                3'b001: ALUControl = 5'b10011; // bne
                3'b100: ALUControl = 5'b10100; // blt
                3'b101: ALUControl = 5'b10101; // bge
                3'b110: ALUControl = 5'b10110; // bltu
                3'b111: ALUControl = 5'b10111; // bgeu
                default: ALUControl = 5'bx;
            endcase
        end
        else if (ALUOp == 2'b11) begin // I-type (jalr)
           ALUControl = 5'b00000;
        end
        else begin
            if (op5) begin
                if (funct7 == 7'b0000001) begin
                    case (funct3)
                        3'b000: ALUControl = 5'b01010; // mul
                        3'b001: ALUControl = 5'b01011; // mulh
                        3'b010: ALUControl = 5'b01100; // mulhsu
                        3'b011: ALUControl = 5'b01101; // mulhu
                        3'b100: ALUControl = 5'b01110; // div
                           
                        3'b101: ALUControl = 5'b01111; // divu
                        3'b110: ALUControl = 5'b10000; // rem
                        3'b111: ALUControl = 5'b10001; // remu
                        default: ALUControl = 5'bx;
                    endcase
                end
                else if (funct7 == 7'b0000000) begin
                    case (funct3)
                        3'b000: ALUControl = 5'b00000; // add
                        3'b100: ALUControl = 5'b00010; // xor
                        3'b110: ALUControl = 5'b00011; // or
                        3'b111: ALUControl = 5'b00100; // and
                        3'b001: ALUControl = 5'b00101; // sll
                        3'b101: ALUControl = 5'b00110; // srl
                        3'b010: ALUControl = 5'b01000; // slt
                        3'b011: ALUControl = 5'b01001; // sltu
                        default: ALUControl = 5'bx;
                    endcase
                end
                else if (funct7 == 7'b0100000) begin
                    if (funct3 == 3'b000) 
                        ALUControl = 5'b00001; //sub
                    else if (funct3 == 3'b101)
                        ALUControl = 5'b00111; // sra
                    else begin
                        ALUControl = 5'bx;
                    end
                end
                else begin
                    ALUControl = 5'bx;    
                end
            end
            else begin
                case (funct3)
                    3'b000: ALUControl = 5'b00000; // addi
                    3'b100: ALUControl = 5'b00010; // xori
                    3'b110: ALUControl = 5'b00011; // ori
                    3'b111: ALUControl = 5'b00100; // andi
                    3'b001: ALUControl = 5'b00101; // slli 
                    3'b101: begin
                        if (funct7[5]) ALUControl = 5'b00111; // srai 
                        else ALUControl = 5'b00110; // srli
                    end
                    3'b010: ALUControl = 5'b01000; // slti
                    3'b011: ALUControl = 5'b01001; // sltiu
                    default: ALUControl = 5'bx; 
                endcase
            end
        end
    end
endmodule