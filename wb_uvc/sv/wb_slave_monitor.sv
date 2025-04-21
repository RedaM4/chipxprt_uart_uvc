class wb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(wb_slave_monitor)

  uvm_analysis_port #(n_cpu_transaction) mon_ap;
  virtual wb_if vif;
  n_cpu_transaction trans;
  function new(string name = "wb_slave_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans = n_cpu_transaction::type_id::create("trans");
    mon_ap = new("mon_ap", this);
    if (!uvm_config_db#(virtual wb_if)::get(this, "", "vif", vif))
      `uvm_error("SLAVE MONITOR", "Failed to get vif from config db");
  endfunction

  task run_phase(uvm_phase phase);
    fork
      monitor_reset();
      monitor_transactions();
    join
  endtask

  task monitor_reset();
    forever begin
      @(negedge vif.reset);
      `uvm_info("SLAVE MONITOR", "Reset detected", UVM_MEDIUM)
    end
  endtask

  task monitor_transactions();
    forever begin
      @(posedge vif.clock);


      if (vif.STB_O && vif.CYC_O) begin
        trans.address = vif.ADR_O;
        trans.M_STATE = vif.WE_O ? WRITE : READ;

        if (vif.WE_O) begin
          wait(vif.ACK_I);
          trans.data = vif.DAT_O;
          `uvm_info("SLAVE MONITOR", $sformatf("Observed WRITE on slave - Addr: 0x%0h, Data: 0x%0h", 
                                               trans.address, trans.data), UVM_HIGH)
        end
        else begin
          trans.data = vif.DAT_I;
          `uvm_info("SLAVE MONITOR", $sformatf("Observed READ on slave - Addr: 0x%0h, Data: 0x%0h", 
                                               trans.address, trans.data), UVM_HIGH)
        end

        mon_ap.write(trans);
      end
    end
  endtask
endclass