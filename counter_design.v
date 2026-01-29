
module counter4_sync (
  input  logic       clk,
  input  logic       rst,     // synchronous active-high reset
  input  logic       en,      // count enable
  input  logic       up_dn,   // 1: up, 0: down
  output logic [3:0] q
);
  always_ff @(posedge clk) begin
    if (rst) begin
      q <= 4'd0;
    end else if (en) begin
      if (up_dn)
        q <= q + 4'd1;       
      else
        q <= q - 4'd1;       
    end
  end
endmodule





