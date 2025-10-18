module mul(
    input         [1:0] mul_mode, // 00: U*U, 01: S*U, 10: U*S, 11: S*S
    input         [31:0] a, b,      
    output        [63:0] product  
);

    reg [63:0] abs_a, abs_b;     
    reg [63:0] partial_sum;      
    reg [63:0] p_result;
    reg        sign;             

    always @(*) begin
        // === Tính trị tuyệt đối nếu signed ===
        case (mul_mode)
            // Chế độ 00: Unsigned * Unsigned
            2'b00: begin
                abs_a = {32'b0, a};
                abs_b = {32'b0, b};
                sign  = 1'b0;
            end
            
            // Chế độ 01: Signed A * Unsigned B
            2'b01: begin
                abs_a = a[31] ?(~{32'hFFFF_FFFF,a} + 1) : {32'b0,a}; 
                abs_b = {32'b0, b};
                sign  = a[31];
            end

            // Chế độ 10: Unsigned A * Signed B
            2'b10: begin
                abs_a = {32'b0, a};
                abs_b = b[31] ? (~{32'hFFFF_FFFF,b} + 1) : {32'b0,b};
                sign  = b[31];
            end

            // Chế độ 11: Signed A * Signed B
            2'b11: begin
                abs_a = a[31] ? (~{32'hFFFF_FFFF,a} + 1) : {32'b0,a};
                abs_b = b[31] ? (~{32'hFFFF_FFFF,b} + 1) : {32'b0,b};
                sign  = a[31] ^ b[31];
            end
            
            default: begin
                abs_a = 64'dx;
                abs_b = 64'dx;
                sign  = 1'bx;
            end
        endcase

        // === Thuật toán shift-and-add, không dùng for ===
         partial_sum = 64'b0;
        if (abs_b[0])  partial_sum = partial_sum + (abs_a << 0);
        if (abs_b[1])  partial_sum = partial_sum + (abs_a << 1);
        if (abs_b[2])  partial_sum = partial_sum + (abs_a << 2);
        if (abs_b[3])  partial_sum = partial_sum + (abs_a << 3);
        if (abs_b[4])  partial_sum = partial_sum + (abs_a << 4);
        if (abs_b[5])  partial_sum = partial_sum + (abs_a << 5);
        if (abs_b[6])  partial_sum = partial_sum + (abs_a << 6);
        if (abs_b[7])  partial_sum = partial_sum + (abs_a << 7);
        if (abs_b[8])  partial_sum = partial_sum + (abs_a << 8);
        if (abs_b[9])  partial_sum = partial_sum + (abs_a << 9);
        if (abs_b[10]) partial_sum = partial_sum + (abs_a << 10);
        if (abs_b[11]) partial_sum = partial_sum + (abs_a << 11);
        if (abs_b[12]) partial_sum = partial_sum + (abs_a << 12);
        if (abs_b[13]) partial_sum = partial_sum + (abs_a << 13);
        if (abs_b[14]) partial_sum = partial_sum + (abs_a << 14);
        if (abs_b[15]) partial_sum = partial_sum + (abs_a << 15);
        if (abs_b[16]) partial_sum = partial_sum + (abs_a << 16);
        if (abs_b[17]) partial_sum = partial_sum + (abs_a << 17);
        if (abs_b[18]) partial_sum = partial_sum + (abs_a << 18);
        if (abs_b[19]) partial_sum = partial_sum + (abs_a << 19);
        if (abs_b[20]) partial_sum = partial_sum + (abs_a << 20);
        if (abs_b[21]) partial_sum = partial_sum + (abs_a << 21);
        if (abs_b[22]) partial_sum = partial_sum + (abs_a << 22);
        if (abs_b[23]) partial_sum = partial_sum + (abs_a << 23);
        if (abs_b[24]) partial_sum = partial_sum + (abs_a << 24);
        if (abs_b[25]) partial_sum = partial_sum + (abs_a << 25);
        if (abs_b[26]) partial_sum = partial_sum + (abs_a << 26);
        if (abs_b[27]) partial_sum = partial_sum + (abs_a << 27);
        if (abs_b[28]) partial_sum = partial_sum + (abs_a << 28);
        if (abs_b[29]) partial_sum = partial_sum + (abs_a << 29);
        if (abs_b[30]) partial_sum = partial_sum + (abs_a << 30);
        if (abs_b[31]) partial_sum = partial_sum + (abs_a << 31);

        // Nếu sign=1 (âm), lấy bù 2. Ngược lại giữ nguyên.
        p_result = sign ? (~partial_sum + 1) : partial_sum;
    end

    assign product = p_result;
endmodule
