module cla_32bit_adder (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] Sum,
    output Cout
);
    wire [8:0] carry_wires;
    
    assign carry_wires[0] = Cin;
    
    assign Cout = carry_wires[8];
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_block_loop
            cla_4bit_block cla_inst (
                .A(A[4*i + 3 : 4*i]),
                .B(B[4*i + 3 : 4*i]),
                .Cin(carry_wires[i]),
                .S(Sum[4*i + 3 : 4*i]),
                .Cout(carry_wires[i+1])
            );
        end
    endgenerate

endmodule