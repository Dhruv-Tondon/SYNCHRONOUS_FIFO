module fifo_mem #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 3)(
    input  wire clk,w_en,
    input  wire [ADDR_WIDTH-1:0] waddr,raddr,
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [DATA_WIDTH-1:0] data_out 
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) if (w_en) mem[waddr] <= data_in;
    assign data_out = mem[raddr];

endmodule