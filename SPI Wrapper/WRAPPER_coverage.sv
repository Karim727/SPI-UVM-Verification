package WRAPPER_pkg_cover;
    import uvm_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    import WRAPPER_shared_pkg::*;
    `include "uvm_macros.svh"
    class WRAPPER_coverage extends uvm_component;
        `uvm_component_utils(WRAPPER_coverage)
        uvm_analysis_export #(WRAPPER_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(WRAPPER_seq_item) cov_fifo;
        WRAPPER_seq_item seq_item_cov;
        covergroup cvr_grp;
            
            // din_cp: coverpoint seq_item_cov.din[9:8]{
            //     bins din_values[] = {[0:3]};
            //     bins wrdata_after_wraddress = (2'b00=>2'b01);
            //     bins rddata_after_rdaddress = (2'b10=>2'b11);
            //     bins wradd_wrdata_rdadd_rddata = (2'b00=>2'b01=>2'b10=>2'b11);
            // }
            // rx_cp: coverpoint seq_item_cov.rx_valid;
            // tx_cp: coverpoint seq_item_cov.tx_valid;

            // // din_cross_rx: cross din_cp, rx_cp iff (seq_item_cov.rx_valid == 1) {
            // //     option.cross_auto_bin_max = 0;
            // // }

            // din_cross_rx: cross din_cp, rx_cp{
            //     option.cross_auto_bin_max = 0;
            //     bins din_values_rx_high = binsof(din_cp.din_values) && binsof(rx_cp) intersect{1};
                
            // }


            // din_cross_tx: cross din_cp, tx_cp {
            //     option.cross_auto_bin_max = 0;
            //     bins rd_data_tx_high = binsof(din_cp.din_values) intersect{3} && binsof(tx_cp) intersect{1};
            // }
        endgroup

        function new(string name = "WRAPPER_coverage",uvm_component parent = null);
            super.new(name,parent);
            cvr_grp=new();
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                cvr_grp.sample();
            end
        endtask
    endclass
endpackage

