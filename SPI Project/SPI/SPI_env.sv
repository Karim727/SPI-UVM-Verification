package SPI_env_pkg;
import uvm_pkg::*;
import SPI_pkg_agent::*;
import SPI_pkg_score::*;
import SPI_pkg_cover::*;
`include "uvm_macros.svh"

class SPI_env extends uvm_env;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(SPI_env)
  SPI_agent agt;
  SPI_scoreboard sb;
  SPI_coverage cov;
  function new(string name = "SPI_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  // Build the driver in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = SPI_agent::type_id::create("agt",this);
    sb = SPI_scoreboard::type_id::create("sb",this);
    cov = SPI_coverage::type_id::create("cov",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cov.cov_export);
  endfunction
endclass
endpackage