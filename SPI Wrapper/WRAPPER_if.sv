interface WRAPPER_if (clk);
  input clk;
  logic MOSI, SS_n, rst_n;
  logic MISO;
  logic [9:0] rx_data_din;
  logic       rx_valid;
  logic       tx_valid;
  logic [7:0] tx_data_dout;
endinterface
