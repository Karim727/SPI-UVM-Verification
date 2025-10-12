import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;
import SPI_shared_pkg::*;
module top();
  // Clock generation
  bit clk;
  initial begin
    forever
      #5 clk=~clk;
  end
  // Instantiate the interface and DUT
  SPI_if SPIif (clk);
  SLAVE DUT(SPIif.MOSI,SPIif.MISO,SPIif.SS_n,SPIif.clk,SPIif.rst_n,SPIif.rx_data,SPIif.rx_valid,SPIif.tx_data,SPIif.tx_valid);
  SPI golden_model(SPIif.MOSI,SPIif.SS_n,SPIif.clk,SPIif.rst_n,SPIif.tx_data,SPIif.tx_valid,
  SPIif.MISO_exp,SPIif.rx_data_exp,SPIif.rx_valid_exp);
  assign SPIif.cs = cs;
  initial begin
    uvm_config_db #(virtual SPI_if)::set(null,"uvm_test_top","SPI_IF",SPIif);//name
    run_test("SPI_test");
  end
endmodule