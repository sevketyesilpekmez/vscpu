# VSCPU Processor Design and Implementation

This project implements a fully functional VSCPU (Very Simple CPU) architecture using Verilog HDL. The processor supports the complete instruction set architecture (ISA) defined in the course and extends it with two new instructions: SUB and SUBi.

---

# 1. Architecture Overview

VSCPU is a memory-based single-cycle processor architecture. All operations are performed directly on memory locations rather than using a traditional register file.

The processor consists of:

- Program Counter (PC)
- Instruction Word (IW)
- Memory Module
- Arithmetic Logic Unit (ALU)
- Control Unit
- Temporary Registers (R1, R2)

Each instruction completes in a single clock cycle.

---

# 2. Datapath Design

The datapath includes the following components:

## 2.1 Program Counter (PC)
- Holds the address of the current instruction
- Normally increments by 1
- Can be updated by branch instructions (BZJ, BZJi)

## 2.2 Instruction Word (IW)
The instruction format contains:

- Opcode (3 bits)
- Immediate flag (im)
- Operand addresses / immediate value

Operands are fetched from:
- mem[IW[27:14]]
- mem[IW[13:0]]

## 2.3 Memory
- Unified memory for both instructions and data
- 32-bit wide
- Used as both register storage and program storage

## 2.4 ALU

The ALU performs:

- Addition
- Multiplication
- NAND
- Logical shift right
- Less-than comparison
- Subtraction (via two’s complement logic)

Subtraction is implemented using:

R1 - R2 = R1 + (~R2 + 1)

---

# 3. Control Unit

The control unit decodes:

- Opcode
- Immediate bit (im)
- Special control bit (IW[13]) for SUB/SUBi

Control signals determine:

- ALU operation
- Memory read/write
- PC update logic
- Immediate selection

---

# 4. Instruction Set Implementation

## Arithmetic Instructions
- ADD / ADDi
- MUL / MULi
- SUB / SUBi (New)

## Logical Instructions
- NAND / NANDi

## Shift Instructions
- SRL / SRLi

## Comparison Instructions
- LT / LTi

## Copy Instructions
- CP / CPi
- CPI / CPIi

## Branch Instructions
- BZJ / BZJi

---

# 5. New Instructions

## 5.1 SUB

Opcode: 3'b000  
im = 0  
IW[13] = 1  

Microoperations:

1. R1 ← mem[address1]  
2. R2 ← mem[address2]  
3. R2 ← ~R2  
4. mem[address1] ← R1 - R2  
5. PC ← PC + 1  

---

## 5.2 SUBi

Opcode: 3'b000  
im = 1  
IW[13] = 1  

Microoperations:

1. R1 ← mem[address1]  
2. R2 ← Immediate value  
3. R2 ← ~R2  
4. mem[address1] ← R1 - R2  
5. PC ← PC + 1  

---

# 6. Simulation and Verification

Verification was performed using:

- Instruction-by-instruction waveform inspection
- Testbench-driven execution
- Comparison with reference VSCPU simulator

The following instructions were explicitly verified:

- ADD / ADDi
- MUL / MULi
- SRL / SRLi
- CP / CPi
- LT / LTi
- NAND / NANDi
- BZJ / BZJi
- CPI / CPIi
- SUB / SUBi

---

# 7. Synthesis

The design is fully synthesizable and compatible with:

- Xilinx Vivado
- Synopsys

Resource usage and timing analysis were obtained during synthesis.

---

# 8. Project Structure
