package WRAPPER_driver_pkg;
    import uvm_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    `include "uvm_macros.svh"
    class WRAPPER_driver extends uvm_driver #(WRAPPER_seq_item);
        `uvm_component_utils(WRAPPER_driver)
        virtual WRAPPER_if WRAPPER_vif;
        WRAPPER_seq_item stim_seq_item;
        function new(string name = "WRAPPER_driver",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                stim_seq_item = WRAPPER_seq_item::type_id::create("stim_seq_item");
                seq_item_port.get_next_item(stim_seq_item);
                WRAPPER_vif.din=stim_seq_item.din;
                WRAPPER_vif.rst_n=stim_seq_item.rst_n;
                WRAPPER_vif.rx_valid=stim_seq_item.rx_valid;
                @(negedge WRAPPER_vif.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH) 
            end
        endtask
    endclass
endpackage
