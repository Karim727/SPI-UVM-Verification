package WRAPPER_pkg_agent;
    import uvm_pkg::*;
    import WRAPPER_sequencer_pkg::*;
    import WRAPPER_driver_pkg::*;
    import WRAPPER_pkg_mon::*;
    import WRAPPER_pkg_obj::*;
    import WRAPPER_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class WRAPPER_agent extends uvm_agent;
        `uvm_component_utils(WRAPPER_agent)
        WRAPPER_sequencer sqr;
        WRAPPER_driver drv;
        WRAPPER_mon mon;
        WRAPPER_config_obj WRAPPER_cfg;
        uvm_analysis_port #(WRAPPER_seq_item) agt_ap;

        function new(string name = "WRAPPER_agent",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(WRAPPER_config_obj)::get(this,"","CFG_wrapper",WRAPPER_cfg))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            if(WRAPPER_cfg.is_active == UVM_ACTIVE) begin
                sqr = WRAPPER_sequencer::type_id::create("sqr",this);
                drv = WRAPPER_driver::type_id::create("drv",this);
            end
            mon = WRAPPER_mon::type_id::create("mon",this);
            agt_ap = new("agt_ap",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            if(ALSU_cfg.is_active == UVM_ACTIVE) begin

                drv.WRAPPER_vif = WRAPPER_cfg.WRAPPER_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            mon.mon_ap.connect(agt_ap);
            mon.WRAPPER_vif = WRAPPER_cfg.WRAPPER_vif;

        endfunction
    endclass
endpackage