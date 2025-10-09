package RAM_env_pkg;
import uvm_pkg::*;
import RAM_pkg_agent::*;
import RAM_pkg_score::*;
import RAM_pkg_cover::*;
`include "uvm_macros.svh"

class RAM_env extends uvm_env;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(RAM_env)
  RAM_agent agt;
  RAM_scoreboard sb;
  RAM_coverage cov;
  function new(string name = "RAM_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  // Build the driver in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = RAM_agent::type_id::create("agt",this);
    sb = RAM_scoreboard::type_id::create("sb",this);
    cov = RAM_coverage::type_id::create("cov",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cov.cov_export);
  endfunction
endclass
endpackage