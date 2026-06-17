`timescale 1ns / 1ps

module memory_tb();

    reg clk;
    reg [15:0] t_in;
    reg t_load;
    reg [2:0] ram8_addr;
    wire [15:0] ram8_out;

    reg [5:0] ram64_addr;
    wire [15:0] ram64_out;

    reg pc_load;
    reg pc_inc;
    reg pc_reset;
    wire [15:0] pc_out;

    RAM8 uut_ram8 (
        .clk(clk), .in(t_in), .load(t_load), .address(ram8_addr), .out(ram8_out)
    );

    RAM64 uut_ram64 (
        .clk(clk), .in(t_in), .load(t_load), .address(ram64_addr), .out(ram64_out)
    );

    PC uut_pc (
        .clk(clk), .in(t_in), .load(pc_load), .inc(pc_inc), .reset(pc_reset), .out(pc_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        t_in = 16'b0; t_load = 0; ram8_addr = 3'b0; ram64_addr = 6'b0;
        pc_load = 0; pc_inc = 0; pc_reset = 0;
        #12;

        $display("--- RAM8 TEST ---");
        t_in = 16'hAAAA; ram8_addr = 3'd2; t_load = 1; @(posedge clk); #1;
        t_in = 16'h5555; ram8_addr = 3'd5; t_load = 1; @(posedge clk); #1;
        t_load = 0;
        
        ram8_addr = 3'd2; #1;
        $display("RAM8 Addr 2 = %h", ram8_out);
        ram8_addr = 3'd5; #1;
        $display("RAM8 Addr 5 = %h", ram8_out);

        $display("--- RAM64 TEST ---");
        t_in = 16'hBCDE; ram64_addr = 6'd42; t_load = 1; @(posedge clk); #1;
        t_load = 0;
        
        ram64_addr = 6'd42; #1;
        $display("RAM64 Addr 42 = %h", ram64_out);

        $display("--- PC TEST ---");
        pc_reset = 1; @(posedge clk); #1;
        pc_reset = 0;
        $display("PC Reset = %h", pc_out);

        pc_inc = 1; @(posedge clk); #1;
        $display("PC Inc 1 = %h", pc_out);
        @(posedge clk); #1;
        $display("PC Inc 2 = %h", pc_out);
        pc_inc = 0;

        t_in = 16'h7FFF; pc_load = 1; @(posedge clk); #1;
        pc_load = 0;
        $display("PC Load  = %h", pc_out);

        pc_inc = 1; @(posedge clk); #1;
        $display("PC Inc   = %h", pc_out);
        pc_inc = 0;

        $finish;
    end

endmodule