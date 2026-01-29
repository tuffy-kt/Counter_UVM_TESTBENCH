module tb;
	count_if cif();
	
	initial begin 
		cif.clk = 0;
		cif.rst = 0;
	end 
	
	
	always #10 cif.clk = ~cif.clk;
	
  counter4_sync DUT(.clk(cif.clk),.rst(cif.rst),.en(cif.en),.up_dn(cif.up_dn),.q(cif.q));
 
 initial begin 
	$dumpfile("dump.vcd");
	$dumpvars;
end

initial begin 
  uvm_config_db#(virtual count_if)::set(null,"*","cif",cif);
run_test("test");

end
endmodule 
		