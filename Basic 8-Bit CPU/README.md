# Introduction
- This project implements a tiny **8-bit accumulator CPU** with a **single unified memory** for instructions and data.
- The design is fully synchronous (active-low reset) and runs a simple **two-phase Fetch/Execute** sequence controlled by a finite-state machine.

## Architecture
<img width="750" alt="image" src="https://github.com/user-attachments/assets/941ea950-3067-4ebb-96a6-167df06e5b08">

## Datapath & flow
- The core consists of an **Accumulator (ACC)**, **ALU**, **Instruction Register (IR)**, **Program Counter (PC)**, an **address MUX**, and a **synchronous memory**.
  + **Fetch:** the **PC** drives the memory address; the instruction byte is latched into **IR** and the PC increments.
  + **Execute:** the controller decodes **IR[7:5]** (opcode) and uses **IR[4:0]** as the operand/address to drive micro-operations and, when needed, to select the memory address.

## Instruction set (3-bit opcode)
- `HLT` (halt), `SKZ` (skip next if **ACC==0** via Z flag), `ADD`, `AND`, `XOR` (operate on `ACC` with `MEM[addr]`), `LDA` (`ACC ← MEM[addr]`), `STO` (`MEM[addr] ← ACC`), `JMP` (`PC ← addr`).

## Modules
- Synthesizable building blocks: `mem.sv` (synchronous memory), `alu.sv` (ADD/AND/XOR + zero flag), `count.sv` (PC), `register.sv` (generic reg for ACC/IR), `scale_mux.sv` (address/data MUX), and a `control` FSM sequencing the states.
- Memory width/depth are parameterizable; sample programs are provided in `CPUtest*.dat`.

## Result simulation
### DEBUG TASKS 1. The basic CPU diagnostic
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0b8ab172-bd7e-4199-b0c4-9303af498fd4" />

### DEBUG TASKS 2. The advanced CPU diagnotic
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/10eb72d2-9f01-4639-84bb-3d91471bc7f9" />

### DEBUG TASKS 3. The Fibonacci program
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a8ce23ad-7be9-4653-942f-561c2fe80e61" />


