package WRAPPER_write_only_seq_pkg;
import WRAPPER_seq_item_pkg::*;
import uvm_pkg::*;
import WRAPPER_shared_pkg::*;
`include "uvm_macros.svh"

class WRAPPER_write_only_seq extends uvm_sequence #(WRAPPER_seq_item);
  `uvm_object_utils(WRAPPER_write_only_seq);
  WRAPPER_seq_item seq_item;
  function new(string name = "WRAPPER_main_seq");
    super.new(name);
  endfunction
  task body;
    seq_item = WRAPPER_seq_item::type_id::create("seq_item");
    // start_item(seq_item);
    // assert(seq_item.randomize() with din == 2'b00 );
    // finish_item(seq_item);

    repeat(RUNS) begin
        start_item(seq_item);
        seq_item.constraint_mode(0);
        seq_item.wr_only.constraint_mode(1);
        seq_item.res et.constraint_mode(1);
        seq_item.rx_valid_c.constraint_mode(1);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
  endtask
endclass
endpackage
