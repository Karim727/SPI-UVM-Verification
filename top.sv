import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;

module top();
  // Clock generation
  bit clk;
  initial begin
    forever
      #1 clk=~clk;
  end
  // Instantiate the interface and DUT
  SPI_if SPIif (clk);
  SPI DUT(SPIif.A,SPIif.B,SPIif.cin,SPIif.serial_in,SPIif.red_op_A,SPIif.red_op_B,SPIif.opcode,SPIif.bypass_A,SPIif.bypass_B,
  SPIif.clk,SPIif.rst,SPIif.direction,SPIif.leds,SPIif.out);
  //bind SPI SPI_sva sva_inst (SPIif.A,SPIif.B,SPIif.cin,SPIif.serial_in,SPIif.red_op_A,SPIif.red_op_B,SPIif.opcode,SPIif.bypass_A,SPIif.bypass_B,
  //SPIif.clk,SPIif.rst,SPIif.direction,SPIif.leds,SPIif.out);
  assign SPIif.cs = DUT.cs;
  initial begin
    uvm_config_db #(virtual SPI_if)::set(null,"uvm_test_top","SPI_IF",SPIif);//name
    run_test("SPI_test");
  end
endmodule