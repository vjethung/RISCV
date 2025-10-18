module mux2 #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0]   d0, d1,
    input               s,
    output reg  [WIDTH-1:0]  y      
);
    always @(s  or d0 or d1) begin
        if (s) y = d1;
        else y = d0;
    end
endmodule