package SPI_main_seq_pkg;
import SPI_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_main_seq extends uvm_sequence #(SPI_seq_item);
  `uvm_object_utils(SPI_main_seq);
  SPI_seq_item seq_item;
  function new(string name = "SPI_main_seq");
    super.new(name);
  endfunction
  task body;
    seq_item = SPI_seq_item::type_id::create("seq_item");
    repeat(1000) begin
      start_item(seq_item);
      assert(seq_item.randomize() with rst_n == 1)
      finish_item(seq_item);
    end
  endtask
endclass: SPI_main_seq
endpackage