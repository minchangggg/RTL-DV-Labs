# Architecture Overview
<img width="856" height="866" alt="image" src="https://github.com/user-attachments/assets/c4fc3f01-5db1-4b36-a92b-3a9e48f72703" />

- This is a tiny 8-bit, accumulator-based CPU with a single unified memory for **instructions + data**.
- The datapath is deliberately simple: `ACC ↔ ALU ↔ Memory`, with a 2-phase **Fetch/Execute** control FSM.

## Key blocks
* **Memory**: 8-bit wide, addressed by a 5-bit bus (32 bytes). Read/Write via `mem_rd`, `mem_wr`.
* **Program Counter (PC)**: 5-bit. `inc_pc` increments; `load_pc` loads a new address (branch/jump).
* **Address MUX**: selects address source to Memory
  `fetch=1 → pc_addr` (fetch instruction)
  `fetch=0 → ir_addr` (use operand/address field during execute)
* **Instruction Register (IR)**: latches the fetched byte.
  Encoding: `IR[7:5] = opcode (3b)`, `IR[4:0] = operand/address (5b)`.
* **ACC (Accumulator)**: 8-bit working register; loads from Memory or from ALU result.
* **ALU**: performs arithmetic/logic on `ACC` and a second operand (typically `Memory.data_out`).
  Exposes result and the **Z (zero) flag**.
* **Controller (FSM)**: decodes `opcode` + `Z` to drive control signals:
  `mem_rd, mem_wr, load_ir, load_ac, load_pc, inc_pc, fetch, halt`.

## Clocking & reset
* Synchronous clock for all regs (`PC`, `IR`, `ACC`, controller state).
* Active-low reset `rst_` clears state (PC=0, ACC=0, `fetch=1`).

---

## Instruction Encoding
| Opcode (IR[7:5]) | Mnemonic | Operand     | Effect (high level)         | Micro-ops (execute phase)      |
| ---------------- | -------- | ----------- | --------------------------- | ------------------------------ |
| `000`            | **LDA**  | `addr[4:0]` | `ACC ← MEM[addr]`           | `fetch=0; mem_rd=1; load_ac=1` |
| `001`            | **STA**  | `addr[4:0]` | `MEM[addr] ← ACC`           | `fetch=0; mem_wr=1`            |
| `010`            | **ADD**  | `addr[4:0]` | `ACC ← ACC + MEM[addr]`     | `mem_rd=1; ALU=ADD; load_ac=1` |
| `011`            | **SUB**  | `addr[4:0]` | `ACC ← ACC − MEM[addr]`     | `mem_rd=1; ALU=SUB; load_ac=1` |
| `100`            | **AND**  | `addr[4:0]` | `ACC ← ACC & MEM[addr]`     | `mem_rd=1; ALU=AND; load_ac=1` |
| `101`            | **OR**   | `addr[4:0]` | `ACC ← ACC \| MEM[addr]`    | `mem_rd=1; ALU=OR; load_ac=1`  |
| `110`            | **JMP**  | `addr[4:0]` | `PC ← addr` (unconditional) | `load_pc=1`                    |
| `111`            | **JZ**   | `addr[4:0]` | if `Z=1` then `PC ← addr`   | `if(Z) load_pc=1`              |

> **Optional:** reserve `111_11111` as **HALT** (set `halt=1`) if bạn muốn có lệnh dừng phần cứng; còn lại `111_xxxxx` là **JZ**.

---

## Execution Timing (2-phase)
1. **Fetch** (`fetch=1`):
   `mem_rd=1; addr ← PC; load_ir=1; inc_pc=1`.
2. **Execute** (`fetch=0`):
   control depends on `opcode` (see table). Z-flag updates on ALU writes to ACC.

---

## Control Signals (summary)
* `mem_rd`, `mem_wr` – memory transactions
* `load_ir`, `load_ac`, `load_pc`, `inc_pc` – register enables
* `fetch` – selects address source (PC vs IR[4:0])
* `halt` – optional stop output for simulation

---

## Minimal Program Examples
```asm
; Sum A += MEM[0x03]
LDA 0x02      ; ACC = MEM[2]
ADD 0x03      ; ACC = ACC + MEM[3]
STA 0x04      ; MEM[4] = ACC
JMP 0x1F      ; spin (or use HALT if enabled)
```

```asm
; Branch on zero
LDA 0x10
SUB 0x11
JZ  0x1A      ; if equal, jump to 0x1A
```

