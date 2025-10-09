package RAM_write_only_seq_pkg;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_write_only_seq extends uvm_sequence #(RAM_seq_item);
  `uvm_object_utils(RAM_write_only_seq);
  RAM_seq_item seq_item;
  function new(string name = "RAM_main_seq");
    super.new(name);
  endfunction
  task body;
    seq_item = RAM_seq_item::type_id::create("seq_item");
    // start_item(seq_item);
    seq_item.constraint_mode(0);
    // assert(seq_item.randomize() with din == 2'b00 );
    // finish_item(seq_item);

    repeat(100) begin
        start_item(seq_item);
        seq_item.wr_only.constraint_mode(1);
        seq_item.reset.constraint_mode(1);
        seq_item.rx_valid_c.constraint_mode(1);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
  endtask
endclass
endpackage
