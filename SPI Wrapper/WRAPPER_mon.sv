package WRAPPER_pkg_mon;
    import uvm_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    import WRAPPER_shared_pkg::*;
    `include "uvm_macros.svh"
    class WRAPPER_mon extends uvm_monitor;
        `uvm_component_utils(WRAPPER_mon)
        virtual WRAPPER_if WRAPPER_vif;
        WRAPPER_seq_item rsp_seq_item;
        uvm_analysis_port #(WRAPPER_seq_item) mon_ap;
        function new(string name = "WRAPPER_mon",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap=new("mon_ap",this);
        endfunction
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                rsp_seq_item = WRAPPER_seq_item::type_id::create("rsp_seq_item");
                    @(negedge WRAPPER_vif.clk);
                    rsp_seq_item.MOSI=WRAPPER_vif.MOSI;
                    rsp_seq_item.rst_n=WRAPPER_vif.rst_n;
                    rsp_seq_item.MISO=WRAPPER_vif.MISO;
                    rsp_seq_item.SS_n=WRAPPER_vif.SS_n;
                    // rsp_seq_item.tx_valid_ref=WRAPPER_vif.tx_valid_ref;
                    // rsp_seq_item.dout_ref=WRAPPER_vif.dout_ref;
                mon_ap.write(rsp_seq_item);
                `uvm_info("run_phase",rsp_seq_item.convert2string_stimulus(),UVM_HIGH) 
            end
        endtask
    endclass
endpackage