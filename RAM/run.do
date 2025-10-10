vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
run 0
add wave -position insertpoint  \
sim:/top/RAMif/clk \
sim:/top/RAMif/din \
sim:/top/RAMif/rst_n \
sim:/top/RAMif/rx_valid \
sim:/top/RAMif/dout \
sim:/top/RAMif/tx_valid



#add wave -position insertpoint  \
#sim:/top/DUT/Rd_Addr \
#sim:/top/DUT/Wr_Addr
#add wave -position insertpoint  \
#sim:/uvm_root/uvm_test_top/env/sb/Wr_Addr \
#sim:/uvm_root/uvm_test_top/env/sb/Rd_Addr

add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/tx_valid_ref \
sim:/uvm_root/uvm_test_top/env/sb/dout_ref

add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/env/sb/correct_count \
sim:/uvm_root/uvm_test_top/env/sb/error_count


add wave /top/DUT/sva_inst/reset_asrt

coverage save top.ucdb -onexit
run -all