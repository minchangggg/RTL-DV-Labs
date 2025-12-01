# Digital Stopwatch (Verilog)

## Overview
This project implements a **digital stopwatch** in Verilog HDL with a **7-segment LED display** and a clean, FSM-based control scheme.  

The design targets FPGA implementation but is also easy to simulate at RTL level.

## 1. Design Summary

- Control logic is implemented as a **5-state FSM**:
  - `IDLE`, `RUN`, `LAP`, `STOP`, `CLEAR`
- Supports intuitive user operations:
  - **Start / Stop / Lap / Clear** with smooth transitions between states
- Time is stored in **BCD format (hh:mm)** and automatically rolls over:
  - `23:59 → 00:00`
- **Lap mode**:
  - Freezes the displayed lap time while the main counter continues to run in the background
- **Clear mode**:
  - Resets all internal registers and returns the system to a fresh `00:00` state
- The 7-segment driver provides real-time visual feedback for both **current time** and **lap time**.

## 2. Project Structure
To simplify development and verification, the design is split into two main testbenches:

### Part 1 – `BCD_stopwatch_test` (RTL / Simulation)
- Contains the full **FSM** and **BCD counter** logic.
- Outputs are kept in **pure BCD** (no 7-segment decoding).
- Used mainly for:
  - Functional verification of state transitions
  - Checking BCD counting and rollover behavior in simulation (e.g., Vivado/ModelSim).

### Part 2 – `Led7Seg_stopwatch_test` (FPGA / Implementation)
- Builds on Part 1 and adds:
  - **7-segment decoder** and **multiplexing logic** for a 4-digit display.
- Keeps the **same FSM and BCD counter**, only extending the display path.
- Intended for FPGA synthesis (Quartus) and on-board testing:
  - Connects push-buttons/switches to control inputs (start/stop/lap/clear).
  - Drives a 4-digit 7-segment LED to show the stopwatch time.

