package SPI_pkg_score;
    import uvm_pkg::*;
    import SPI_seq_item_pkg::*;
    import SPI_shared_pkg::*;
    `include "uvm_macros.svh"
    class SPI_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_scoreboard)
        uvm_analysis_export #(SPI_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(SPI_seq_item) sb_fifo;
        SPI_seq_item seq_item_sb;
        logic [9:0] rx_data_exp;
        logic rx_valid_exp,MISO_exp;
        int error_count=0;
        int correct_count =0;
        uvm_analysis_port #(SPI_seq_item) agt_ap;
        function new(string name = "SPI_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                /*SPI golden_model(seq_item_sb.MOSI,seq_item_sb.SS_n,seq_item_sb.rst_n,seq_item_sb.tx_data,seq_item_sb.tx_valid,
                MISO_exp,rx_data_exp,rx_valid_exp);*/
                if(seq_item_sb.rx_data != rx_data_exp || seq_item_sb.rx_valid != rx_valid_exp || seq_item_sb.MISO != MISO_exp) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transactions recieved by the DUT:%s while the 
                    refrence out:%0b",seq_item_sb.convert2string(),rx_data_exp,rx_valid_exp,MISO_exp));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct output:%s",seq_item_sb.convert2string()),UVM_HIGH);
                    correct_count++;
                end
            end
        endtask
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM);
        endfunction
    endclass
endpackage