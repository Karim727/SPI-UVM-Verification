vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
run 0
add wave /top/SPIif/*
add wave /top/DUT/ap_4
add wave /top/DUT/ap_5
add wave /top/DUT/ap_6
add wave -position insertpoint  \
sim:/SPI_shared_pkg::cycles_before_SS_high
coverage save top.ucdb -onexit
run -all