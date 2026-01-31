class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	
	uvm_analysis_port#(transaction)send;
	
	function new(input string inst = "monitor",uvm_component c);
		super.new(inst,c);
		send = new("send",this);
	endfunction 
		
	//transaction t;
virtual count_if cif;
transaction tr;
virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//t = transaction::type_id::create("t");
  if(!uvm_config_db #(virtual count_if)::get(this,"","cif",cif))
	`uvm_error("MON","Unable to get interace from uvm_config_db");
		endfunction 
		
	

virtual task run_phase(uvm_phase phase);
    // Wait for reset deassertion at a sampling point
    do @(cif.cb_mon); while (cif.cb_mon.rst);

    forever begin
      @(cif.cb_mon); // every clock, post-NBA
       tr = transaction::type_id::create("tr");
      tr.rst   = cif.cb_mon.rst;
      tr.en    = cif.cb_mon.en;
      tr.up_dn = cif.cb_mon.up_dn;
      tr.q     = cif.cb_mon.q;

      `uvm_info("MON Collection",
        $sformatf("EN =%0d UP_DN =%0d Q_OUT =%0d",
                  tr.en, tr.up_dn, tr.q), UVM_NONE);

      send.write(tr);
    end
  endtask



endclass
