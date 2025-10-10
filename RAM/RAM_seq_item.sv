package RAM_seq_item_pkg;
import RAM_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class RAM_seq_item extends uvm_sequence_item;
  `uvm_object_utils(RAM_seq_item)
  int din_saved = 5;
  rand logic [9:0] din;
  rand logic rst_n, rx_valid;
  logic [7:0] dout;
  logic tx_valid;
  function new(string name = "RAM_seq_item");
    super.new(name);
  endfunction
  function string convert2string();
    return $sformatf("%s", super.convert2string());
  endfunction
  function string convert2string_stimulus();
    return $sformatf("din = %b, rst_n = %b, rx_valid = %b, dout = %b, tx_valid = %b",
    din, rst_n, rx_valid, dout, tx_valid);
  endfunction
  constraint reset {
    rst_n      dist {1:/97,0:/3};
  }
  constraint rx_valid_c {
    rx_valid  dist{1:/70,0:/30};
  }

  constraint rd_only{
    if(din_saved == 2'b10)
    din[9:8] inside {2'b10, 2'b11};
    else 
    din[9:8] == 2'b10;
  }

  constraint wr_only{
    if(din_saved == 2'b00)
    din[9:8] inside {2'b00, 2'b01};
    else 
    din[9:8] == 2'b00;
  }

  constraint wr_rd_random {
    if (din_saved == 2'b00) {
      din[9:8] inside {2'b00, 2'b01};
    } else if (din_saved == 2'b01) {
      din[9:8] dist {2'b10 := 60, 2'b00 := 40};
    } else if (din_saved == 2'b10) {
      din[9:8] inside {2'b10, 2'b11};
    } else if (din_saved == 2'b11) {
      din[9:8] dist {2'b10 := 40, 2'b00 := 60};
    } else {
      din[9:8] == 2'b00;
  }
}
  function void post_randomize(); // Happens after randomization
    din_saved = din[9:8];
    //$display("DIN = %b, din_saved = %d", din[9:8], din_saved);
  endfunction
  function void pre_randomize();
    //$display("Before Randomization: din_saved = %d",din_saved);
  endfunction


endclass: RAM_seq_item
endpackage



