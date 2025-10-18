// divider.v
// Module thực hiện các phép chia và lấy số dư 32-bit (signed/unsigned)
// PHIÊN BẢN SỬA LỖI "Illegal part-select" ĐỂ TƯƠNG THÍCH TỐI ĐA

module div (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [1:0]  sel,       // 00=div, 01=divu, 10=rem, 11=remu
    input  wire [31:0] dividend,  
    input  wire [31:0] divisor,   
    output reg  [31:0] result,    
    output reg         done       
);

    //=================================
    // Internal registers
    //=================================
    reg [63:0] rem;          // {remainder, quotient}
    reg [31:0] divd_abs;
    reg [5:0]  count;
    reg        busy;
    reg        sign_divd;
    reg        sign_divs;
    reg [1:0]  sel_store;

    //=================================
    // Absolute value function (2's complement)
    //=================================
    function [31:0] abs_b2;
        input [31:0] x;
        begin
            if (x[31]) abs_b2 = ~x + 1; 
            else       abs_b2 = x;
        end
    endfunction

    //=================================
    // Sequential: 32-cycle shift-subtract division
    //=================================
    // Khai báo wire trung gian cho vòng lặp
    wire [63:0] rem_shifted;
    assign rem_shifted = {rem[62:0], 1'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rem      <= 64'd0;
            divd_abs <= 32'd0;
            count    <= 6'd0;
            busy     <= 1'b0;
            done     <= 1'b1;
            sign_divd <= 1'b0;
            sign_divs <= 1'b0;
            sel_store <= 2'd0;
        end else begin
            if (start && !busy) begin
                // Initialize
                busy      <= 1'b1;
                done      <= 1'b0;
                count     <= 6'd32;
                sel_store <= sel;

                sign_divd <= dividend[31];
                sign_divs <= divisor[31];

                divd_abs <= (sel[0]) ? divisor  : abs_b2(divisor);
                
                rem <= {32'b0, (sel[0] ? dividend : abs_b2(dividend))};
            end else if (busy) begin
                if (count > 0) begin
                    // ==========================================================
                    // PHẦN SỬA LỖI: SỬ DỤNG WIRE TRUNG GIAN "rem_shifted"
                    // ==========================================================
                    // So sánh phần dư sau khi dịch trái với số chia
                    if (rem_shifted[63:32] >= divd_abs) begin
                        // LỚN HƠN HOẶC BẰNG: Trừ và set bit thương = 1
                        rem <= {(rem_shifted[63:32] - divd_abs), rem_shifted[31:1], 1'b1};
                    end else begin
                        // NHỎ HƠN: Chỉ dịch trái (bit thương mới là 0)
                        rem <= rem_shifted;
                    end
                    
                    count <= count - 6'b1;
                    // ==========================================================
                end else begin
                    // Done at cycle 32
                    busy <= 0;
                    done <= 1;
                end
            end
        end
    end

    //=================================
    // Combinational: result update
    //=================================
    always @(*) begin
        if (done && !busy) begin
            case(sel_store)
                // div: signed division
                2'b00: begin
                    if (divisor == 0)
                        result = 32'hFFFF_FFFF;
                    else if (dividend == 32'h8000_0000 && divisor == 32'hFFFF_FFFF)
                        result = 32'h8000_0000;
                    else
                        result = (sign_divd ^ sign_divs) ? (~rem[31:0] + 1) : rem[31:0];
                end
                // divu: unsigned division
                2'b01: begin
                    result = (divisor == 0) ? 32'hFFFF_FFFF : rem[31:0];
                end
                // rem: signed remainder
                2'b10: begin
                    if (divisor == 0)
                        result = dividend;
                    else if (dividend == 32'h8000_0000 && divisor == 32'hFFFF_FFFF)
                        result = 32'd0;
                    else
                        result = sign_divd ? (~rem[63:32] + 1) : rem[63:32];
                end
                // remu: unsigned remainder
                2'b11: begin
                    result = (divisor == 0) ? dividend : rem[63:32];
                end
                default: result = 32'hDEADBEEF; // Should not happen
            endcase
        end else begin
            result = 32'd0; // Hold result at 0 while busy
        end
    end

endmodule