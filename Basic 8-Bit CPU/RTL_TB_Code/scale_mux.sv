/* scale_mux.sv - Simple scalable MUX 
 * Simple scalable MUX using an always_comb + unique case construct
 * Behavior:
   - in_a, in_b and out are all logic vectors
   - The MUX width is parameterized with a default value of 1
   - If sel_a is 1'b1, input in_a is passed to the output
   - If sel_a is 1'b0, input in_b is passed to the output
 */

module scale_mux #(parameter int WIDTH = 1) 
(
  input  logic [WIDTH-1:0] in_a, 
  input  logic [WIDTH-1:0] in_b,
  input  logic             sel_a,
  output logic [WIDTH-1:0] out
);
  
  timeunit 1ns;
  timeprecision 100ps;

  always_comb 
    unique case (sel_a)
      1'b1: out = in_a;
      1'b0: out = in_b;
      default: out = 'x; // defensive coding
    endcase
  
endmodule : scale_mux
