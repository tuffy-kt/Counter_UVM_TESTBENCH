  class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(transaction, scoreboard) recv;

  logic [3:0] expected_q;
  bit have_ref;

  // Optional: local sample counter (helps correlate)
  int unsigned sb_sample_idx;

  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
    recv = new("recv", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    expected_q    = 4'd0;
    have_ref      = 0;
    sb_sample_idx = 0;
  endfunction

  virtual function void write(transaction t);

    // -------- Reset handling --------
    if (t.rst) begin
      expected_q = 4'd0;
      have_ref   = 1;
      sb_sample_idx = 0;
      `uvm_info("SCOREBOARD", "Reset observed -> expected_q=0", UVM_LOW)
      return;
    end

    // -------- First valid sample: lock and prime --------
    if (!have_ref) begin
      have_ref   = 1;
      expected_q = t.q; // expected for THIS cycle
      `uvm_info("SCOREBOARD",
        $sformatf("Init: idx=%0d Q=%0d EN=%0b UP_DN=%0b -> expected_q(this)=%0d",
                  sb_sample_idx, t.q, t.en, t.up_dn, expected_q),
        UVM_LOW)

      // PRIMING for NEXT cycle so we’re not behind on the next sample
      if (t.en) begin
        logic [3:0] old = expected_q;
        expected_q = t.up_dn ? (expected_q + 1) : (expected_q - 1);
        `uvm_info("SCOREBOARD",
          $sformatf("Init prime: old=%0d new=%0d (EN=%0b UP_DN=%0b)",
                    old, expected_q, t.en, t.up_dn),
          UVM_LOW)
      end
      sb_sample_idx++;
      return;
    end

    // -------- NORMAL: Compare first (THIS cycle) --------
    `uvm_info("SCOREBOARD",
      $sformatf("Pre-compare: idx=%0d expected_q(this)=%0d; seen EN=%0b UP_DN=%0b Q=%0d",
                sb_sample_idx, expected_q, t.en, t.up_dn, t.q),
      UVM_MEDIUM)

    if (t.q !== expected_q) begin
      `uvm_error("SCOREBOARD",
        $sformatf("Mismatch: EXP=%0d OBS=%0d EN=%0b UP_DN=%0b",
                  expected_q, t.q, t.en, t.up_dn))
    end else begin
      `uvm_info("SCOREBOARD",
        $sformatf("PASS: Q=%0d EN=%0b UP_DN=%0b", t.q, t.en, t.up_dn),
        UVM_LOW)
    end

    // -------- Then update expected for NEXT cycle --------
    if (t.en) begin
      logic [3:0] old = expected_q;
      expected_q = t.up_dn ? (expected_q + 4'd1) : (expected_q - 4'd1);
      `uvm_info("SCOREBOARD",
        $sformatf("Post-update for next: old=%0d new=%0d (EN=%0b UP_DN=%0b)",
                  old, expected_q, t.en, t.up_dn),
        UVM_MEDIUM)
    end else begin
      `uvm_info("SCOREBOARD",
        $sformatf("Hold expected for next: %0d (EN=0)",
                  expected_q),
        UVM_MEDIUM)
    end

    sb_sample_idx++;

  endfunction
endclass
