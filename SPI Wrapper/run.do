vlib work
vlog -f src_files.list +cover -covercells +define+SIM
#vlog -f src_files.list +cover -covercells 


vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

run 0

add wave -position insertpoint  \
sim:/top/WRAPPERif/clk \
sim:/top/WRAPPERif/MOSI \
sim:/top/WRAPPERif/SS_n \
sim:/top/WRAPPERif/rst_n \
sim:/top/WRAPPERif/MISO \
sim:/top/WRAPPERif/rx_data_din \
sim:/top/WRAPPERif/rx_valid \
sim:/top/WRAPPERif/tx_valid \
sim:/top/WRAPPERif/tx_data_dout

add wave -position insertpoint  \
sim:/top/DUT/RAM_instance/din \
sim:/top/DUT/RAM_instance/rst_n \
sim:/top/DUT/RAM_instance/rx_valid \
sim:/top/DUT/RAM_instance/dout \
sim:/top/DUT/RAM_instance/tx_valid \
sim:/top/DUT/RAM_instance/MEM \
sim:/top/DUT/RAM_instance/Rd_Addr \
sim:/top/DUT/RAM_instance/Wr_Addr

add wave -position insertpoint  \
sim:/top/DUT/SLAVE_instance/MOSI \
sim:/top/DUT/SLAVE_instance/rst_n \
sim:/top/DUT/SLAVE_instance/SS_n \
sim:/top/DUT/SLAVE_instance/tx_valid \
sim:/top/DUT/SLAVE_instance/tx_data \
sim:/top/DUT/SLAVE_instance/rx_data \
sim:/top/DUT/SLAVE_instance/rx_valid \
sim:/top/DUT/SLAVE_instance/MISO \
sim:/top/DUT/SLAVE_instance/counter \
sim:/top/DUT/SLAVE_instance/received_address \
sim:/top/DUT/SLAVE_instance/MOSI_reg \
sim:/top/DUT/SLAVE_instance/ns

add wave -position insertpoint  \
sim:/top/SPIif/cs

add wave -position insertpoint  \
sim:/WRAPPER_shared_pkg::count_ss_n

coverage save top.ucdb -onexit
run -all