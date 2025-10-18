module ALU(
    input clk,
    input rst,
    input  [4:0]  ALUControl,   
    input  [31:0] SrcA, SrcB,

    output  [31:0]  ALUResult,
    // output reg      Equal, notEqual,
    // output reg      GE, LT,
    output reg      ALUbranch,
    output          done_div
);
    wire Equal, notEqual, GE, LT;
    wire signed [31:0] signedA = SrcA;
    wire signed [31:0] signedB = SrcB;

    // Mul instantiation and control
    reg [1:0] mul_mode;
    wire [63:0] mul_product;

    mul mul_dut (
        .mul_mode(mul_mode),
        .a(SrcA),
        .b(SrcB),
        .product(mul_product)
    );
    always @(*) begin
        case (ALUControl)
            5'b01010: mul_mode = 2'b11;  // mul (S*S)
            5'b01011: mul_mode = 2'b11;  // mulh (S*S)
            5'b01100: mul_mode = 2'b01;  // mulhsu (S*U)
            5'b01101: mul_mode = 2'b00;  // mulhu (U*U)
            default: mul_mode = 2'bxx;
        endcase
    end

    // Div instantiation and control
    reg [1:0] div_sel;
    wire [31:0] div_result;
    reg start_div;  
    reg div_started;

    div div_dut (
        .clk(clk),
        .rst(rst),
        .start(start_div),
        .sel(div_sel),
        .dividend(SrcA),
        .divisor(SrcB),
        .result(div_result),
        .done(done_div)
    );
    // Sequential logic để kiểm soát start_div
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div_started <= 1'b0;
        end else begin
            if (done_div) begin
                div_started <= 1'b0; // Reset khi phép chia hoàn tất
            end else if (start_div && !div_started) begin
                div_started <= 1'b1; // Đánh dấu phép chia đã bắt đầu
            end
        end
    end
    always @(*) begin
        case (ALUControl)
            5'b01110: begin
                div_sel = 2'b00;  // div
                start_div = !div_started; // Chỉ start nếu chưa bắt đầu
            end
            5'b01111: begin
                div_sel = 2'b01;  // divu
                start_div = !div_started;
            end
            5'b10000: begin
                div_sel = 2'b10;  // rem
                start_div = !div_started;
            end
            5'b10001: begin
                div_sel = 2'b11;  // remu
                start_div = !div_started;
            end
            default: begin
                div_sel = 2'bxx;  // Giá trị mặc định an toàn
                start_div = 1'b0; // Không start cho các lệnh khác
            end
        endcase
    end

    // ALU result computation (combinational for non-div, from div_result for div ops)
    reg [31:0] result;
    
    always @(*) begin
        case (ALUControl)
            5'b00000: result = SrcA + SrcB;                   // add, addi, load, store, auipc, lui, jal(option), jalr
            5'b00001: result = SrcA - SrcB;                   // sub
            5'b00010: result = SrcA ^ SrcB;                   // xor, xori
            5'b00011: result = SrcA | SrcB;                   // or, ori
            5'b00100: result = SrcA & SrcB;                   // and, andi
            5'b00101: result = SrcA << SrcB[4:0];             // sll, slli
            5'b00110: result = SrcA >> SrcB[4:0];             // srl, srli
            5'b00111: result = signedA >>> SrcB[4:0];         // sra, srai
            5'b01000: result = (signedA < signedB) ? 32'd1 : 32'd0;  // slt, slti
            5'b01001: result = (SrcA < SrcB) ? 32'd1 : 32'd0;        // sltu, sltiu
            5'b01010: result = mul_product[31:0];             // mul
            5'b01011: result = mul_product[63:32];            // mulh
            5'b01100: result = mul_product[63:32];            // mulhsu
            5'b01101: result = mul_product[63:32];            // mulhu
            5'b01110: result = div_result;                    // div
            5'b01111: result = div_result;                    // divu
            5'b10000: result = div_result;                    // rem
            5'b10001: result = div_result;                    // remu
            default:  result = 32'bx;                         // For branch comparisons or unknown
        endcase
    end
    assign ALUResult = result;

    // Flags computation
    reg use_unsigned;
    always @(*) begin
        case (ALUControl)
            5'b10010: use_unsigned = 1'b0;  // beq
            5'b10011: use_unsigned = 1'b0;  // bne
            5'b10100: use_unsigned = 1'b0;  // blt
            5'b10101: use_unsigned = 1'b0;  // bge
            5'b10110: use_unsigned = 1'b1;  // bltu
            5'b10111: use_unsigned = 1'b1;  // bgeu
            default: 
                use_unsigned = 1'bx;
        endcase
    end

    wire lt = use_unsigned ? (SrcA < SrcB) : (signedA < signedB);
    wire ge = use_unsigned ? (SrcA >= SrcB) : (signedA >= signedB);
    
    assign Equal = (SrcA == SrcB);
    assign notEqual = (SrcA != SrcB);
    assign LT = lt;
    assign GE = ge;
    
    always @(ALUControl or SrcA or SrcB or LT or GE or Equal or notEqual) begin
        case (ALUControl)
            5'b10010: begin // beq
                ALUbranch = Equal;
            end
            5'b10011: begin // bne
                ALUbranch = notEqual;
            end
            5'b10100, 5'b10110: begin // blt, bltu
                ALUbranch = LT;
            end  
            5'b10101, 5'b10111: begin // bge, bgeu
                ALUbranch = GE;
            end
            default: ALUbranch = 0;
        endcase
    end
endmodule
