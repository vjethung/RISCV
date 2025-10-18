module alu (
    input   [31:0]  A,
    input   [31:0]  B,
    input   [2:0]   ALUControl,
    output  reg [31:0]  Result,
    output  reg         Cout,
    output              Zero 
);
    wire [31:0] Sum_;
    wire [31:0] B_;
    wire        Cout_;
    wire [31:0] SLT;
    wire oVerflow;

    assign B_ = ALUControl[0] ? (~B) : B;
    assign oVerflow =  (~(A[31]^B[31]^ALUControl[0])) & (A[31]^Sum_[31]) & (~ALUControl[1]);
    assign SLT = oVerflow ^ Sum_[31];
    assign Zero = &(~Result);  

    cla_32bit_adder adder (
        .A(A),
        .B(B_),
        .Cin(ALUControl[0]),
        .Sum(Sum_),
        .Cout(Cout_)
    );

    always @(A or B or ALUControl) begin
        case (ALUControl)
            3'b000, 3'b001: begin
                Result = Sum_;
                Cout = Cout_;
            end
            3'b010: begin
                Result = A & B;
                Cout = 0;
            end
            3'b011: begin 
                Result   = A | B;
                Cout = 0;
            end
            3'b101: begin
                Result = {31'b0, SLT};
                Cout = 0;
            end
            default: begin
                Result = 32'b0;
                Cout = 0;
            end
        endcase
    end
endmodule