module tob_tb;
    reg clk, rst;
    wire [31:0] imem_addr;
    wire [31:0] imem_data;
    wire [31:0] dmem_addr, dmem_wdata, dmem_rdata;
    wire        dmem_we;
    // Clock
    initial clk = 0;
    always #5 clk = ~clk;
    // Reset
    initial begin
        rst = 1;
        #20 rst = 0;
    end
    // Instantiate core
    top dut (
        .clk(clk),
        .reset(rst),
        .imem_addr(imem_addr),
        .imem_data(imem_data),
        .dmem_addr(dmem_addr),
        .dmem_wdata(dmem_wdata),
        .dmem_we(dmem_we),
        .dmem_rdata(dmem_rdata)
    );

        // Instruction memory
    // reg [31:0] imem [0:255];
    reg [31:0] golden_R_type [255:0];
    reg [7:0]  golden_B_type [255:0];
    reg [31:0] golden_I_type [255:0];
    reg [31:0] golden_S_type [255:0];
    integer instr_count = 0;
    integer fail_count, pass_count;
    initial begin
    //$readmemh("/home/viethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/R_type/R_type.txt", dut.imem.RAM);
    //$readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/B_type/B_type.txt", dut.imem.RAM);
    //$readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/I_type/I_type.txt", dut.imem.RAM);
    //$readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/store/store.txt", dut.imem.RAM);
    $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/bubble_sort/bublesort_instr.txt", dut.imem.RAM);
    // $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/interupt/irq.txt", dut.imem.RQM);
    $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/R_type/golden.hex", golden_R_type);
    $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/B_type/B_type_golden.txt", golden_B_type);
    $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/I_type/I_type_golden.txt", golden_I_type);
    $readmemh("/home/vjethung/Desktop/EDABK/Degital_design/riscv/riscv_pipeline/tb/instr/store/store_golden.txt", golden_S_type);
    end

    task R_type() ;
    begin
    // Monitor WB stage
    if (dut.riscv.dp.RegWriteW == 1) begin
            if (dut.riscv.dp.ResultW !== golden_R_type[instr_count]) begin
                $display("FAIL at instr %0h: expected %h, got %h",
                        instr_count, golden_R_type[instr_count], dut.riscv.dp.ResultW);
                fail_count = fail_count + 1;
            end else begin
                $display("Instr %0h: PASSED ", instr_count);
            // $display("P");
                pass_count = pass_count +1;
            end
            instr_count = instr_count + 1;

        end
    end
    endtask

    task wait_for_nop;
        begin
            // Chờ cho đến khi imem.rd == 0x13
            wait (dut.imem.RD == 32'h00000013);
            #50;
            $display("==> Fetch NOP (0x13), stop test");
            $stop;
        end
    endtask

    integer branch_count = 0;
    reg [31:0] Instr_E;
    always @(posedge clk) begin
        Instr_E <= dut.riscv.dp.InstrD;
    end

    task B_type();
    begin
        // if( (dut.riscv.dp.BranchE == 1) & (dut.riscv.dp.PCSrcE==1) ) begin
        if( (dut.riscv.c.BranchE == 1) & (dut.riscv.c.PCSrcE==1) ) begin
            if(dut.riscv.dp.PCF_ == golden_B_type[branch_count]) begin
                $display("Branch %0h: PASSED", branch_count);
            end else  begin
                $display("FAIL at Instr %0h", branch_count);
            // $stop;
            end 
            branch_count = branch_count +1;
        end else begin
        end
        // if((dut.riscv.dp.BranchE == 1) & (dut.riscv.dp.PCSrcE == 0))  begin
        if((dut.riscv.c.BranchE == 1) & (dut.riscv.c.PCSrcE == 0))  begin
            if(dut.riscv.dp.PCD == golden_B_type[branch_count]) begin
                $display("Branch %0h: PASSED", branch_count);
            end else  begin
                $display("FAIL at Instr %0h", branch_count);
            // $stop;
            end 
            branch_count = branch_count +1;
        end else begin
        end
    end
    endtask

    task I_type() ;
    begin

    // Monitor WB stage

    if (dut.riscv.dp.RegWriteW == 1) begin
            if (dut.riscv.dp.ResultW !== golden_I_type[instr_count]) begin
                $display("FAIL at instr %0h: expected %h, got %h",
                        instr_count, golden_I_type[instr_count], dut.riscv.dp.ResultW);
                fail_count = fail_count + 1;
            end else begin
                $display("Instr %0h: PASSED ", instr_count);
            // $display("P");
                pass_count = pass_count +1;
            end
            instr_count = instr_count + 1;

        end
    end

    endtask
    reg [31:0] data;
    // task store();
    // begin
    //     if(dut.dmem.WE) begin
    //         data = {dut.dmem.RAM[dut.dmem.A],dut.dmem.RAM[dut.dmem.A +1],dut.dmem.RAM[dut.dmem.A +2],dut.dmem.RAM[dut.dmem.A+3]};
    //         $display("data: %0h\n", data );
    //         if(data == golden_S_type[instr_count]) begin
    //             $display("Store %0h: PASSED", instr_count);
                
    //         end else begin
    //             $display("FAIL at instr %0h: expected %h, got %h",
    //                     instr_count, golden_S_type[instr_count], dut.dmem.WD);
    //         end
    //         instr_count = instr_count +1;
    //     end
    // end
    // endtask
    task store();
        reg [31:0] read_data_from_mem;
        begin
            // Sử dụng tín hiệu WE từ module top để đảm bảo tính chính xác
            if(dut.dmem_we) begin 
                // Đợi một khoảng thời gian delta rất nhỏ để RAM cập nhật giá trị
                #1; 
                
                // Đọc lại dữ liệu từ bộ nhớ
                read_data_from_mem = {dut.dmem.RAM[dut.dmem.A+3], dut.dmem.RAM[dut.dmem.A+2], dut.dmem.RAM[dut.dmem.A+1], dut.dmem.RAM[dut.dmem.A]};

                case (dut.riscv.dp.ByteEnable)
                    // Trường hợp SW (store word)
                    4'b1111: begin
                        if (read_data_from_mem == golden_S_type[instr_count]) begin
                            $display("Store Word (sw) %0h: PASSED", instr_count);
                        end else begin
                            $display("FAIL sw %0h: expected %h, got %h",
                                    instr_count, golden_S_type[instr_count], read_data_from_mem);
                        end
                    end
                    
                    // Trường hợp SH (store half-word)
                    4'b0011: begin
                        // Chỉ so sánh 16 bit thấp
                        if (read_data_from_mem[15:0] == golden_S_type[instr_count][15:0]) begin
                            $display("Store Half-word (sh) %0h: PASSED", instr_count);
                        end else begin
                            $display("FAIL sh %0h: expected %h, got %h",
                                    instr_count, golden_S_type[instr_count][15:0], read_data_from_mem[15:0]);
                        end
                    end

                    // Trường hợp SB (store byte)
                    4'b0001: begin
                        // Chỉ so sánh 8 bit thấp
                        if (read_data_from_mem[7:0] == golden_S_type[instr_count][7:0]) begin
                            $display("Store Byte (sb) %0h: PASSED", instr_count);
                        end else begin
                            $display("FAIL sb %0h: expected %h, got %h",
                                    instr_count, golden_S_type[instr_count][7:0], read_data_from_mem[7:0]);
                        end
                    end
                    
                    default: $display("WARNING: Unknown ByteEnable %b for store check", dut.riscv.dp.ByteEnable);

                endcase
                instr_count = instr_count + 1;
            end
        end
    endtask

    reg [39:0] result;
    task bubble_sort;
    begin
    //  $display("Array before arange: %h %h %h %h %h ", result[39:32], result[31:24], result[23:16], result[15:8], result[7:0]);
        fork
            begin
                wait(result == 40'hCAFF002243);
                $display("RAM[0] = %h, Time: %0t\n",dut.dmem.RAM[0], $time);
                $display("RAM[1] = %h, Time: %0t\n",dut.dmem.RAM[1], $time);
                $display("RAM[2] = %h, Time: %0t\n",dut.dmem.RAM[2], $time);
                $display("RAM[3] = %h, Time: %0t\n",dut.dmem.RAM[3], $time);
                $display("RAM[4] = %h, Time: %0t\n",dut.dmem.RAM[4], $time);
                $display("Array after arange: %h %h %h %h %h ", result[39:32], result[31:24], result[23:16], result[15:8], result[7:0]);
                $display("        ****************************               ");
                    $display("        **                        **       |\__||  ");
                    $display("        **  Congratulations !!    **      / O.O  | ");
                    $display("        **                        **    /_____   | ");
                    $display("        **  SIMULATION PASS !!     **   /^ ^ ^ \\  |");
                    $display("        **                        **  |^ ^ ^ ^ |w| ");
                    $display("        ****************************   \\m___m__|_|");
                    $display("\n");
                $finish;
            end

            begin
                #5000;
                $display("        ****************************               ");
                    $display("        **                        **       |\__||  ");
                    $display("        **  OOPS!!                **      / X,X  | ");
                    $display("        **                        **    /_____   | ");
                    $display("        **  SIMULATION Failed!!   **   /^ ^ ^ \\  |");
                    $display("        **                        **  |^ ^ ^ ^ |w| ");
                    $display("        ****************************   \\m___m__|_|");
                    $display("\n");
                $finish;
            end
        join 
    end
    endtask

    // task interupt();
    // begin
    //     if(dut.riscv.dp.CSR.en_irq == 1) begin
    //     //$display("Thuc hien irq\n");
    //     if(dut.riscv.dp.registerFile.regis[11][0] == 1'b1) begin
    //         //$display("Reg[11] = %h, time = %t", dut.riscv.dp.registerFile.regis[11], $time);
    //         $display("LED ON !, time =%t \n", $time);
    //     end else begin
    //     //$display("Reg[11] = %h, time = %t", dut.riscv.dp.registerFile.regis[11], $time);
    //     $display("LED OFF !, time = %t\n", $time);
    //     end
    //     end
    // end
    // endtask

    always @(posedge clk) begin
    // R_type();
    // B_type();
    // I_type();
    // store();
    // interupt();
    result = {dut.dmem.RAM[4],dut.dmem.RAM[3], dut.dmem.RAM[2],  dut.dmem.RAM[1], dut.dmem.RAM[0]};
    $display("result = %h\n", result);
    
    end
    initial begin
        #10000;
    //    $stop;
    // wait_for_nop();
        
        #30;
        dut.dmem.RAM[4] = 8'd67;
        dut.dmem.RAM[3] = -8'd54;
        dut.dmem.RAM[2] = 8'd0;
        dut.dmem.RAM[1] = 8'd34;
        dut.dmem.RAM[0] = -8'd1;
        
        $display("Array before arange: %h %h %h %h %h ", result[39:32], result[31:24], result[23:16], result[15:8], result[7:0]);
        //bubble_sort();
    end
endmodule
