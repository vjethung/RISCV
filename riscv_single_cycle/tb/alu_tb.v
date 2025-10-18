module alu_tb;
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0]  ALUControl;
    wire [31:0] Result;
    wire        Cout;
    wire        Zero;

    alu uut(
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Cout(Cout),
        .Zero(Zero)
    );

    initial begin
        // Initialize inputs
        A = 32'h00000005; // 5
        B = 32'h00000003; // 3
        ALUControl = 3'b000; // Add

        #10;
        $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test Add
        #10 ALUControl = 3'b000;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test Subtract
        #10 ALUControl = 3'b001;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test AND
        #10 ALUControl = 3'b010;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test OR
        #10 ALUControl = 3'b011;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test SLT (A < B should be 1, since 5 < 3 is false)
        #10 A = 32'h00000005; B = 32'h00000003;
        ALUControl = 3'b101;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        
        #10 A = 32'h00000003; B = 32'h00000005;
        #10 ALUControl = 3'b001;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);


        // Test SLT (A < B should be 0, since 3 < 5 is true)
        ALUControl = 3'b101;
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test Overflow (A + B exceeds 32-bit signed max)
        #10 A = 32'h7FFFFFFF; // 2^31 - 1 (max positive)
        B = 32'h00000001; // 1
        ALUControl = 3'b000; // Add
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);
    
        // Test Overflow (A + B exceeds 32-bit signed max)
        #10 A = 32'hFFFFFFFF; // 2^31 - 1 (max positive)
        B = 32'h00000001; // 1
        ALUControl = 3'b000; // Add
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        // Test Overflow (A + B exceeds 32-bit signed max)
        #10 A = 32'h7FFFFFFF; // 2^31 - 1 (max positive)
        B = 32'h7FFFFFFF; // 1
        ALUControl = 3'b001; // Add
        #10 $display("Time=%0t: A=%h, B=%h, ALUControl=%b, Result=%h, Cout=%b, Zero=%b", $time, A, B, ALUControl, Result, Cout, Zero);

        #10 $finish;
    end
    
endmodule