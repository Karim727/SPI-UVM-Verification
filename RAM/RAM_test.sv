package RAM_test_pkg;
import RAM_env_pkg::*;
import uvm_pkg::*;
import RAM_pkg_obj::*;
import RAM_write_read_seq_pkg::*;
import RAM_write_only_seq_pkg::*;
import RAM_reset_seq_pkg::*;
import RAM_read_only_seq_pkg::*;
`include "uvm_macros.svh"
class RAM_test extends uvm_test;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(RAM_test)
  RAM_env env;
  RAM_config_obj RAM_cfg;
  virtual RAM_if RAM_vif;
  RAM_read_only_seq read_only_seq;
  RAM_write_only_seq write_only_seq;
  RAM_write_read_seq write_read_random_seq;
  RAM_reset_seq reset_seq;
  function new(string name = "RAM_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = RAM_env::type_id::create("env",this);
            RAM_cfg = RAM_config_obj::type_id::create("RAM_cfg",this);
            read_only_seq = RAM_read_only_seq::type_id::create("read_only_seq",this);
            write_only_seq = RAM_write_only_seq::type_id::create("write_only_seq",this);
            write_read_random_seq = RAM_write_read_seq::type_id::create("read_only_seq",this);
            reset_seq = RAM_reset_seq::type_id::create("reset_seq",this);
            if(!uvm_config_db #(virtual RAM_if)::get(this,"","RAM_IF",RAM_cfg.RAM_vif))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            uvm_config_db #(RAM_config_obj)::set(this,"*","CFG",RAM_cfg);
  endfunction
  task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  //reset sequence
  `uvm_info("run_phase", "Reset Asserted", UVM_LOW)
  reset_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "Reset Deasserted", UVM_LOW)

  //main sequences
  `uvm_info("run_phase", "write_only_seq Stimulus Generation Started", UVM_LOW)
  write_only_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "write_only_seq Stimulus Generation Ended", UVM_LOW)

  `uvm_info("run_phase", "read_only_seq Stimulus Generation Started", UVM_LOW)
  read_only_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "read_only_seq Stimulus Generation Ended", UVM_LOW)

  `uvm_info("run_phase", "write_read_random_seq Stimulus Generation Started", UVM_LOW)
  write_read_random_seq.start(env.agt.sqr);
  `uvm_info("run_phase", "write_read_random_seq Stimulus Generation Ended", UVM_LOW)

  phase.drop_objection(this);
endtask
endclass: RAM_test
endpackage