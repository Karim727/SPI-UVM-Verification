module SPI(MOSI,SS_n,clk,rst_n,tx_data,tx_valid,MISO,rx_data,rx_valid);
parameter IDLE=3'b000,CHK_CMD=3'b001,WRITE=3'b010,READ_ADD=3'b011,READ_DATA=3'b100;
input MOSI,SS_n,clk,rst_n,tx_valid;
input [7:0] tx_data;
output reg MISO,rx_valid;
output reg [9:0] rx_data;

reg [9:0] MOSI_reg;
reg [2:0]cs,ns;
reg [3:0] count;
reg flag=1;

always @(posedge clk) begin
    if(~rst_n) 
        cs<=IDLE;
    else
        cs<=ns;
end
always @(posedge clk) begin
    if(~rst_n) begin
        rx_data<=0;
        rx_valid<=0;
        MISO<=0;
        MOSI_reg <=0;
    end
    else begin
        if(cs==IDLE)
            rx_valid<=0;
        if(cs==CHK_CMD)
            count<=10;
        if(cs==WRITE || cs==READ_ADD) begin
            if (count > 0) begin
                    MOSI_reg[count-1] <= MOSI;
                    count <= count - 1;
                end
                else begin
                    rx_data <= MOSI_reg;
                    rx_valid <= 1;
                    if(cs==READ_ADD) flag <=0;
                end
        end
        else if(cs==READ_DATA) begin
            if (tx_valid) begin
                    rx_valid <= 0;
                    if (count > 0) begin
                        MISO <= tx_data[count-1];
                        count <= count - 1;
                    end
                    else begin
                        flag <= 1;
                    end
                end
                else begin
                    if (count > 0) begin
                        MOSI_reg[count-1] <= MOSI;
                        count <= count - 1;
                    end
                    else begin
                        rx_data <= MOSI_reg;
                        rx_valid <= 1;
                        count <= 8;
                    end
                end
        end            
    end
end
always @(cs,SS_n,MOSI,flag) begin
    case (cs)
        IDLE:
        if(SS_n)
            ns=IDLE;
        else
            ns=CHK_CMD;
        CHK_CMD:
        if(SS_n)
            ns=IDLE;
        else begin
            if(~MOSI)
                ns=WRITE;
            else if(MOSI) begin
                if(flag) begin
                    ns=READ_ADD;
                end
                else begin
                    ns=READ_DATA;
                end
            end
        end
        WRITE:
        if(SS_n)
            ns=IDLE;
        else
            ns=WRITE;
        READ_ADD:
        if(SS_n)
            ns=IDLE;
        else
            ns=READ_ADD;
        READ_DATA:
        if(SS_n)
            ns=IDLE;
        else
            ns=READ_DATA;            
        default: ns=IDLE;
    endcase
end
endmodule