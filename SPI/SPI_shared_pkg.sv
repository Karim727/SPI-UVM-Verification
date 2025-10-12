package SPI_shared_pkg;
    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;
    int cycles_before_SS_high;
    logic [2:0] cs;
endpackage