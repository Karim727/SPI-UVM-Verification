package RAM_write_read_seq_pkg;
import RAM_shared_pkg::*;
import RAM_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_write_read_seq extends uvm_sequence #(RAM_seq_item);
  `uvm_object_utils(RAM_write_read_seq);
  RAM_seq_item seq_item;
  function new(string name = "RAM_reset_seq");
    super.new(name);
  endfunction
  task body;
    seq_item = RAM_seq_item::type_id::create("seq_item");
    repeat(100) begin
        start_item(seq_item);
        seq_item.wr_only.constraint_mode(0);
        seq_item.rd_only.constraint_mode(0);
        assert(seq_item.randomize());
        finish_item(seq_item);
    end
  endtask
endclass
endpackage