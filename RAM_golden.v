module RAM_golden(din,clk,rst_n,rx_valid,dout,tx_valid);
parameter MEM_DEPTH=256,ADDR_SIZE=8;
input clk,rst_n,rx_valid;
input [9:0] din;
output reg [7:0] dout;
output reg tx_valid;
reg [7:0] mem [255:0];
reg [7:0] addr_wr,addr_rd;
always @(posedge clk) begin
    if(~rst_n) begin
        dout<=0;
        tx_valid<=0;
        addr_wr<=0;
        addr_rd<=0;
    end
    else begin
        tx_valid<=0;
        if(rx_valid) begin
            if (din[9:8] == 2'b00) // write address
                addr_wr <= din[7:0];

            else if (din[9:8] == 2'b01) // write data
                mem[addr_wr] <= din[7:0];

            else if(din[9:8] == 2'b10) // read address
                addr_rd <= din[7:0];
            else if (din[9:8] == 2'b11) begin // read data
                dout <= mem[addr_rd];
                tx_valid <= 1;
            end
        end

    end
end
endmodule