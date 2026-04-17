module fifo_ctrl #(parameter ADDR_WIDTH = 3)(
    input wire clk, rst_n, r_en, w_en,
    output reg full, empty,
    output wire overflow ,underflow,
    output wire [ADDR_WIDTH-1:0] waddr, raddr,
    output wire mem_w_en, mem_r_en
);
    reg  [ADDR_WIDTH:0] wr_ptr;
    reg  [ADDR_WIDTH:0] rd_ptr;
    
    wire [ADDR_WIDTH:0] wr_ptr_next, rd_ptr_next;
    wire full_val, empty_val;

    assign mem_w_en = w_en & ~full;
    assign mem_r_en = r_en & ~empty;
    assign wr_ptr_next = wr_ptr + mem_w_en; 
    assign rd_ptr_next = rd_ptr + mem_r_en;

    assign overflow = w_en & full;
    assign underflow = r_en & empty;
    assign empty_val = (rd_ptr_next == wr_ptr_next);
    assign full_val = (wr_ptr_next[ADDR_WIDTH] != rd_ptr_next[ADDR_WIDTH]) &&
    (wr_ptr_next[ADDR_WIDTH-1:0] == rd_ptr_next[ADDR_WIDTH-1:0]);

    assign waddr =wr_ptr[ADDR_WIDTH-1:0];
    assign raddr=rd_ptr[ADDR_WIDTH-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            wr_ptr <= 0;
            empty<= 1; 
            full <= 0;
        end else begin
            rd_ptr <= rd_ptr_next;
            wr_ptr <= wr_ptr_next;
            empty <= empty_val;
            full<= full_val;
        end
    end
endmodule