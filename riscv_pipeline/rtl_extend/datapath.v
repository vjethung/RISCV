module datapath (
    input           clk, 
    input           reset,
    // Tín hiệu điều khiển từ Control Unit
    input           RegWriteW,
    input           RegWriteM,
    input [2:0]     ResultSrcW,
    input [1:0]     writeSelectM, // store (sb, sh, sw)
    input [2:0]     readSelectM,  // load (lb, lh, lw, lbu, lhu)  
    input           PCTargetSrcE,
    input           ResultSrcE0,
    input           PCSrcE, 
    input [4:0]     ALUControlE,
    input           ALUSrcE,
    input [2:0]     ImmSrcD,
    // Dữ liệu từ bên ngoài
    input [31:0]    InstrF,
    input [31:0]    ReadDataM, // Từ data_mem (full word)

    // output          Equal, notEqual,
    // output          GE, LT,
    output              ALUbranch,
    output reg  [31:0]  PCF,
    output reg  [31:0]  InstrD,
    
    output      [31:0]  ALUResultM_out, // DataAdr 
    output reg  [3:0]   ByteEnable, // Byte-enable cho data_mem
    output reg  [31:0]  StoreData,  // Dữ liệu ghi đã align cho data_mem

    output              CLRD // FlushE
);
    
    reg     [31:0]  PCF_, PCD, PCE;
    wire    [31:0]  RD1D, RD2D;
    reg     [31:0]  RD1E, RD2E;
    reg     [31:0]  SrcAE, SrcBE;
    wire     [31:0] ALUResultE;
    reg     [31:0]  ALUResultM, ALUResultW;
    reg     [31:0]  WriteDataM, WriteDataE;
    wire    [4:0]   Rs1D, Rs2D, RdD;
    reg     [4:0]   Rs1E, Rs2E, RdE, RdM, RdW;
    reg     [31:0]  ImmExtD, ImmExtE; 
    wire            enPC; // StallF
    wire            enF;  // StallD
    wire            clrF; // FlushD (xóa)
    wire    [31:0]  PCPlus4F; 
    reg     [31:0]  PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W;
    reg     [31:0]  PCTargetE, PCTargetM, PCTargetW;
    reg     [31:0]  ResultW;
    reg     [31:0]  ReadDataW;
    wire    [1:0]   ForwardAE, ForwardBE;

    assign ALUResultM_out = ALUResultM;

    // FETCH STAGE ----------------------------------------------------------------------------------------//
    // mux2_PCF_
    always @(PCSrcE or PCPlus4F or PCTargetE) begin
        if (PCSrcE) 
            PCF_ = PCTargetE;
        else 
            PCF_ = PCPlus4F;
    end

    // next PC logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            PCF <= 0;
        else if (enPC)  // enPC - StallF
            PCF <= PCF;
        else 
            PCF <= PCF_;
    end

    // PC add4
    assign PCPlus4F = PCF + 32'd4;

    // Fetch/Decode pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            PCD <= 0;
            PCPlus4D <= 0;
            InstrD <= 0;
        end
        else if (clrF) begin // clrF - FlushD
            PCD <= 0;
            PCPlus4D <= 0;
            InstrD <= 0;
        end
        else if (enF) begin // enF - StallD
            PCD <= PCD;
            PCPlus4D <= PCPlus4D;
            InstrD <= InstrD;
        end
        else begin
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
            InstrD <= InstrF;
        end
    end

    // DECODE STAGE ----------------------------------------------------------------------------------------//
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD  = InstrD[11:7];
    // extend
    always @(InstrD or ImmSrcD) begin
        case (ImmSrcD)
            3'b000: // I type (Data processing with immediate and loads) 
                ImmExtD = {{20{InstrD[31]}}, InstrD[31:20]}; // 12 bit-signed immediate
            3'b001: // S type (Stores) 
                ImmExtD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};
            3'b010: // B type (Branhes)
                ImmExtD = {{20{InstrD[31]}}, InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};
            3'b011: // J type (jal)
                ImmExtD = {{12{InstrD[31]}}, InstrD[19:12], InstrD[20], InstrD[30:21] , 1'b0};
            3'b100: // U type
                ImmExtD = {InstrD[31:12], 12'b0};
            default: 
                ImmExtD = 32'b0;
        endcase
    end 
    //register file logic
    register_file    rf(
        .clk(clk), 
        //.reset(reset),
        .WE3(RegWriteW), 
        .rA1(Rs1D), 
        .rA2(Rs2D),
        .wA3(RdW), 
        .wD3(ResultW), 
        .RD1(RD1D), 
        .RD2(RD2D)
    );
    // Decode/Execute pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            ImmExtE <= 0;
            PCPlus4E <= 0;
        end
        else if (CLRD) begin
            RD1E <= 0;
            RD2E <= 0;
            PCE <= 0;
            Rs1E <= 0;
            Rs2E <= 0;
            RdE <= 0;
            ImmExtE <= 0;
            PCPlus4E <= 0;
        end
        else begin
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
        end
    end
    
    // EXECUTE STAGE ----------------------------------------------------------------------------------------//
    // mux srcA
    always @(ForwardAE or RD1E or ResultW or ALUResultM) begin
        case (ForwardAE)
            2'b00: SrcAE = RD1E;
            2'b01: SrcAE = ResultW;
            2'b10: SrcAE = ALUResultM;
            default: SrcAE = 0;
        endcase
    end
    // mux WriteDataE 
    always @(ForwardBE or RD2E or ResultW or ALUResultM) begin
        case (ForwardBE)
            2'b00: WriteDataE = RD2E;
            2'b01: WriteDataE = ResultW;
            2'b10: WriteDataE = ALUResultM;
            default: WriteDataE = 0;
        endcase
    end
    // mux srcB
    always @(ALUSrcE or WriteDataE or ImmExtE) begin
        if (ALUSrcE) 
            SrcBE = ImmExtE;
        else 
            SrcBE = WriteDataE;
    end
    // PC Target
    wire [31:0] PCTargetRes;
    assign  PCTargetRes = ImmExtE + PCE;
    wire    doneDiv;
    // ALU logic    
    ALU alu(
        .clk(clk),
        .rst(reset),
        .ALUControl(ALUControlE), 
        .SrcA(SrcAE), 
        .SrcB(SrcBE), 
        .ALUResult(ALUResultE),
        // .Equal(Equal),
        // .notEqual(notEqual),
        // .GE(GE),
        // .LT(LT),
        .ALUbranch(ALUbranch),
        .done_div(doneDiv)
    ); 
    // mux PC TargetE
    always @(PCTargetSrcE or ALUResultE or PCTargetRes) begin
        if (PCTargetSrcE)
            PCTargetE = ALUResultE;
        else
            PCTargetE = PCTargetRes;
    end
    // Execute/Memory pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResultM <= 0;
            WriteDataM <= 0;
            PCTargetM <= 0;
            RdM <= 0;
            PCPlus4M <= 0;
        end
        else begin
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            PCTargetM <= PCTargetE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;
        end
    end

    // MEMORT STAGE ----------------------------------------------------------------------------------------//
    // wire [1:0] offset = ALUResultM[1:0];  // DataAdr 

    // Logic cho Store (sb, sh, sw)
    always @(writeSelectM or WriteDataM) begin
        case (writeSelectM)
            2'b00: begin  // sw: Ghi full word
                ByteEnable = 4'b1111;
                StoreData = WriteDataM;  // Ghi toàn bộ 32-bit
            end
            2'b01: begin  // sh: Ghi halfword
                ByteEnable = 4'b0011;
                StoreData = {16'b0, WriteDataM[15:0]};
                // case (offset)
                //     2'b00, 2'b10: begin  // Chỉ hỗ trợ địa chỉ căn chỉnh halfword (0 hoặc 2)
                //         ByteEnable = (offset == 2'b00) ? 4'b0011 : 4'b1100;
                //         StoreData = (offset == 2'b00) ? {16'b0, WriteDataM[15:0]} : {WriteDataM[15:0], 16'b0};
                //     end
                //     default: begin  // Misalignment
                //         ByteEnable = 4'b0000;
                //         StoreData = 32'b0;
                //     end
                // endcase
            end
            2'b10: begin  // sb: Ghi byte
                ByteEnable = 4'b0001;
                StoreData = {24'b0, WriteDataM[7:0]};
                // case (offset)
                //     2'b00: begin
                //         ByteEnable = 4'b0001;  // Ghi byte 0
                //         StoreData = {24'b0, WriteDataM[7:0]};
                //     end
                //     2'b01: begin
                //         ByteEnable = 4'b0010;  // Ghi byte 1
                //         StoreData = {16'b0, WriteDataM[7:0], 8'b0};
                //     end
                //     2'b10: begin
                //         ByteEnable = 4'b0100;  // Ghi byte 2
                //         StoreData = {8'b0, WriteDataM[7:0], 16'b0};
                //     end
                //     2'b11: begin
                //         ByteEnable = 4'b1000;  // Ghi byte 3
                //         StoreData = {WriteDataM[7:0], 24'b0};
                //     end
                //     default: begin
                //         ByteEnable = 4'b0000;
                //         StoreData = 32'b0;
                //     end
                // endcase
            end
            default: begin
                ByteEnable = 4'b0000;
                StoreData = 32'b0;
            end
        endcase
    end

    // Logic cho Load (lb, lh, lw, lbu, lhu)
    reg [31:0] LoadData;
    always @(readSelectM or ReadDataM) begin
        case (readSelectM)
            3'b000: begin  // lb: Sign-extend byte
                LoadData = {{24{ReadDataM[7]}}, ReadDataM[7:0]};
                // case (offsetLoadData = {{24{ReadDataM[7]}}, ReadDataM[7:0]};)
                //     2'b00: 
                //     2'b01: LoadData = {{24{ReadDataM[15]}}, ReadDataM[15:8]};
                //     2'b10: LoadData = {{24{ReadDataM[23]}}, ReadDataM[23:16]};
                //     2'b11: LoadData = {{24{ReadDataM[31]}}, ReadDataM[31:24]};
                //     default: LoadData = 32'b0;  // Misalignment
                // endcase
            end
            3'b001: begin  // lh: Sign-extend halfword
                LoadData = {{16{ReadDataM[15]}}, ReadDataM[15:0]};
                // case (offset)
                //     2'b00: LoadData = {{16{ReadDataM[15]}}, ReadDataM[15:0]};
                //     2'b10: LoadData = {{16{ReadDataM[31]}}, ReadDataM[31:16]};
                //     default: LoadData = 32'b0;  // Misalignment
                // endcase
            end
            3'b010: begin  // lw: Full word
                LoadData = ReadDataM;
                // if (offset == 2'b00)  // Yêu cầu căn chỉnh word
                //     LoadData = ReadDataM;
                // else
                //     LoadData = 32'b0;  // Misalignment
            end
            3'b011: begin  // lbu: Zero-extend byte
                LoadData = {24'b0, ReadDataM[7:0]};
                // case (offset)
                //     2'b00: LoadData = {24'b0, ReadDataM[7:0]};
                //     2'b01: LoadData = {24'b0, ReadDataM[15:8]};
                //     2'b10: LoadData = {24'b0, ReadDataM[23:16]};
                //     2'b11: LoadData = {24'b0, ReadDataM[31:24]};
                //     default: LoadData = 32'b0;  // Misalignment
                // endcase
            end
            3'b100: begin  // lhu: Zero-extend halfword
                LoadData = {16'b0, ReadDataM[15:0]};
                // case (offset)
                //     2'b00: LoadData = {16'b0, ReadDataM[15:0]};
                //     2'b10: LoadData = {16'b0, ReadDataM[31:16]};
                //     default: LoadData = 32'b0;  // Misalignment
                // endcase
            end
            default: LoadData = 32'b0;
        endcase
    end

    // Memory/Writeback pipeline register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResultW <= 0;
            ReadDataW <= 0;
            PCTargetW <= 0;
            RdW <= 0;
            PCPlus4W <= 0;
        end
        else begin
            ALUResultW <= ALUResultM; 
            ReadDataW <= LoadData;
            PCTargetW <= PCTargetM; 
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;
        end
    end
    // WRITEBACK STAGE ----------------------------------------------------------------------------------------//
    // mux resultW
    always @(ResultSrcW or ALUResultW or ReadDataW or PCPlus4W or PCTargetW) begin
        case (ResultSrcW)
            3'b000: ResultW = ALUResultW;
            3'b001: ResultW = ReadDataW;
            3'b010: ResultW = PCPlus4W;
            3'b011: ResultW = PCTargetW;
            default: ResultW = 0;
        endcase
    end

    // hazard unit
    hazard_unit Hazard_Unit(
        .Rs1D(Rs1D),
        .Rs1E(Rs1E),
        .Rs2D(Rs2D),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .PCSrcE(PCSrcE),
        .ResultSrcE0(ResultSrcE0),
        .doneDiv(doneDiv),

        .StallF(enPC),
        .StallD(enF),
        .FlushD(clrF),
        .FlushE(CLRD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );    
endmodule