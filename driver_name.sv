class driver_name extends uvm_driver#(transaction);
	`uvm_component_utils(driver)
	
  function new(input string name = "driver",uvm_component c);
	super.new(name,c);
endfunction 

transaction t;
virtual count_if cif;

//task reset 
task reset_dut();
	cif.rst <= 1;
	
	cif.en <=0;
	cif.up_dn <= 0;
	//cif.q <= 0;
	repeat(5)@(posedge cif.clk);
	cif.rst <= 0;
	`uvm_info("DRV","Reset Done ",UVM_NONE);
endtask 


//build phase 

virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	t = transaction::type_id::create("transaction");
	
  if(!uvm_config_db #(virtual count_if)::get(this,"","cif",cif))
	`uvm_error("DRV","Unable to get interace from uvm_config_db");
endfunction 


virtual task run_phase(uvm_phase phase);
		reset_dut();
		forever begin 
		seq_item_port.get_next_item(t);
		cif.en <= t.en;
		cif.up_dn <= t.up_dn;
		//cif.q <= t.q;
		seq_item_port.item_done();
	`uvm_info("DRV Collection",$sformatf("EN =%0d UP_DN =%0d ",t.en,t.up_dn),UVM_NONE);
	repeat(2)@(posedge cif.clk);
	end 
	endtask 
endclass	

