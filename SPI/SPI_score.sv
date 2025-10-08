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
        logic [5:0] out_exp;
        logic [15:0] leds_exp;
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
                ref_model(seq_item_sb);
                if(seq_item_sb.out != out_exp || seq_item_sb.leds != leds_exp) begin
                    `uvm_error("run_phase", $sformatf("Comparison failed, transactions recieved by the DUT:%s while the 
                    refrence out:%0b",seq_item_sb.convert2string(),out_exp,leds_exp));
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct output:%s",seq_item_sb.convert2string()),UVM_HIGH);
                    correct_count++;
                end
            end
        endtask
        task ref_model(SPI_seq_item seq_item_chk);
            bit invalid_red_op = (seq_item_chk.red_op_A | seq_item_chk.red_op_B) & (seq_item_chk.opcode[1] | seq_item_chk.opcode[2]);
            bit invalid_opcode = seq_item_chk.opcode[1] & seq_item_chk.opcode[2];
            bit invalid = invalid_red_op | invalid_opcode;
            if(seq_item_chk.rst) begin
                leds_exp = 0;
            end else begin
                if (invalid)
                    leds_exp = ~leds_exp;
                else
                    leds_exp = 0;
            end
            if(seq_item_chk.rst) begin
                out_exp = 0;
            end
            else begin
                if (seq_item_chk.bypass_A && seq_item_chk.bypass_B)
                    out_exp = (INPUT_PRIORITY == "A")? seq_item_chk.A: seq_item_chk.B;
                else if (seq_item_chk.bypass_A)
                    out_exp = seq_item_chk.A;
                else if (seq_item_chk.bypass_B)
                    out_exp = seq_item_chk.B;
                else if (invalid) 
                    out_exp = 0;
                else begin
                    case (seq_item_chk.opcode)//
                        OR: begin 
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
                            out_exp = (INPUT_PRIORITY == "A")? |seq_item_chk.A: |seq_item_chk.B;
                        else if (seq_item_chk.red_op_A) 
                            out_exp = |seq_item_chk.A;
                        else if (seq_item_chk.red_op_B)
                            out_exp = |seq_item_chk.B;
                        else 
                            out_exp = seq_item_chk.A | seq_item_chk.B;
                        end
                        XOR: begin
                        if (seq_item_chk.red_op_A && seq_item_chk.red_op_B)
                            out_exp = (INPUT_PRIORITY == "A")? ^seq_item_chk.A: ^seq_item_chk.B;
                        else if (seq_item_chk.red_op_A) 
                            out_exp = ^seq_item_chk.A;
                        else if (seq_item_chk.red_op_B)
                            out_exp = ^seq_item_chk.B;
                        else 
                            out_exp = seq_item_chk.A ^ seq_item_chk.B;
                        end
                        ADD: begin //
                        if(FULL_ADDER=="ON")
                            out_exp = seq_item_chk.A + seq_item_chk.B+ seq_item_chk.cin;
                        else
                            out_exp = seq_item_chk.A + seq_item_chk.B;
                        end //
                        MULT: out_exp = seq_item_chk.A * seq_item_chk.B;
                        SHIFT: begin
                        if (seq_item_chk.direction)
                            out_exp = {out_exp[4:0], seq_item_chk.serial_in};
                        else
                            out_exp = {seq_item_chk.serial_in, out_exp[5:1]};
                        end
                        ROTATE: begin
                        if (seq_item_chk.direction)
                            out_exp = {out_exp[4:0], out_exp[5]};
                        else
                            out_exp = {out_exp[0], out_exp[5:1]};
                        end
                    endcase
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