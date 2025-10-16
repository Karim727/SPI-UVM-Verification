package WRAPPER_pkg_score;
    import uvm_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    import WRAPPER_shared_pkg::*;
    `include "uvm_macros.svh"
    class WRAPPER_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(WRAPPER_scoreboard)
        uvm_analysis_export #(WRAPPER_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(WRAPPER_seq_item) sb_fifo;
        WRAPPER_seq_item seq_item_sb;
      
        int error_count=0;
        int correct_count=0;
        
        bit [7:0] MEM [255:0];
        // logic [7:0] dout_ref;
        // logic tx_valid_ref;
        bit [7:0] Rd_Addr, Wr_Addr;
        
        uvm_analysis_port #(WRAPPER_seq_item) agt_ap;
        function new(string name = "WRAPPER_scoreboard",uvm_component parent = null);
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
                //ref_model(seq_item_sb);
                if(seq_item_sb.MISO_ref != seq_item_sb.MISO) begin
                    `uvm_error("run_phase",$sformatf("Comparison failed, transactions recieved by the DUT:%s while the 
                    MISO_ref = %0b",seq_item_sb.convert2string_stimulus(),seq_item_sb.MISO_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct output:%s",seq_item_sb.convert2string_stimulus()),UVM_HIGH);
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