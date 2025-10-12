import SPI_shared_pkg::*;
module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

/*localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;*/

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;
reg [9:0] MOSI_reg;
reg [2:0]  ns; //cs,

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else if(MOSI) begin ////else only is wrong if mosi is x
                    if (~received_address)// 
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MOSI_reg <= 0;
        MISO <= 0;
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0;
            end
            CHK_CMD : begin
                counter <= 10;      
            end
            WRITE : begin
                if (counter > 0) begin
                    MOSI_reg[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_data <= MOSI_reg;
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    MOSI_reg[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_data <= MOSI_reg;
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                    end
                end
                else begin
                    if (counter > 0) begin
                        MOSI_reg[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_data <= MOSI_reg;
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end
property reset_check; 
    @(posedge clk) disable iff (rst_n)  (~rst_n) |-> ##1 
        (~MISO && ~rx_valid && rx_data == 10'd0);
endproperty
/*always_comb begin
    if(~rst_n)
    a_reset: assert final(~MISO && ~rx_valid && rx_data == 10'd0);
end*/
property valid_command; 
    @(posedge clk) disable iff (~rst_n)  (cs == CHK_CMD ##1 ~MISO[*3]) |-> ##10 
        (rx_valid && $rose(SS_n) [->1]);///eventually
endproperty
property valid_transition_1; 
    @(posedge clk) disable iff (~rst_n)  (cs == IDLE && ~SS_n) |-> ##1 
        (cs == CHK_CMD);
endproperty
property valid_transition_2; 
    @(posedge clk) disable iff (~rst_n)  (cs == CHK_CMD && ~SS_n) |-> ##1 
        (cs == WRITE || cs == READ_ADD || cs == READ_DATA);
endproperty
//
property valid_transition_3; 
    @(posedge clk) disable iff (~rst_n)  (cs == WRITE && ~SS_n) |-> ##[1:22] 
        (cs == IDLE);
endproperty
property valid_transition_4; 
    @(posedge clk) disable iff (~rst_n)  (cs == READ_ADD && ~SS_n) |-> ##[1:22] 
        (cs == IDLE);
endproperty
property valid_transition_5; 
    @(posedge clk) disable iff (~rst_n)  (cs == READ_DATA && ~SS_n) |-> ##[1:22] 
        (cs == IDLE);
endproperty
//
a_reset:assert property (reset_check);
ap_1:assert property (valid_command);
cp_1:cover property (valid_command);
ap_2:assert property (valid_transition_1);
cp_2:cover property (valid_transition_1);
ap_3:assert property (valid_transition_2);
cp_3:cover property (valid_transition_2);
ap_4:assert property (valid_transition_3);
cp_4:cover property (valid_transition_3);
ap_5:assert property (valid_transition_4);
cp_5:cover property (valid_transition_4);
ap_6:assert property (valid_transition_5);
cp_6:cover property (valid_transition_5);
endmodule