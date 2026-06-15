`timescale 1ns / 1ps

module arithmetic_tb();

     // Half Adder & Full Adder Signals
    reg         t_a, t_b, t_c;
    wire        ha_sum, ha_carry;
    wire        fa_sum, fa_carry;

    // Add16 & Inc16 Signals
    reg  [15:0] t_a16, t_b16, t_inc_in;
    wire [15:0] out_add16, out_inc16;

    // ALU Signals
    reg  [15:0] alu_x, alu_y;
    reg         zx, nx, zy, ny, f, no;
    wire [15:0] alu_out;
    wire        zr, ng;

    half_adder u_ha (
        .a(t_a), .b(t_b), .sum(ha_sum), .carry(ha_carry)
    );

    full_adder u_fa (
        .a(t_a), .b(t_b), .c(t_c), .sum(fa_sum), .carry(fa_carry)
    );

    add16 u_add16 (
        .a(t_a16), .b(t_b16), .out(out_add16)
    );

    inc16 u_inc16 (
        .in(t_inc_in), .out(out_inc16)
    );

    ALU u_alu (
        .x(alu_x), .y(alu_y),
        .zx(zx), .nx(nx), .zy(zy), .ny(ny), .f(f), .no(no),
        .out(alu_out), .zr(zr), .ng(ng)
    );

     integer i;

    initial begin
     
        $display("\n HALF ADDER]");
        $display(" A  B | Sum Carry");
        for (i = 0; i < 4; i = i + 1) begin
            {t_a, t_b} = i;
            #10;
            $display(" %b  %b |  %b     %b", t_a, t_b, ha_sum, ha_carry);
        end

         $display("\n FULL ADDER ");
        $display(" A  B  C | Sum Carry");
        for (i = 0; i < 8; i = i + 1) begin
            {t_a, t_b, t_c} = i;
            #10;
            $display(" %b  %b  %b |  %b     %b", t_a, t_b, t_c, fa_sum, fa_carry);
        end

        $display("\n ADD16");
        
        t_a16 = 16'd123;   t_b16 = 16'd456;   #10;
        $display("  %0d + %0d = %0d", t_a16, t_b16, out_add16);
        
        $display("\n INC16 ");
        
        t_inc_in = 16'd99; #10;
        $display("  Increment (%0d)  = %0d", t_inc_in, out_inc16);
        
        t_inc_in = 16'hFFFF; #10;
        $display("  Increment (Hex %h) = %h", t_inc_in, out_inc16);

         $display("\n ALU");
        $display("Inputs preset to: X = 16'd25, Y = 16'd10\n");
        $display(" zx nx zy ny  f no | Output (Dec) | Flags [zr ng]");
        
        alu_x = 16'd25; 
        alu_y = 16'd10;

        // Command: Output 0
        zx=1; nx=0; zy=1; ny=0; f=1; no=0; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: 0)", zx, nx, zy, ny, f, no, alu_out, zr, ng);

        // Command: Output 1
        zx=1; nx=1; zy=1; ny=1; f=1; no=1; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: 1)", zx, nx, zy, ny, f, no, alu_out, zr, ng);

        // Command: Output -1
        zx=1; nx=1; zy=1; ny=0; f=1; no=0; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: -1)", zx, nx, zy, ny, f, no, $signed(alu_out), zr, ng);

        // Command: Pass X straight through
        zx=0; nx=0; zy=1; ny=1; f=0; no=0; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: X)", zx, nx, zy, ny, f, no, alu_out, zr, ng);

        // Command: Compute X + Y
        zx=0; nx=0; zy=0; ny=0; f=1; no=0; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: X+Y)", zx, nx, zy, ny, f, no, alu_out, zr, ng);

        // Command: Compute X - Y
        zx=0; nx=1; zy=0; ny=0; f=1; no=1; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: X-Y)", zx, nx, zy, ny, f, no, $signed(alu_out), zr, ng);

        // Command: Compute Y - X (Should result in Negative Flag triggered)
        zx=0; nx=0; zy=0; ny=1; f=1; no=1; #10;
        $display("  %b  %b  %b  %b  %b  %b | %12d |   %b   %b  (Expected: Y-X)", zx, nx, zy, ny, f, no, $signed(alu_out), zr, ng);

       $finish;
    end

endmodule