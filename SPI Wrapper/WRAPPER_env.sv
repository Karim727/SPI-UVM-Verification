package WRAPPER_env_pkg;
import uvm_pkg::*;
import WRAPPER_pkg_agent::*;
import WRAPPER_pkg_score::*;
import WRAPPER_pkg_cover::*;
`include "uvm_macros.svh"

class WRAPPER_env extends uvm_env;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(WRAPPER_env)
  WRAPPER_agent agt;
  WRAPPER_scoreboard sb;
  WRAPPER_coverage cov;
  function new(string name = "WRAPPER_env",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  // Build the driver in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = WRAPPER_agent::type_id::create("agt",this);
    sb = WRAPPER_scoreboard::type_id::create("sb",this);
    cov = WRAPPER_coverage::type_id::create("cov",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.agt_ap.connect(sb.sb_export);
    agt.agt_ap.connect(cov.cov_export);
  endfunction
endclass
endpackage