# Basic 8-Bit CPU
This project implements a tiny 8-bit accumulator CPU with a single unified memory for instructions and data.

The design is fully synchronous (active-low reset) and runs a simple two-phase Fetch/Execute sequence controlled by a finite-state machine.

## 1. CPU Architecture
<img width="750" alt="image" src="https://github.com/user-attachments/assets/941ea950-3067-4ebb-96a6-167df06e5b08">

The CPU is a simple **8-bit accumulator machine** with a **single unified memory** for both instructions and data.

Main blocks:

- **Program Counter (`count.sv`)**  
  5-bit up-counter that provides the program address. Supports **load** and **increment** control signals.

- **Address MUX (`scale_mux.sv`)**  
  Selects between:
  
  + `PC` (for instruction fetch), or  
  + the **address field** of the current instruction (for operand access). 

- **Memory (`mem.sv`)**  
  Synchronous memory:
  
  + `mem_rd` / `mem_wr` control reads and writes,
  + `addr` selects the 5-bit location,
  + `data_out` feeds both **IR** and the ALU datapath. 

- **Instruction Register - IR (`register.sv`)**  
  8-bit register latching the fetched instruction byte:
  
  + `IR[7:5]` = opcode  
  + `IR[4:0]` = operand / address  

- **Accumulator - ACC (`register.sv`)**  
  8-bit ACC register holding the working value for ALU operations.

- **ALU (`alu.sv`)**  
  Operates on `ACC` and `MEM[addr]`, generating:
  
  + new `ACC` value
  + `zero` flag (1 when result == 0). 

- **Controller FSM (`control.sv`)**  
  8-state **Mealy** FSM that sequences Fetch/Execute micro-operations and generates:
  `mem_rd`, `mem_wr`, `load_ir`, `load_ac`, `load_pc`, `inc_pc`, `halt`. 

- **Top-level (`cpu.sv`)**  
  Instantiates and connects:
  
  + `mem`, `register` (ACC, IR), `counter` (PC),
  + `scale_mux` (address select),
  + `alu`, `control`, and the memory interface 

- **Testbench (`cpu_test.sv`)**  
  Loads one of the diagnostic programs (`CPUtest1.dat`, `CPUtest2.dat`, `CPUtest3.dat`) into memory.
  
    + **CPUtest1.dat – Basic Diagnostic Test**  
      > Exercises core instructions and halts at PC `0x17` if everything passes.
    + **CPUtest2.dat – Advanced Diagnostic Test**  
      > Covers more micro-operations; halts at PC `0x10` when correct.
    + **CPUtest3.dat – Fibonacci Calculator**  
      > Computes Fibonacci numbers from 0 to 144 and stores them in memory.
  
  Monitors the `halt` signal and prints debug information.
    
> Memory width/depth are parameterizable; sample programs are provided in `CPUtest*.dat`.

## 2. Datapath & flow
The core consists of an **Accumulator (ACC)**, **ALU**, **Instruction Register (IR)**, **Program Counter (PC)**, an **address MUX**, and a **synchronous memory**.

### Fetch phase
> The **PC** drives the memory address; the instruction byte is latched into **IR** and the PC increments.

1. `PC` → address MUX → memory address.
2. `mem_rd` asserted, instruction byte is fetched.
3. On clock edge, instruction is loaded into **IR** and `PC` increments.
  
### Execute phase
> The controller decodes **IR[7:5]** (opcode) and uses **IR[4:0]** as the operand/address to drive micro-operations and, when needed, to select the memory address.
  
1. Controller decodes `IR[7:5]` as opcode.
2. `IR[4:0]` is used as:
   - memory address (for LDA/ADD/AND/XOR/STO), or  
   - jump target (JMP).
3. ALU / ACC / PC / Memory are updated according to opcode and `zero` flag.
4. For `HLT`, controller raises `halt` and stops sequencing.

## 3. Instruction set (3-bit opcode)
3-bit opcode field `IR[7:5]`:

| Opcode | Mnemonic | Description                                      |
|--------|----------|--------------------------------------------------|
| `000`  | `HLT`    | Halt CPU                                        |
| `001`  | `SKZ`    | Skip next instruction if `ACC == 0` (using Z)   |
| `010`  | `ADD`    | `ACC ← ACC + MEM[addr]`                          |
| `011`  | `AND`    | `ACC ← ACC & MEM[addr]`                          |
| `100`  | `XOR`    | `ACC ← ACC ^ MEM[addr]`                          |
| `101`  | `LDA`    | `ACC ← MEM[addr]`                                |
| `110`  | `STO`    | `MEM[addr] ← ACC`                                |
| `111`  | `JMP`    | `PC  ← addr`                                     |

## 4. Test Programs & Simulation
This lab is simulated on **Linux** using a **Makefile + QuestaSim** flow.

### Test programs
The testbench `cpu_test.sv` can load one of three programs:

- `CPUtest1.dat` – **Basic diagnostic test**  
  Exercises core instructions and halts at `PC = 0x17` when correct.

- `CPUtest2.dat` – **Advanced diagnostic test**  
  Covers more micro-operations; halts at `PC = 0x10` when correct.

- `CPUtest3.dat` – **Fibonacci calculator**  
  Computes Fibonacci numbers from 0 to 144 and stores them in memory.

The selected program is controlled inside `cpu_test.sv`.  

### Simulation Screenshots
- _**CPUtest1 result – Basic CPU Diagnostic**_

  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0b8ab172-bd7e-4199-b0c4-9303af498fd4" />

- _**CPUtest2 result – Advanced CPU Diagnostic**_

  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/10eb72d2-9f01-4639-84bb-3d91471bc7f9" />

- _**CPUtest3 result – Fibonacci Program**_
  
  <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a8ce23ad-7be9-4653-942f-561c2fe80e61" />


