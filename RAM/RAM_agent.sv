package RAM_pkg_agent;
  import uvm_pkg::*;
  import RAM_sequencer_pkg::*;
  import RAM_driver_pkg::*;
  import RAM_pkg_mon::*;
  import RAM_pkg_obj::*;
  import RAM_seq_item_pkg::*;
  `include "uvm_macros.svh"
  class RAM_agent extends uvm_agent;
    `uvm_component_utils(RAM_agent)
    RAM_sequencer sqr;
    RAM_driver drv;
    RAM_mon mon;
    RAM_config_obj RAM_cfg;
    uvm_analysis_port #(RAM_seq_item) agt_ap;
    function new(string name = "RAM_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(RAM_config_obj)::get(this, "", "CFG_ram", RAM_cfg)) begin
        `uvm_fatal("bulid_phase", "unable to get congiguration object")
      end
      if (RAM_cfg.is_active == UVM_ACTIVE) begin

        sqr = RAM_sequencer::type_id::create("sqr", this);
        drv = RAM_driver::type_id::create("drv", this);
      end
      mon = RAM_mon::type_id::create("mon", this);
      agt_ap = new("agt_ap", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (RAM_cfg.is_active == UVM_ACTIVE) begin

        drv.RAM_vif = RAM_cfg.RAM_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
      end
      mon.mon_ap.connect(agt_ap);
      mon.RAM_vif = RAM_cfg.RAM_vif;

    endfunction
  endclass
endpackage
