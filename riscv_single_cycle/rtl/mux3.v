module mux3 #(
    parameter WIDTH = 8
) (
    input   [WIDTH-1:0]   d0, d1, d2,
    input   [1:0]         s,
    output  reg [WIDTH-1:0]  y      
);
    always @(s or d0 or d1 or d2) begin
        case (s)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            default: y = 0;
        endcase
    end
endmodule