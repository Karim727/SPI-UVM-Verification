import SPI_shared_pkg::*;
module SPI_sva(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

property bypass; 
    @(posedge clk) disable iff (rst)  (bypass_A || bypass_B) |-> ##2 
        (out == $past({ {3{A[2]}}, A },2) || out == $past({ {3{B[2]}}, B },2));
endproperty
property op_zero;
  @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)
    (opcode == 0) |-> ##2  
      ( out == $past((|A),2) || out == $past((|B),2) || out == $past((A | B),2) );
endproperty
property op_one;
  @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)
    (opcode == 1) |-> ##2  
      ( out == $past((^A),2) || out == $past((^B),2) || out == $past((A ^ B),2) );
endproperty
property op_two; 
    @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)  (opcode == 2 && FULL_ADDER=="ON") |-> ##2 
        (out == $past(A,2)+$past(B,2)+$past(cin_signed,2));
endproperty
property op_three; 
    @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)  (opcode == 3) |-> ##2 
        (out == $past((A * B),2));
endproperty
property op_four;
    @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)  (opcode == 4) |-> ##2  
      ( out == {$past(out[4:0]),$past(serial_in,2)} || out == {$past(serial_in,2), $past(out[5:1])} ) ;
endproperty
property op_five;
    @(posedge clk) disable iff (rst || invalid || bypass_A || bypass_B)  (opcode == 5) |-> ##2  
      ( out == $past({out[4:0], out[5]},1) || out == $past({out[0], out[5:1]},1) );
endproperty
property op_invalid;
    @(posedge clk) disable iff (rst || bypass_A || bypass_B)  (opcode == 6 || opcode == 7) |-> ##2 
          (out == 0 && leds == $past(~leds));
endproperty
ap_1:assert property (bypass);
cp_1:cover property (bypass);
ap_2:assert property (op_zero);
cp_2:cover property (op_zero);
ap_3:assert property (op_one);
cp_3:cover property (op_one);
ap_4:assert property (op_two);
cp_4:cover property (op_two);
always_comb begin
    if(~rst_n)
    a_reset: assert final(~MISO && ~rx_valid && rx_data);
end
ap_5:assert property (op_three);
cp_5:cover property (op_three);
ap_6:assert property (op_four);
cp_6:cover property (op_four);
ap_7:assert property (op_five);
cp_7:cover property (op_five);
ap_8:assert property (op_invalid);
cp_8:cover property (op_invalid);
endmodule