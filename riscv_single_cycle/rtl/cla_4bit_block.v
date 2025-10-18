module cla_4bit_block (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G, P;
    wire C1, C2, C3;

    assign P[0] = A[0] ^ B[0];
    assign G[0] = A[0] & B[0];
    assign P[1] = A[1] ^ B[1];
    assign G[1] = A[1] & B[1];
    assign P[2] = A[2] ^ B[2];
    assign G[2] = A[2] & B[2];
    assign P[3] = A[3] ^ B[3];
    assign G[3] = A[3] & B[3];

    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & C1);
    assign C3 = G[2] | (P[2] & C2);
    assign Cout = G[3] | (P[3] & C3);

    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C1;
    assign S[2] = P[2] ^ C2;
    assign S[3] = P[3] ^ C3;

endmodule