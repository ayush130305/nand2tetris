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
