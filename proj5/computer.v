`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2026 09:42:41 AM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dff(input in, input clk, output reg out);
    always @(posedge clk) begin
     out <= in;
     end
endmodule

module bit_register (input clk, input in, input load, output out);
    wire mux_out;
    
    assign mux_out= load? in:out;
    
    dff storage(.clk(clk),
        .in(mux_out),
        .out(out));
endmodule

module Register (
    input clk,
    input [15:0] in,
    input load,
    output [15:0] out
);

    bit_register bit0  (.clk(clk), .in(in[0]),  .load(load), .out(out[0]));
    bit_register bit1  (.clk(clk), .in(in[1]),  .load(load), .out(out[1]));
    bit_register bit2  (.clk(clk), .in(in[2]),  .load(load), .out(out[2]));
    bit_register bit3  (.clk(clk), .in(in[3]),  .load(load), .out(out[3]));
    bit_register bit4  (.clk(clk), .in(in[4]),  .load(load), .out(out[4]));
    bit_register bit5  (.clk(clk), .in(in[5]),  .load(load), .out(out[5]));
    bit_register bit6  (.clk(clk), .in(in[6]),  .load(load), .out(out[6]));
    bit_register bit7  (.clk(clk), .in(in[7]),  .load(load), .out(out[7]));
    bit_register bit8  (.clk(clk), .in(in[8]),  .load(load), .out(out[8]));
    bit_register bit9  (.clk(clk), .in(in[9]),  .load(load), .out(out[9]));
    bit_register bit10 (.clk(clk), .in(in[10]), .load(load), .out(out[10]));
    bit_register bit11 (.clk(clk), .in(in[11]), .load(load), .out(out[11]));
    bit_register bit12 (.clk(clk), .in(in[12]), .load(load), .out(out[12]));
    bit_register bit13 (.clk(clk), .in(in[13]), .load(load), .out(out[13]));
    bit_register bit14 (.clk(clk), .in(in[14]), .load(load), .out(out[14]));
    bit_register bit15 (.clk(clk), .in(in[15]), .load(load), .out(out[15]));
endmodule

module RAM8 (
    input clk,
    input [15:0] in, 
    input load,
    input [2:0] address,
    output reg [15:0] out
);
    wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7; //8 words of 16 bits
    reg [7:0] load_demux;

    always @(*) begin
        load_demux = 8'b0;
        if (load) load_demux[address] = 1'b1;
    end

    Register reg0 (.clk(clk), .in(in), .load(load_demux[0]), .out(r0));
    Register reg1 (.clk(clk), .in(in), .load(load_demux[1]), .out(r1));
    Register reg2 (.clk(clk), .in(in), .load(load_demux[2]), .out(r2));
    Register reg3 (.clk(clk), .in(in), .load(load_demux[3]), .out(r3));
    Register reg4 (.clk(clk), .in(in), .load(load_demux[4]), .out(r4));
    Register reg5 (.clk(clk), .in(in), .load(load_demux[5]), .out(r5));
    Register reg6 (.clk(clk), .in(in), .load(load_demux[6]), .out(r6));
    Register reg7 (.clk(clk), .in(in), .load(load_demux[7]), .out(r7));

    always @(*) begin
        case (address)
            3'b000: out = r0; 3'b001: out = r1; 3'b010: out = r2; 3'b011: out = r3;
            3'b100: out = r4; 3'b101: out = r5; 3'b110: out = r6; 3'b111: out = r7;
            default: out = 16'b0;
        endcase
    end
endmodule

module RAM64 (
    input clk,
    input [15:0] in,
    input load,
    input [5:0] address,
    output reg [15:0] out
);
    wire [15:0] m0, m1, m2, m3, m4, m5, m6, m7;
    reg [7:0] load_demux;

    always @(*) begin
        load_demux = 8'b0;
        if (load) load_demux[address[5:3]] = 1'b1;
    end

    //  address[2:0] selects internal word indices
    RAM8 block0 (.clk(clk), .in(in), .load(load_demux[0]), .address(address[2:0]), .out(m0));
    RAM8 block1 (.clk(clk), .in(in), .load(load_demux[1]), .address(address[2:0]), .out(m1));
    RAM8 block2 (.clk(clk), .in(in), .load(load_demux[2]), .address(address[2:0]), .out(m2));
    RAM8 block3 (.clk(clk), .in(in), .load(load_demux[3]), .address(address[2:0]), .out(m3));
    RAM8 block4 (.clk(clk), .in(in), .load(load_demux[4]), .address(address[2:0]), .out(m4));
    RAM8 block5 (.clk(clk), .in(in), .load(load_demux[5]), .address(address[2:0]), .out(m5));
    RAM8 block6 (.clk(clk), .in(in), .load(load_demux[6]), .address(address[2:0]), .out(m6));
    RAM8 block7 (.clk(clk), .in(in), .load(load_demux[7]), .address(address[2:0]), .out(m7));

    always @(*) begin
        case (address[5:3]) //address[5:3] handles block selection
            3'b000: out = m0; 3'b001: out = m1; 3'b010: out = m2; 3'b011: out = m3;
            3'b100: out = m4; 3'b101: out = m5; 3'b110: out = m6; 3'b111: out = m7;
            default: out = 16'b0;
        endcase
    end
endmodule

module RAM512 (
    input clk,
    input [15:0] in,
    input load,
    input [8:0] address,
    output reg [15:0] out
);
    wire [15:0] m0, m1, m2, m3, m4, m5, m6, m7;
    reg [7:0] load_demux;

    always @(*) begin
        load_demux = 8'b0;
        if (load) load_demux[address[8:6]] = 1'b1;
    end
    //RAM 64* 8
    RAM64 block0 (.clk(clk), .in(in), .load(load_demux[0]), .address(address[5:0]), .out(m0));
    RAM64 block1 (.clk(clk), .in(in), .load(load_demux[1]), .address(address[5:0]), .out(m1));
    RAM64 block2 (.clk(clk), .in(in), .load(load_demux[2]), .address(address[5:0]), .out(m2));
    RAM64 block3 (.clk(clk), .in(in), .load(load_demux[3]), .address(address[5:0]), .out(m3));
    RAM64 block4 (.clk(clk), .in(in), .load(load_demux[4]), .address(address[5:0]), .out(m4));
    RAM64 block5 (.clk(clk), .in(in), .load(load_demux[5]), .address(address[5:0]), .out(m5));
    RAM64 block6 (.clk(clk), .in(in), .load(load_demux[6]), .address(address[5:0]), .out(m6));
    RAM64 block7 (.clk(clk), .in(in), .load(load_demux[7]), .address(address[5:0]), .out(m7));

    always @(*) begin
        case (address[8:6])
            3'b000: out = m0; 3'b001: out = m1; 3'b010: out = m2; 3'b011: out = m3;
            3'b100: out = m4; 3'b101: out = m5; 3'b110: out = m6; 3'b111: out = m7;
            default: out = 16'b0;
        endcase
    end
endmodule

module RAM4K (
    input clk,
    input [15:0] in,
    input load,
    input [11:0] address,
    output reg [15:0] out
);
    wire [15:0] m0, m1, m2, m3, m4, m5, m6, m7;
    reg [7:0] load_demux;

    always @(*) begin
        load_demux = 8'b0;
        if (load) load_demux[address[11:9]] = 1'b1;
    end
    //RAM 512 * 8
    RAM512 block0 (.clk(clk), .in(in), .load(load_demux[0]), .address(address[8:0]), .out(m0));
    RAM512 block1 (.clk(clk), .in(in), .load(load_demux[1]), .address(address[8:0]), .out(m1));
    RAM512 block2 (.clk(clk), .in(in), .load(load_demux[2]), .address(address[8:0]), .out(m2));
    RAM512 block3 (.clk(clk), .in(in), .load(load_demux[3]), .address(address[8:0]), .out(m3));
    RAM512 block4 (.clk(clk), .in(in), .load(load_demux[4]), .address(address[8:0]), .out(m4));
    RAM512 block5 (.clk(clk), .in(in), .load(load_demux[5]), .address(address[8:0]), .out(m5));
    RAM512 block6 (.clk(clk), .in(in), .load(load_demux[6]), .address(address[8:0]), .out(m6));
    RAM512 block7 (.clk(clk), .in(in), .load(load_demux[7]), .address(address[8:0]), .out(m7));

    always @(*) begin
        case (address[11:9])
            3'b000: out = m0; 3'b001: out = m1; 3'b010: out = m2; 3'b011: out = m3;
            3'b100: out = m4; 3'b101: out = m5; 3'b110: out = m6; 3'b111: out = m7;
            default: out = 16'b0;
        endcase
    end
endmodule

module RAM16K (
    input clk,
    input [15:0] in,
    input load,
    input [13:0] address,
    output reg [15:0] out
);
    wire [15:0] m0, m1, m2, m3;
    reg [3:0] load_demux;

    always @(*) begin
        load_demux = 4'b0;
        if (load) load_demux[address[13:12]] = 1'b1;
    end

    // RAM4K blocks * 4
    RAM4K block0 (.clk(clk), .in(in), .load(load_demux[0]), .address(address[11:0]), .out(m0));
    RAM4K block1 (.clk(clk), .in(in), .load(load_demux[1]), .address(address[11:0]), .out(m1));
    RAM4K block2 (.clk(clk), .in(in), .load(load_demux[2]), .address(address[11:0]), .out(m2));
    RAM4K block3 (.clk(clk), .in(in), .load(load_demux[3]), .address(address[11:0]), .out(m3));

    always @(*) begin
        case (address[13:12])
            2'b00: out = m0;
            2'b01: out = m1;
            2'b10: out = m2;
            2'b11: out = m3;
            default: out = 16'b0;
        endcase
    end
endmodule

module PC (
    input clk,
    input [15:0] in,
    input load,
    input inc,
    input reset,
    output [15:0] out
);
    reg [15:0] feedback_mux;


    always @(*) begin
        if (reset)
            feedback_mux = 16'b0;              // clear input
        else if (load)
            feedback_mux = in;                 // jump instruction execution
        else if (inc)
            feedback_mux = out + 16'b1;        // to next index
        else
            feedback_mux = out;                // Default: Hold 
    end

    // Plug selection lines into a 16-bit register execution tracking cell
    Register pc_storage_instance (.clk(clk), .in(feedback_mux), .load(1'b1), .out(out));
endmodule

module ALU (
    input [15:0] x, y,
    input zx, nx, zy, ny, f, no,
    output [15:0] out,
    output zr, ng
);
    wire [15:0] x_z, x_n, y_z, y_n, f_out, final_out;

    // Pre-set x input
    assign x_z = zx ? 16'b0 : x;
    assign x_n = nx ? ~x_z : x_z;

    // Pre-set y input
    assign y_z = zy ? 16'b0 : y;
    assign y_n = ny ? ~y_z : y_z;

    // Select between x+y (f=1) or x&y (f=0)
    assign f_out = f ? (x_n + y_n) : (x_n & y_n);

    // Post-set the output
    assign final_out = no ? ~f_out : f_out;
    assign out = final_out;

    // Status bits
    assign zr = (final_out == 16'b0); // out == 0
    assign ng = final_out[15];        // out < 0 (MSB is 1)
endmodule

module CPU (
    input  wire        clk,
    input  wire        reset,
    input  wire [15:0] inM,
    input  wire [15:0] instruction,
    output wire [15:0] outM,
    output wire        writeM,
    output wire [13:0] addressM,
    output wire [15:0] pc
);

    // Decode instruction 
    wire i_type = instruction[15];   // 0 = A-instruction, 1 = C-instruction

    // C-instruction fields
    wire       comp_a = instruction[12];        // 0=use A, 1=use M
    wire [5:0] comp   = instruction[11:6];      // zx nx zy ny f no
    wire [2:0] dest   = instruction[5:3];       // dest[2]=A, [1]=D, [0]=M
    wire [2:0] jump   = instruction[2:0];       // j1 j2 j3

    //ALU wires
    wire [15:0] alu_out;
    wire        alu_zr, alu_ng;

    // A Register
    wire [15:0] a_out;
    wire [15:0] a_in;
    wire        a_load;

    assign a_in   = i_type ? alu_out : instruction;  // C: from ALU, A: from instruction
    assign a_load = (~i_type) | (i_type & dest[2]);  // always load on A-instr

    Register A_reg (
        .clk  (clk),
        .in   (a_in),
        .load (a_load),
        .out  (a_out)
    );

    //D Register
    wire [15:0] d_out;
    wire        d_load;

    assign d_load = i_type & dest[1];   // load D only on C-instruction

    Register D_reg (
        .clk  (clk),
        .in   (alu_out),
        .load (d_load),
        .out  (d_out)
    );

    // alu
    wire [15:0] alu_y;
    assign alu_y = comp_a ? inM : a_out;    // y = M or A

    ALU alu (
        .x   (d_out),
        .y   (alu_y),
        .zx  (comp[5]),
        .nx  (comp[4]),
        .zy  (comp[3]),
        .ny  (comp[2]),
        .f   (comp[1]),
        .no  (comp[0]),
        .out (alu_out),
        .zr  (alu_zr),
        .ng  (alu_ng)
    );

    // output
    assign outM     = alu_out;
    assign addressM = a_out[13:0];
    assign writeM   = i_type & dest[0];     // write M only on C-instruction

    // jmp
    wire alu_pos  = ~alu_zr & ~alu_ng;     // out > 0

    wire do_jump;
    assign do_jump = (jump[2] & alu_ng)    // JLT: out < 0
                   | (jump[1] & alu_zr)    // JEQ: out = 0
                   | (jump[0] & alu_pos);  // JGT: out > 0

    PC pc_unit (
        .clk   (clk),
        .in    (a_out),
        .load  (i_type & do_jump),
        .inc   (1'b1),
        .reset (reset),
        .out   (pc)
    );

endmodule 

module Computer (
    input wire        clk,
    input wire        reset,
    input wire [15:0] instruction    
);

    wire [15:0] pc;
    wire [15:0] inM;
    wire [15:0] outM;
    wire        writeM;
    wire [13:0] addressM;

    CPU cpu (
        .clk         (clk),
        .reset       (reset),
        .inM         (inM),
        .instruction (instruction),   
        .outM        (outM),
        .writeM      (writeM),
        .addressM    (addressM),
        .pc          (pc)
    );

    RAM16K ram (
        .clk     (clk),
        .in      (outM),
        .load    (writeM),
        .address (addressM),
        .out     (inM)
    );

endmodule
                   