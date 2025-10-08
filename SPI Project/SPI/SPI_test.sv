package SPI_test_pkg;
import SPI_env_pkg::*;
import uvm_pkg::*;
import SPI_pkg_obj::*;
import SPI_main_seq_pkg::*;
import SPI_reset_seq_pkg::*;
`include "uvm_macros.svh"
class SPI_test extends uvm_test;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(SPI_test)
  SPI_env env;
  SPI_config_obj SPI_cfg;
  virtual SPI_if SPI_vif;
  SPI_main_seq main_seq;
  SPI_reset_seq reset_seq;
  function new(string name = "SPI_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = SPI_env::type_id::create("env",this);
            SPI_cfg = SPI_config_obj::type_id::create("SPI_cfg",this);
            main_seq = SPI_main_seq::type_id::create("main_seq",this);
            reset_seq = SPI_reset_seq::type_id::create("reset_seq",this);
            if(!uvm_config_db #(virtual SPI_if)::get(this,"","SPI_IF",SPI_cfg.SPI_vif))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            uvm_config_db #(SPI_config_obj)::set(this,"*","CFG",SPI_cfg);
  endfunction
  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  //reset sequence
  `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
  reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)
  //main sequence
  `uvm_info("run_phase", "Stimulus Generation Started", UVM_LOW)
  main_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "Stimulus Generation Ended", UVM_LOW)
  phase.drop_objection(this);
endtask
endclass: SPI_test
endpackage