package SPI_pkg_obj;
import uvm_pkg::*;
`include "uvm_macros.svh"
    class SPI_config_obj extends uvm_object;
        `uvm_object_utils(SPI_config_obj)
        virtual SPI_if SPI_vif;
        function new(string name = "SPI_config_obj");
            super.new(name);
        endfunction
    endclass
endpackage