import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;

module top();
  // Clock generation
  bit clk;
  initial begin
    $readmemb("mem.dat",DUT.MEM);
    $readmemb("mem.dat",golden_model.mem);
  end
  initial begin
    forever
      #5 clk=~clk;
  end
  // Instantiate the interface and DUT
  RAM_if RAMif (clk);
  RAM DUT(.din(RAMif.din),
          .clk(clk),
          .rst_n(RAMif.rst_n),
          .rx_valid(RAMif.rx_valid),
          .dout(RAMif.dout),
          .tx_valid(RAMif.tx_valid)
  );

  RAM_golden golden_model(
          .din(RAMif.din),
          .clk(clk),
          .rst_n(RAMif.rst_n),
          .rx_valid(RAMif.rx_valid),
          .dout(RAMif.dout_ref),
          .tx_valid(RAMif.tx_valid_ref)
  );

  bind RAM RAM_sva sva_inst (
          .din(RAMif.din),
          .clk(clk),
          .rst_n(RAMif.rst_n),
          .rx_valid(RAMif.rx_valid),
          .dout(RAMif.dout),
          .tx_valid(RAMif.tx_valid)
  );
  //RAMif.clk,RAMif.rst,RAMif.direction,RAMif.leds,RAMif.out);
  //assign RAMif.cs = DUT.cs;
  initial begin
    uvm_config_db #(virtual RAM_if)::set(null,"uvm_test_top","RAM_IF",RAMif);//name
    run_test("RAM_test");
  end
endmodule