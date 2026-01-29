class test extends uvm_test;
	`uvm_component_utils(test)
	env e;
	
	generator_with_up gen_up;

	function new(input string name = "test",uvm_component c);
		super.new(name,c);
	endfunction 
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		e = env::type_id::create("e",this);
		gen_up = generator_with_up::type_id::create("gen_up");
      
      //type override 
    uvm_factory::get().set_inst_override_by_type(
      driver::get_type(),
      driver_name::get_type(),
      "uvm_test_top.e.a.d"
    );

	endfunction
	
	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		gen_up.start(e.a.seqr);
		#100;
		phase.drop_objection(this);
	endtask 
	
endclass