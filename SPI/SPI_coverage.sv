package SPI_pkg_cover;
    import uvm_pkg::*;
    import SPI_seq_item_pkg::*;
    import SPI_shared_pkg::*;
    `include "uvm_macros.svh"
    class SPI_coverage extends uvm_component;
        `uvm_component_utils(SPI_coverage)
        uvm_analysis_export #(SPI_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(SPI_seq_item) cov_fifo;
        SPI_seq_item seq_item_cov;
        covergroup cvr_grp;
            rx_data_cp: coverpoint seq_item_cov.rx_data[9:8];
            SS_n_cp: coverpoint seq_item_cov.SS_n {
                bins extended_transaction[] = (1 => 0[*23] => 1);
                bins full_transaction_normal[] = (1 => 0[*13] => 1);
            }
            MOSI_cp: coverpoint seq_item_cov.MOSI {
                bins write_addr = (0=>0=>0);
                bins write_data = (0=>0=>1);
                bins read_addr = (1=>1=>0);
                bins read_data = (1=>1=>1);
            }
            SS_n_MOSI: cross SS_n_cp, MOSI_cp {
                option.cross_auto_bin_max =0;
                bins write_addr_full = binsof(SS_n_cp.full_transaction_normal) && binsof(MOSI_cp.write_addr);
                bins write_data_full = binsof(SS_n_cp.full_transaction_normal) && binsof(MOSI_cp.write_data);
                bins read_addr_full = binsof(SS_n_cp.full_transaction_normal) && binsof(MOSI_cp.read_addr);
                bins read_data_extended = binsof(SS_n_cp.extended_transaction) && binsof(MOSI_cp.read_data);
            }
        endgroup
        function new(string name = "SPI_coverage",uvm_component parent = null);
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