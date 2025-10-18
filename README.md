## 📘 Introduction
This project implements two versions of a **32-bit RISC-V (RV32)** processor:
- **Single-Cycle CPU:** each instruction is executed within a single clock cycle.  
- **5-Stage Pipeline CPU:** improves performance by dividing instruction execution into five parallel stages.

Both architectures are designed based on the book  
**_Digital Design and Computer Architecture – Sarah L. Harris & David Money Harris_**,  
and extended to support the **RISC-V RV32I** instruction set and a partial subset of **RV32M** (only multiplication).

---

## ⚙️ Architectural Overview

### 🔸 Single-Cycle CPU
In this version, each instruction completes all its operations within a single clock cycle.  
Main components include:
- **Program Counter (PC)**  
- **Instruction Memory**  
- **Register File**  
- **ALU**  
- **Data Memory**  
- **Control Unit & ALU Decoder**

**Advantages:** Simple architecture, easy to understand.  
**Disadvantages:** Long clock period due to the longest datapath delay.

---

### 🔸 5-Stage Pipeline CPU

The pipelined version divides the instruction execution process into **five stages** operating in parallel:

| Stage | Name | Function |
|:------:|:-------------------|:-------------------------------|
| IF | Instruction Fetch | Fetch instruction from instruction memory |
| ID | Instruction Decode | Decode instruction and read source registers |
| EX | Execute | Perform arithmetic/logic operation or calculate memory address |
| MEM | Memory Access | Access data memory |
| WB | Write Back | Write the result back to the destination register |

---

## 🧩 Main Functional Units

### **Controller**
Decodes the instruction `opcode` and generates control signals for the datapath:  
`RegWrite`, `ALUSrc`, `MemRead`, `MemWrite`, `MemToReg`, `Branch`, `Jump`, `ALUOp`.

### **ALU Control**
Generates specific control signals for the ALU based on `ALUOp`, `funct3`, and `funct7`.

### **Hazard Unit**
Detects and handles pipeline hazards:
- **Data hazards:** insert NOPs or apply **forwarding**.  
- **Control hazards:** handle branch and jump instructions.

### **Forwarding Unit**
Provides data forwarding from later stages to minimize pipeline stalls.

---

## 🔤 Supported Instructions

| CPU Version | RV32I | RV32M |
|--------------|--------|--------|
| Single-Cycle | ✅ (basic subset) | ❌ |
| 5-Stage Pipeline | ✅ (full) | ⚙️ (only supports `MUL`) |

Detailed decoding and control signal mapping are described in the following document:  
👉 [Google Sheet - RV32I/M Decoder Table](https://docs.google.com/spreadsheets/d/1RlH-kBEFa-uQ9ZMV0-NAmtZn40r03oS4xBgaN7ddRck/edit?usp=sharing)

---

## 🧱 Architectural Diagram

<p align="center">
  <img src="riscv_pipeline/images/5StagePipelineR.png" width="800">
</p>

The diagram above illustrates the **5-Stage Pipelined CPU** architecture, including control, forwarding, hazard detection units, and pipeline registers.

---

## 🧰 Development Environment

- **Language:** Verilog HDL  
- **Simulation Tool:** ModelSim / QuestaSim  
- **Synthesis Tool (optional):** Vivado / Quartus  
- **Editor:** Visual Studio Code  

---

## 📚 References

- *Digital Design and Computer Architecture*, Sarah L. Harris & David Money Harris  
- *The RISC-V Instruction Set Manual, Volume I: User-Level ISA (RV32I/M)*  

---

## 👤 Author

**Nguyễn Việt Hưng**  
- Student at Hanoi University of Science and Technology (HUST)  
- Major: Electronics and Telecommunications Engineering  

---

## 📁 Suggested Repository Structure

