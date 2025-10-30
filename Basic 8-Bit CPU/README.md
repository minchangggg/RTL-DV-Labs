
# Introduction
<img width="856" height="866" alt="image" src="https://github.com/user-attachments/assets/c4fc3f01-5db1-4b36-a92b-3a9e48f72703" />

This project implements a tiny **8-bit accumulator CPU** with a **single unified memory** for instructions and data. The design is fully synchronous (active-low reset) and runs a simple **two-phase Fetch/Execute** sequence controlled by a finite-state machine.

## Datapath & flow
- The core consists of an **Accumulator (ACC)**, **ALU**, **Instruction Register (IR)**, **Program Counter (PC)**, an **address MUX**, and a **synchronous memory**.
  + **Fetch:** the **PC** drives the memory address; the instruction byte is latched into **IR** and the PC increments.
  + **Execute:** the controller decodes **IR[7:5]** (opcode) and uses **IR[4:0]** as the operand/address to drive micro-operations and, when needed, to select the memory address.

## Instruction set (3-bit opcode)
- `HLT` (halt), `SKZ` (skip next if **ACC==0** via Z flag), `ADD`, `AND`, `XOR` (operate on `ACC` with `MEM[addr]`), `LDA` (`ACC ← MEM[addr]`), `STO` (`MEM[addr] ← ACC`), `JMP` (`PC ← addr`).

## Modules
- Synthesizable building blocks: `mem.sv` (synchronous memory), `alu.sv` (ADD/AND/XOR + zero flag), `count.sv` (PC), `register.sv` (generic reg for ACC/IR), `scale_mux.sv` (address/data MUX), and a `control` FSM sequencing the states.
- Memory width/depth are parameterizable; sample programs are provided in `CPUtest*.dat`.


