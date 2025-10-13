import WRAPPER_shared_pkg::*;
module WRAPPER_sva(MOSI,MISO,SS_n,clk,rst_n);
input MOSI, SS_n, clk, rst_n, MISO;
input [9:0] rx_data_din;
input       rx_valid;
input       tx_valid;
input [7:0] tx_data_dout;

property reset_wrapper_p;
  @(posedge clk) !rst_n |=> (MISO == 0);
endproperty
property stable_wrapper_MISO;
  @(posedge clk) disable iff(!rst_n) (rx_data_din[9:8] != 2'b11) |=> (MISO throughout (rx_data_din[9:8] == 2'b11));
endproperty



reset_wrapper_asrt: assert property(reset_wrapper_p);
reset_wrapper_cov: cover property(reset_wrapper_p);

stable_wrapper_MISO_asrt: assert property(stable_wrapper_MISO);
stable_wrapper_MISO_cov: cover property(stable_wrapper_MISO);


endmodule
