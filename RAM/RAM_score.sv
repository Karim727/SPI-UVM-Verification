package RAM_pkg_score;
    import uvm_pkg::*;
    import RAM_seq_item_pkg::*;
    import RAM_shared_pkg::*;
    `include "uvm_macros.svh"
    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)
        uvm_analysis_export #(RAM_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
        RAM_seq_item seq_item_sb;
      
        int error_count=0;
        int correct_count=0;
        
        bit [7:0] MEM [255:0];
        logic [7:0] dout_ref;
        logic tx_valid_ref;
        bit [7:0] Rd_Addr, Wr_Addr;
        
        uvm_analysis_port #(RAM_seq_item) agt_ap;
        function new(string name = "RAM_scoreboard",uvm_component parent = null);
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
            //MEM = '{256{8'b0}};
            forever begin

                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);

                if(dout_ref != seq_item_sb.dout || tx_valid_ref != seq_item_sb.tx_valid) begin
                    `uvm_error("run_phase",$sformatf("Comparison failed, transactions recieved by the DUT:%s while the 
                    dout_ref = %0b, tx_valid_ref = %0b",seq_item_sb.convert2string_stimulus(),dout_ref,tx_valid_ref));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct output:%s",seq_item_sb.convert2string_stimulus()),UVM_HIGH);
                    correct_count++;
                end
            end
        endtask
        task ref_model(RAM_seq_item seq_item_chk);
            if (~seq_item_chk.rst_n) begin
                dout_ref = 0;
                Rd_Addr = 0;
                Wr_Addr = 0;
            end
            else                                           
                if (seq_item_chk.rx_valid) begin
                    case (seq_item_chk.din[9:8])
                        2'b00 : Wr_Addr = seq_item_chk.din[7:0]; // wr address
                        2'b01 : MEM[Wr_Addr] = seq_item_chk.din[7:0]; // wr data
                        2'b10 : Rd_Addr = seq_item_chk.din[7:0]; // rd address 
                        2'b11 : dout_ref = MEM[Wr_Addr]; // rd data
                        default : dout_ref = 0;
                    endcase
                end
            tx_valid_ref = (seq_item_chk.din[9] && seq_item_chk.din[8] && seq_item_chk.rx_valid && seq_item_chk.rst_n)? 1'b1 : 1'b0;
        endtask
        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("Total successful transactions: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total failed transactions: %0d",error_count),UVM_MEDIUM);
        endfunction
    endclass
endpackage