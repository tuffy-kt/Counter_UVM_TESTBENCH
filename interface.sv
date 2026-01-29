interface count_if();
logic clk;
logic rst;
logic en;
logic up_dn;
logic [3:0] q;
  
  
 clocking cb_mon @(posedge clk);
    default input #1step output #0; // <-- critical: sample one timestep after
    input rst, en, up_dn, q;
  endclocking

  
endinterface 