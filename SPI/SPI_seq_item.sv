package SPI_seq_item_pkg;
import SPI_shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_seq_item extends uvm_sequence_item;
  `uvm_object_utils(SPI_seq_item)
  rand logic rst_n, SS_n, tx_valid;
  logic MOSI;
  rand logic [10:0] MOSI_bits;
  rand logic [7:0] tx_data;
  logic [9:0] rx_data;
  logic rx_valid,MISO;
  //logic [2:0] cs;
  
  function new(string name = "SPI_seq_item");
    super.new(name);
  endfunction
  function string convert2string();
    return $sformatf("%s rst_n=%b SS_n=%b tx_valid=%b tx_data=%b MOSI=%b rx_data=%b rx_valid=%b MISO=%b",
    super.convert2string(),rst_n,SS_n,tx_valid,tx_data,MOSI,rx_data,rx_valid,MISO);
  endfunction
  function string convert2string_stimulus();
    return $sformatf("%s rst_n=%b SS_n=%b tx_valid=%b tx_data=%b MOSI=%b",
    super.convert2string(),rst_n,SS_n,tx_valid,tx_data,MOSI);
  endfunction
  constraint reset {
    rst_n      dist {1:/98,0:/2};
  }
  /*constraint tx__valid {
    (cs == READ_DATA) -> (tx_valid == 1);
  }*/
  /*constraint valid_code_c {
    (SS_n == 0) -> MOSI_bits[10:8] inside {3'b000, 3'b001, 3'b110, 3'b111};
  }*/
  function void post_randomize();
    bit [2:0] valid_codes [4] = '{3'b000, 3'b001, 3'b110, 3'b111};
    //SS_n = 0;
    $display("MOSI_bits=%b at time=%t",MOSI_bits,$time);
    if (MOSI_bits[10:8] == 3'b111) begin
      cycles_before_SS_high = 23;
      tx_valid = 1;
    end
    else begin
      tx_valid = 0;
      cycles_before_SS_high = 13;
    end
    // Ensure first 3 bits of MOSI_bits are valid codes
    if(~SS_n)
      MOSI_bits[10:8] = valid_codes[$urandom_range(0,3)];
  endfunction
endclass: SPI_seq_item
endpackage

  // SS_n high every 13 or 23 cycles depending on read/write
  /*if (cs == READ_DATA) begin
    tx_valid = 1;
    //if(rx_valid)
      //SS_n = 1; // once every 23 cycles
  end*/
  /*else begin
    if(rx_valid)
      SS_n = 1; // once every 13 cycles
  end*/