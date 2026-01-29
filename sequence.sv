class generator_with_up extends uvm_sequence#(transaction);
	`uvm_object_utils(generator_with_up)
	
	transaction t;
	
	function new(input string name = "generator_with_up");
		super.new(name);
	endfunction 
	
virtual task body();
	t = transaction::type_id::create("t");
	repeat(10)
	begin 
	start_item(t);
    t.randomize();
	finish_item(t);
	`uvm_info("GEN Keeping UP",$sformatf("EN =%0d UP_DN =%0d Q_OUT =%0d",t.en,t.up_dn,t.q),UVM_NONE);
	end
endtask 
endclass

