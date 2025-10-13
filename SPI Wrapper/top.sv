import uvm_pkg::*;
`include "uvm_macros.svh"
// import RAM_test_pkg::*;
// import SPI_test_pkg::*;
import WRAPPER_test_pkg::*;
import SPI_shared_pkg::*;

module top ();
  bit clk;
  initial begin
    $readmemb("../RAM/mem.dat", DUT.RAM_instance.MEM);
    $readmemb("../RAM/mem.dat", golden_model_ram.mem);
  end
  initial begin
    forever #5 clk = ~clk;
  end


  /////////
  // RAM //
  /////////
  RAM_if RAMif (clk);
  RAM_golden golden_model_ram (
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
  /////////
  // SPI //
  /////////

  SPI_if SPIif (clk);
  SPI golden_model_spi (
      SPIif.MOSI,
      SPIif.SS_n,
      SPIif.clk,
      SPIif.rst_n,
      SPIif.tx_data,
      SPIif.tx_valid,
      SPIif.MISO_exp,
      SPIif.rx_data_exp,
      SPIif.rx_valid_exp
  );
  assign SPIif.cs = cs;

        /////////////
        // Wrapper //
        /////////////
  WRAPPER_if WRAPPERif(clk);
  WRAPPER DUT (
      .MOSI(WRAPPERif.MOSI),
      .MISO(WRAPPERif.MISO),
      .SS_n(WRAPPERif.SS_n),
      .clk(clk),
      .rst_n(WRAPPERif.rst_n)
  );

    /////////////////////////////
    // Interface connections //
    /////////////////////////////
    assign RAMif.din = DUT.rx_data_din;
    assign RAMif.rx_valid = DUT.rx_valid;
    assign RAMif.rst_n = DUT.rst_n;
    assign RAMif.tx_valid = DUT.tx_valid;
    assign RAMif.dout = DUT.tx_data_dout;

    assign SPIif.MOSI = DUT.MOSI;
    assign SPIif.MISO = DUT.MISO;
    assign SPIif.rst_n = DUT.rst_n;
    assign SPIif.SS_n = DUT.SS_n;

    assign WRAPPERif.rx_data_din = DUT.rx_data_din;
    assign WRAPPERif.rx_valid = DUT.rx_valid;
    assign WRAPPERif.tx_valid = DUT.tx_valid;
    assign WRAPPERif.tx_data_dout = DUT.tx_data_dout;


  initial begin
    uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_IF", RAMif);
    uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_IF", SPIif);
    uvm_config_db#(virtual WRAPPER_if)::set(null, "uvm_test_top", "WRAPPER_IF", WRAPPERif);
    run_test("WRAPPER_test");
  end
endmodule


//   RAM DUT (
//       .din(RAMif.din),
//       .clk(clk),
//       .rst_n(RAMif.rst_n),
//       .rx_valid(RAMif.rx_valid),
//       .dout(RAMif.dout),
//       .tx_valid(RAMif.tx_valid)
//   );

//   SLAVE DUT (
//       SPIif.MOSI,
//       SPIif.MISO,
//       SPIif.SS_n,
//       SPIif.clk,
//       SPIif.rst_n,
//       SPIif.rx_data,
//       SPIif.rx_valid,
//       SPIif.tx_data,
//       SPIif.tx_valid
//   );