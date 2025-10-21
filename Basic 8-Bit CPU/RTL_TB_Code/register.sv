/* register.sv — 8-bit load-enable register
 * Behavior:
   - rst_ is asynchronous and active low
   - The register is clocked on the rising edge of clk.
   - If enable is high, the input data is passed to the output out.
   - Otherwise, the current value of out is retained in the register.
 */

module register (
  input  wire       clk,
  input  wire       rst_,
  input  wire       enable,
  input  wire [7:0] data, 
  output reg  [7:0] out
);
  
  timeunit 1ns; 
  timeprecision 100ps;

  always_ff @(posedge clk or negedge rst_) begin
    if (!rst_)       out <= '0; 
    else if (enable) out <= data; 
    else             out <= out;  
  end
endmodule : register
