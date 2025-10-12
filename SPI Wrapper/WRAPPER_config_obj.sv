package WRAPPER_pkg_obj;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class WRAPPER_config_obj extends uvm_object;
        `uvm_object_utils(WRAPPER_config_obj)
        virtual WRAPPER_if WRAPPER_vif;
        uvm_active_passive_enum is_active;

        function new(string name = "WRAPPER_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage