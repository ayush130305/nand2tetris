`timescale 1ns / 1ps

module tb_Computer;

    reg  clk, reset;
    reg  [15:0] rom [0:32767];
    wire [15:0] instruction;

    always #5 clk = ~clk;

    // Feed ROM using PC from inside CPU
    assign instruction = rom[uut.cpu.pc[14:0]];

    Computer uut (
        .clk         (clk),
        .reset       (reset),
        .instruction (instruction)
    );

    initial begin
        // Load program
        rom[0] = 16'b0000000000000101;   // @5
        rom[1] = 16'b1110110000010000;   // D = A
        rom[2] = 16'b0000000000000011;   // @3
        rom[3] = 16'b1110000010010000;   // D = D+A
        rom[4] = 16'b0000000000000000;   // @0
        rom[5] = 16'b1110001100001000;   // M = D  → RAM[0] = 8
        rom[6] = 16'b0000000000000110;   // @6
        rom[7] = 16'b1110101010000111;   // 0;JMP

        // Zero out rom
        begin : init_rom
            integer i;
            for (i = 8; i < 32768; i = i + 1)
                rom[i] = 16'b0;
        end

        clk = 0; reset = 1;
        #20 reset = 0;
        #300;

        if (uut.cpu.d_out == 16'd8)
            $display("PASS - D = %0d", uut.cpu.d_out);
        else
            $display("FAIL - D = %0d", uut.cpu.d_out);

        $finish;
    end

endmodule