`timescale 1ns / 1ps

module bool_logic_tb();

    // gate and mux signals
    reg        t_a, t_b;
    wire       out_nand, out_not, out_and, out_or, out_xor;
    reg        t_mux16_a, t_mux16_b, t_mux16_sel;
    wire       out_mux16;
    
    // Mux & DMux Signals
    reg        t_mux_sel, t_dmux_sel, t_dmux_in;
    wire       out_mux, out_dmux_a, out_dmux_b;
    
    // 16-Bit Signals
    reg [15:0] t_in16, t_a16, t_b16;
    wire [15:0] out_not16, out_and16, out_or16;
    
    // Or8Way Signals
    reg [7:0]  t_or8_in;
    wire       out_or8;
    
    // Multi-way Muxes
    reg [15:0] t_m4_a, t_m4_b, t_m4_c, t_m4_d;
    reg [1:0]  t_m4_sel;
    wire [15:0] out_m4;
    
    reg [15:0] t_m8_a, t_m8_b, t_m8_c, t_m8_d, t_m8_e, t_m8_f, t_m8_g, t_m8_h;
    reg [2:0]  t_m8_sel;
    wire [15:0] out_m8;
    
    // Multi-way DMuxes
    reg        t_dm4_in, t_dm8_in;
    reg [1:0]  t_dm4_sel;
    reg [2:0]  t_dm8_sel;
    wire       out_dm4_a, out_dm4_b, out_dm4_c, out_dm4_d;
    wire       out_dm8_a, out_dm8_b, out_dm8_c, out_dm8_d, out_dm8_e, out_dm8_f, out_dm8_g, out_dm8_h;

    nand_gate u_nand (.a(t_a), .b(t_b), .out(out_nand));
    not_gate  u_not  (.in(t_a), .out(out_not)); 
    and_gate  u_and  (.a(t_a), .b(t_b), .out(out_and));
    or_gate   u_or   (.a(t_a), .b(t_b), .out(out_or));
    xor_gate  u_xor  (.a(t_a), .b(t_b), .out(out_xor));
    
    mux       u_mux  (.a(t_a), .b(t_b), .sel(t_mux_sel), .out(out_mux));
    dmux      u_dmux (.in(t_dmux_in), .sel(t_dmux_sel), .a(out_dmux_a), .b(out_dmux_b));
    
    not16     u_not16 (.in(t_in16), .out(out_not16));
    and16     u_and16 (.a(t_a16), .b(t_b16), .out(out_and16));
    or16      u_or16  (.a(t_a16), .b(t_b16), .out(out_or16));
    mux16     u_mux16 (.a(t_mux16_a), .b(t_mux16_b), .sel(t_mux16_sel), .out(out_mux16));
    Or8Way    u_or8   (.in(t_or8_in), .out(out_or8));
    
    mux4way16 u_m416  (.a(t_m4_a), .b(t_m4_b), .c(t_m4_c), .d(t_m4_d), .sel(t_m4_sel), .out(out_m4));
    mux8way16 u_m816  (.a(t_m8_a), .b(t_m8_b), .c(t_m8_c), .d(t_m8_d), .e(t_m8_e), .f(t_m8_f), .g(t_m8_g), .h(t_m8_h), .sel(t_m8_sel), .out(out_m8));
    
    dmux4way  u_dm4   (.in(t_dm4_in), .sel(t_dm4_sel), .a(out_dm4_a), .b(out_dm4_b), .c(out_dm4_c), .d(out_dm4_d));
    
    dmux8way   u_dm8   (.in(t_dm8_in), .sel(t_dm8_sel), .a(out_dm8_a), .b(out_dm8_b), .c(out_dm8_c), .d(out_dm8_d), .e(out_dm8_e), .f(out_dm8_f), .g(out_dm8_g), .h(out_dm8_h));

    integer i;

    initial begin

        // 1-Bit Basic Logic Gate Testing ---
        $display("\n[1-Bit Basic Gates]");
        for (i = 0; i < 4; i = i + 1) begin
            {t_a, t_b} = i;
            #10;
            $display("INPUTS: a=%b b=%b | NAND=%b NOT(a)=%b AND=%b OR=%b XOR=%b", 
                     t_a, t_b, out_nand, out_not, out_and, out_or, out_xor);
        end

        // 1-Bit Mux & DMux ---
        $display("\n[1-Bit Mux & DMux]");
        t_a = 1'b0; t_b = 1'b1; 
        t_mux_sel = 0; #5; $display("Mux (a=0, b=1, sel=0)  out=%b", out_mux);
        t_mux_sel = 1; #5; $display("Mux (a=0, b=1, sel=1)  out=%b", out_mux);
        
        t_dmux_in = 1'b1; 
        t_dmux_sel = 0; #5; $display("DMux (in=1, sel=0)    a=%b, b=%b", out_dmux_a, out_dmux_b);
        t_dmux_sel = 1; #5; $display("DMux (in=1, sel=1)    a=%b, b=%b", out_dmux_a, out_dmux_b);

        // 16-Bit Gates & Bus Operations ---
        $display("\n[16-Bit Logic & Reduction Or8Way]");
        t_in16 = 16'h00FF;
        t_a16  = 16'h0F0F;
        t_b16  = 16'hF0F0;
        #10;
        $display("Not16 (in=%h)       out=%h", t_in16, out_not16);
        $display("And16 (a=%h, b=%h)  out=%h", t_a16, t_b16, out_and16);
        $display("Or16  (a=%h, b=%h)  out=%h", t_a16, t_b16, out_or16);

        // Mux16 Test
        t_mux16_a = 0; t_mux16_b = 1; t_mux16_sel = 1; #10;
        $display("Mux16 (a=%b, b=%b, sel=%b) out=%b", t_mux16_a, t_mux16_b, t_mux16_sel, out_mux16);

        // Or8Way Test
        t_or8_in = 8'b00000000; #5; $display("Or8Way (in=%b) out=%b", t_or8_in, out_or8);
        t_or8_in = 8'b00100000; #5; $display("Or8Way (in=%b) out=%b", t_or8_in, out_or8);

        // Mux4Way16 & DMux4Way Loop ---
        $display("\n[Mux4Way16 & DMux4Way Testing]");
        t_m4_a = 16'hAAAA; t_m4_b = 16'hBBBB; t_m4_c = 16'hCCCC; t_m4_d = 16'hDDDD;
        t_dm4_in = 1'b1;
        
        for (i = 0; i < 4; i = i + 1) begin
            t_m4_sel  = i;
            t_dm4_sel = i;
            #10;
            $display("Sel=%b | Mux4Way16 Out=%h | DMux4Way Outputs (a,b,c,d)=%b%b%b%b", 
                     t_m4_sel, out_m4, out_dm4_a, out_dm4_b, out_dm4_c, out_dm4_d);
        end

        // Mux8Way16 & DMux8way (
        $display("\n[Mux8Way16 & DMuxway (8-Way) Testing]");
        t_m8_a = 16'h1111; t_m8_b = 16'h2222; t_m8_c = 16'h3333; t_m8_d = 16'h4444;
        t_m8_e = 16'h5555; t_m8_f = 16'h6666; t_m8_g = 16'h7777; t_m8_h = 16'h8888;
        t_dm8_in = 1'b1;

        for (i = 0; i < 8; i = i + 1) begin
            t_m8_sel  = i;
            t_dm8_sel = i;
            #10;
            $display("Sel=%3b | Mux8Way16 Out=%h | DMux8Way (a->h)=%b%b%b%b%b%b%b%b", 
                     t_m8_sel, out_m8, out_dm8_a, out_dm8_b, out_dm8_c, out_dm8_d, out_dm8_e, out_dm8_f, out_dm8_g, out_dm8_h);
        end

        $finish;
    end

endmodule