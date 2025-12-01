import typedefs::*;

module control (
    input  opcode_t opcode,
    input  logic    zero,
    input  logic    clk,
    input  logic    rst_,
    output logic    load_ac,
    output logic    mem_rd,
    output logic    mem_wr,
    output logic    inc_pc,
    output logic    load_pc,
    output logic    load_ir,
    output logic    halt
);

  timeunit 1ns;
  timeprecision 100ps;

  state_t state;
  logic   aluop;

  // ALU operation detect
  assign aluop = (opcode inside {ADD, AND, XOR, LDA});

  // FSM state register
  always_ff @(posedge clk or negedge rst_) begin
    if (!rst_)
      state <= INST_ADDR;
    else
      state <= state.next();
  end

  // Output decode
  always_comb begin
    // default outputs
    {mem_rd, load_ir, halt, inc_pc, load_ac, load_pc, mem_wr} = '0;

    unique case (state)
      INST_ADDR: ; // giữ tất cả 0

      INST_FETCH: begin
        mem_rd = 1;
      end

      INST_LOAD: begin
        mem_rd  = 1;
        load_ir = 1;
      end

      IDLE: begin
        mem_rd  = 1;
        load_ir = 1;
      end

      OP_ADDR: begin
        inc_pc = 1;
        halt   = (opcode == HLT);
      end

      OP_FETCH: begin
        mem_rd = aluop;
      end

      ALU_OP: begin
        load_ac = aluop;
        mem_rd  = aluop;
        inc_pc  = ((opcode == SKZ) && zero);
        load_pc = (opcode == JMP);
      end

      STORE: begin
        load_ac = aluop;
        mem_rd  = aluop;
        inc_pc  = (opcode == JMP);
        load_pc = (opcode == JMP);
        mem_wr  = (opcode == STO);
      end

      default: begin
        // synopsys translate_off
        $warning("control: illegal state %0d at time %0t", state, $time);
        // synopsys translate_on
      end

    endcase
  end

endmodule
