class transaction extends uvm_sequence_item;
	bit rst;
	rand bit en;
	rand bit up_dn;
	bit [3:0] q;
	
	function new(input string name ="transaction");
		super.new(name);
	endfunction 
	
  constraint c_mode_dist{
    up_dn dist{0:=50,1:=50};}

`uvm_object_utils_begin(transaction)
		`uvm_field_int(en,UVM_DEFAULT);
		`uvm_field_int(up_dn,UVM_DEFAULT);
		`uvm_field_int(q,UVM_DEFAULT);	
`uvm_object_utils_end

endclass
