module testbench;
    reg     clk;
    reg     reset;
    wire    [31:0]  writedata, dataadr;
    wire            memwrite;

    top dut(
        .clk(clk), 
        .reset(reset), 
        .WriteData(writedata), 
        .DataAdr(dataadr), 
        .MemWrite(memwrite)
    );

    initial begin
        reset <= 1; #22; reset <= 0;
    end

    always begin
        clk <= 1; #5; clk <= 0; #5;
    end

    always @(negedge clk) begin
        if (memwrite) begin
            if (dataadr === 100 & writedata === 25) begin
                $display("Simulation succeeded");
                $stop;
            end
            else if (dataadr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end
endmodule