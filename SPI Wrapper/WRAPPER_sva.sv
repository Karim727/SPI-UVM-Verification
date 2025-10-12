import WRAPPER_shared_pkg::*;
module WRAPPER_sva(din,clk,rst_n,rx_valid,dout,tx_valid);
input [9:0] din;
input clk, rst_n, rx_valid;
input [7:0] dout;
input tx_valid;


property reset_p;
  @(posedge clk) !rst_n |=> (tx_valid == 0 && dout == 0);
endproperty
property tx_low_p;
  @(posedge clk) disable iff(!rst_n) (din[9:8] != 2'b11) |=> (tx_valid == 0);
endproperty
property tx_rise_fall_p;
  @(posedge clk) disable iff(!rst_n) (din[9:8] == 2'b11)  |=> ($fell(tx_valid)[->1]); // NOT SURE??
endproperty

property wraddr_wrdata_p;
  @(posedge clk) disable iff(!rst_n) (din[9:8] == 2'b00)  |=> ((din[9:8] == 2'b01)[->1]);
endproperty

property rdaddr_rddata_p;
  @(posedge clk) disable iff(!rst_n) (din[9:8] == 2'b10)  |=> ((din[9:8] == 2'b11)[->1]);
endproperty


reset_asrt: assert property(reset_p);
reset_cov: cover property(reset_p);

tx_low_asrt: assert property(tx_low_p);
tx_low_cov: cover property(tx_low_p);

tx_rise_fall_asrt: assert property(tx_rise_fall_p);
tx_rise_fall_cove: cover property(tx_rise_fall_p);

wraddr_wrdata_asrt: assert property(wraddr_wrdata_p);
wraddr_wrdata_cov: cover property(wraddr_wrdata_p);

rdaddr_rddata_asrt: assert property(rdaddr_rddata_p);
rdaddr_rddata_cov: cover property(rdaddr_rddata_p);

endmodule