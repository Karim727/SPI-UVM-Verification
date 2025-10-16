package WRAPPER_seq_item_pkg;
import WRAPPER_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class WRAPPER_seq_item extends uvm_sequence_item;
  `uvm_object_utils(WRAPPER_seq_item)
  bit [9:0] din_saved = 10'b1111111111;
  int count = 0;
  logic MOSI;
  rand logic rst_n;
  logic MISO;
  logic SS_n;
  rand logic[10:0] din;

  function new(string name = "WRAPPER_seq_item");
    super.new(name);
  endfunction
  function string convert2string();
    return $sformatf("%s", super.convert2string());
  endfunction
  function string convert2string_stimulus();
    return $sformatf("MISO = %b, MOSI = %b, rst_n = %b, SS_n = %b",
    MISO, MOSI, rst_n, SS_n);
  endfunction
  constraint reset {
    rst_n      dist {1:/99,0:/1};
  }

  constraint rd_only{
    if(count == 0){
    if(din_saved[9:8] == 2'b10)
    din[10:8] == 3'b111;
    else
    din[10:8] == 3'b110;
    }
  }

  constraint wr_only{
    if(count == 0){
    if(din_saved [9:8]== 2'b00)
    din[10:8] inside {3'b000, 3'b001};
    else 
    din[10:8] == 3'b000;
    }
  }

  constraint wr_rd_random {
    if(count == 0){
    if (din_saved[9:8] == 2'b00) {
      din[10:8] inside {3'b000, 3'b001};
    } else if (din_saved[9:8] == 2'b01) {
      din[10:8] dist {3'b110 := 60, 3'b000 := 40};
    } else if (din_saved[9:8] == 2'b10) {
      din[10:8] == 3'b111;
    } else if (din_saved[9:8] == 2'b11) {
      din[10:8] dist {3'b110 := 40, 3'b000 := 60};
    } else {
      din[10:8] == 3'b000;
    } 
    }
}


  function void post_randomize(); // Happens after randomization
    if(~rst_n) begin
      count =0;
      count_ss_n =0;
    end
    if(count_ss_n == 0)din_saved = din[9:0];

        count++;
    count_ss_n++;

    if(count<11) begin
      MOSI = din_saved[10-count];
    end
    else if(count==14)begin
      count = 0;
      //SS_n = 0;
    end

    if(din_saved[9:8] != 2'b11 && count_ss_n == 14)// Counted from 0->12 (13 cycles)
      count_ss_n = 0;
    else if(din_saved[9:8] == 2'b11 && count_ss_n == 24)// 23 cycles
      count_ss_n = 0;

    // if(count_ss_n == 1) begin
    //   SS_n = 0;
    // end
    // else begin
    //   SS_n = 1;
    // end
  if(count_ss_n == 0) begin
      SS_n = 1;
    end
    else begin
      SS_n = 0;
    end

    $display("DIN = %b, din_saved = %b, count = %d, count_ss_n = %d, SS_n = %b time = %t", din, din_saved, count, count_ss_n, SS_n,$time);

  endfunction
  function void pre_randomize();
    //$display("Before Randomization: din_saved = %d",din_saved);

  endfunction


endclass: WRAPPER_seq_item
endpackage







  // constraint rd_only{
    // if(din1[9:8] == 2'b10)
    // din[9:8] inside {2'b10, 2'b11};
    // else
    // din[9:8] == 2'b10;
    // if(din2[9:8] == 2'b10 && count == 0)
    //   MOSI == 1;
    // else if(din2[9:8] == 2'b10 && count == 1)
    //   MOSI inside {1'b0, 1'b1};
    // else if(din2 == 5)
    //   MOSI == 1;

  // }

  // constraint wr_rd_random {
  //   if (din2[9:8] == 2'b00 && count == 0) {
  //     din[9:8] inside {2'b00, 2'b01};
  //   } else if (din_saved == 2'b01) {
  //     din[9:8] dist {2'b10 := 60, 2'b00 := 40};
  //   } else if (din_saved == 2'b10) {
  //     din[9:8] inside {2'b10, 2'b11};
  //   } else if (din_saved == 2'b11) {
  //     din[9:8] dist {2'b10 := 40, 2'b00 := 60};
  //   } else {
  //     din[9:8] == 2'b00;
  // }
// }



//   constraint wr_only{
//     if(din_saved == 2'b00)
//     din[9:8] inside {2'b00, 2'b01};
//     else 
//     din[9:8] == 2'b00;
//   }

