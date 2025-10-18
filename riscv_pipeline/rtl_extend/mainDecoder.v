module mainDecoder (
    input   [6:0]   op,
    input   [2:0]   funct3,
    output          PCTargetSrc, 
    output          RegWrite, 
    output  [2:0]   ResultSrc,   // result_src_2:0 xử lí thêm CSR
    output          MemWrite,
    output          Jump,
    output          Branch, 
    output          ALUSrc,
    output  [2:0]   ImmSrc,
    output  [1:0]   ALUOp,
    output reg [1:0]    writeSelect,
    output reg [2:0]    readSelect
);
    reg [13:0]  controls;

    assign {RegWrite, ImmSrc, ALUSrc, MemWrite, 
            ResultSrc, Branch, ALUOp, Jump, PCTargetSrc} = controls;

    always @(op) begin
        case (op)
            // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_PCTargetSrc
            7'b0000011: controls = 14'b1_000_1_0_001_0_00_0_0; // I (load)
            7'b0100011: controls = 14'b0_001_1_1_000_0_00_0_0; // S
            7'b0110011: controls = 14'b1_000_0_0_000_0_10_0_0; // R–type
            7'b0010011: controls = 14'b1_000_1_0_000_0_10_0_0; // I–type ALU
            7'b0110111: controls = 14'b1_100_1_0_000_1_00_0_0; // U lui
            7'b0010111: controls = 14'b1_100_1_0_011_1_00_0_0; // U auipc
            7'b1100011: controls = 14'b0_010_0_0_000_1_01_0_0; // B
            7'b1101111: controls = 14'b1_011_0_0_010_0_00_1_0; // J (jal)
            7'b1100111: controls = 14'b1_000_0_0_000_0_11_0_1; // I (jalr)
            default:    controls = 14'bx; 
        endcase
    end
    always @(op or funct3) begin
        if (op == 7'b0000011) begin
            case (funct3)
                3'b000: begin // lb
                    readSelect = 3'b000;
                    writeSelect = 2'bx;
                end 
                3'b001: begin // lh
                    readSelect = 3'b001;
                    writeSelect = 2'bx;
                end
                3'b010: begin // lw
                    readSelect = 3'b010;
                    writeSelect = 2'bx;
                end
                3'b100: begin // lbu
                    readSelect = 3'b011;
                    writeSelect = 2'bx;
                end
                3'b101: begin // lbhu
                    readSelect = 3'b100;
                    writeSelect = 2'bx;
                end
                default: begin
                    readSelect = 3'bx;
                    writeSelect = 2'bx;
                end
            endcase
        end
        else if  (op == 7'b0100011) begin
            case (funct3)
                3'b010: begin // sw
                    readSelect = 3'bx;
                    writeSelect = 2'b00;
                end
                3'b001: begin // sh
                    readSelect = 3'bx;
                    writeSelect = 2'b01;
                end
                3'b000: begin // sb
                    readSelect = 3'bx;
                    writeSelect = 2'b10;
                end
                default: begin
                    readSelect = 3'bx;
                    writeSelect = 2'bx;
                end
            endcase
        end
        else begin
            readSelect = 3'bx;
            writeSelect = 2'bx;
        end
    end
endmodule