package WRAPPER_reset_seq_pkg;
import WRAPPER_shared_pkg::*;
import WRAPPER_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class WRAPPER_reset_seq extends uvm_sequence #(WRAPPER_seq_item);
  `uvm_object_utils(WRAPPER_reset_seq);
  WRAPPER_seq_item seq_item;
  function new(string name = "WRAPPER_reset_seq");
    super.new(name);
  endfunction

  task body;
    seq_item = WRAPPER_seq_item::type_id::create("seq_item");
    start_item(seq_item);
    seq_item.din = 0;
    seq_item.MOSI = 0;
    seq_item.rst_n = 0;
    finish_item(seq_item);
  endtask
endclass
endpackage