`timescale 1ns/1ps

module sync_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 3; 

    reg clk, rst_n, w_en, r_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0]data_out;
    wire full, empty,overflow, underflow;

    sync_fifo #(DATA_WIDTH, ADDR_WIDTH) dut (
        .clk(clk), .rst_n(rst_n), .w_en(w_en), .r_en(r_en),
        .data_in(data_in), .data_out(data_out),
        .full(full), .empty(empty),
        .overflow(overflow), .underflow(underflow)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 100 MHz clock
    end
    
    // test stimulus
    integer i;

    initial begin
        $dumpfile("sync_fifo.vcd");
        $dumpvars(0, sync_fifo_tb);
        
        rst_n = 0;w_en = 0;r_en = 0;
        data_in = 0;
        
        #1;
        rst_n = 1; 
        #5;

        // TEST 1: write until full
        $display("\n** Write until full **");
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk); 
            data_in = i + 10; 
            w_en = 1;
        end
        @(negedge clk);
        w_en = 0; 

        // OVERFLOW
        @(negedge clk);
        data_in = 99;
        w_en = 1;
        @(negedge clk);
        w_en = 0;

        #50;

        // TEST 2: read until EMPTY
        $display("\n** Read until empty **");
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk); 
            r_en = 1;
        end
        @(negedge clk);
        r_en = 0; 

        // UNDERFLOW 
        @(negedge clk);
        r_en = 1;
        @(negedge clk);
        r_en = 0;

        #5;

        // TEST 3: Concurrent Read and Write
        $display("\n ** simultanneous Write and Read **");
        
        fork // Run write and read blocks in parallel
            // write block
            begin
                for (i = 0; i < 5; i = i + 1) begin
                    @(negedge clk);
                    data_in = i + 50;
                    w_en = 1;
                end
                @(negedge clk); 
                w_en = 0;
            end
            
            // read block
            begin
                #25; 
                for (i = 0; i < 5; i = i + 1) begin
                    @(negedge clk);
                    r_en = 1;
                end
                @(negedge clk); 
                r_en = 0;
            end
        join

        #10;
        $display("\n--- Simulation Complete ---");
        $finish;
    end
    
    // Monitors for Console Output (Fixed to use 'clk')
    always @(posedge clk) begin
        if (w_en) begin
            $display("[WRITE] Time=%0t | Data In: %0d | Full: %b | Overflow: %b", 
            $time, data_in, full, overflow);
        end
    end

    always @(posedge clk) begin
        if (r_en) begin
            $display("[READ]  Time=%0t | Data Out: %0d | Empty: %b | Underflow: %b", 
            $time, data_out, empty, underflow);
        end
    end

endmodule