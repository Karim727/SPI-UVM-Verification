package WRAPPER_test_pkg;
import WRAPPER_env_pkg::*;
import WRAPPER_pkg_obj::*;
import WRAPPER_write_read_seq_pkg::*;
import WRAPPER_write_only_seq_pkg::*;
import WRAPPER_reset_seq_pkg::*;
import WRAPPER_read_only_seq_pkg::*;
import RAM_env_pkg::*;
import RAM_pkg_obj::*;
import SPI_env_pkg::*;
import SPI_pkg_obj::*;


import uvm_pkg::*;
`include "uvm_macros.svh"
class WRAPPER_test extends uvm_test;
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(WRAPPER_test)
  WRAPPER_env env;
  SPI_env env_spi;
  RAM_env env_ram;

  WRAPPER_config_obj WRAPPER_cfg;
  RAM_config_obj RAM_cfg;
  SPI_config_obj SPI_cfg;

  virtual WRAPPER_if WRAPPER_vif;
  virtual RAM_if RAM_vif;
  virtual SPI_if SPI_vif;


  WRAPPER_read_only_seq read_only_seq;
  WRAPPER_write_only_seq write_only_seq;
  WRAPPER_write_read_seq write_read_random_seq;
  WRAPPER_reset_seq reset_seq;
  function new(string name = "WRAPPER_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = WRAPPER_env::type_id::create("env",this);
            env_ram = RAM_env::type_id::create("env_ram",this);
            env_spi = SPI_env::type_id::create("env_spi",this);

            WRAPPER_cfg = WRAPPER_config_obj::type_id::create("WRAPPER_cfg",this);
            RAM_cfg = RAM_config_obj::type_id::create("RAM_cfg",this);
            SPI_cfg = SPI_config_obj::type_id::create("SPI_cfg",this);

            SPI_cfg.is_active = UVM_PASSIVE;
            RAM_cfg.is_active = UVM_PASSIVE;
            WRAPPER_cfg.is_active = UVM_ACTIVE;

            read_only_seq = WRAPPER_read_only_seq::type_id::create("read_only_seq",this);
            write_only_seq = WRAPPER_write_only_seq::type_id::create("write_only_seq",this);
            write_read_random_seq = WRAPPER_write_read_seq::type_id::create("read_only_seq",this);
            reset_seq = WRAPPER_reset_seq::type_id::create("reset_seq",this);


            if(!uvm_config_db #(virtual WRAPPER_if)::get(this,"","WRAPPER_IF",WRAPPER_cfg.WRAPPER_vif))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            uvm_config_db #(WRAPPER_config_obj)::set(this,"*","CFG_wrapper",WRAPPER_cfg);

            if(!uvm_config_db #(virtual RAM_if)::get(this,"","RAM_IF",RAM_cfg.WRAPPER_vif))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            uvm_config_db #(RAM_config_obj)::set(this,"*","CFG_ram",RAM_cfg);

            if(!uvm_config_db #(virtual SPI_if)::get(this,"","SPI_IF",SPI_cfg.WRAPPER_vif))begin
                `uvm_fatal("bulid_phase","unable to get congiguration object")
            end
            uvm_config_db #(SPI_config_obj)::set(this,"*","CFG_spi",SPI_cfg);

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
endclass: WRAPPER_test
endpackage