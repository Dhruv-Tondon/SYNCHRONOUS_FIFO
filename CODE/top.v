module sync_fifo #(parameter DATA_WIDTH = 8,parameter ADDR_WIDTH = 3)(
    input  wire clk, rst_n, w_en, r_en,
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire full, empty,overflow ,underflow
);

    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire mem_w_en, mem_r_en; 
    
    fifo_ctrl #(.ADDR_WIDTH(ADDR_WIDTH)) ctrl_inst (
        .clk(clk), .rst_n(rst_n),
        .r_en(r_en), .w_en(w_en),
        .full(full), .empty(empty),
        .underflow(underflow),.overflow(overflow),
        .waddr(waddr), .raddr(raddr),
        .mem_w_en(mem_w_en),.mem_r_en(mem_r_en) 
    );

    fifo_mem #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)
    ) mem_inst (
        .clk(clk), .w_en(mem_w_en),  
        .waddr(waddr), .raddr(raddr),
        .data_in(data_in), .data_out(data_out)
    );

endmodule