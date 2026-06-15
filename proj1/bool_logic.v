`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/15/2026 03:16:40 PM
// Design Name: 
// Module Name: bool_logic
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


module nand_gate(input a, input b, output out);
    assign out = ~(a & b);   
endmodule

module not_gate(input in, output out);
    assign out = ~ (in);
endmodule 

module and_gate(input a, input b, output out);
    assign out = a & b;
endmodule

module or_gate(input a, input b, output out);
    assign out = a | b ;
endmodule

module xor_gate(input a, input b, output out);
    assign out = a ^ b ;
endmodule  

module mux(input a, input b, input sel, output out);
    assign out = sel? b : a;
endmodule

module dmux(input in, input sel, output a, output b);
    assign a = sel? 1'b0:in;
    assign b = sel? in:1'b0;
endmodule

module not16 (input [15:0] in, output [15:0] out);
    assign out = ~(in);
endmodule

module and16 (input [15:0] a, input [15:0] b, output [15:0] out);
    assign out = a & b;
endmodule

module or16 (input [15:0] a, input [15:0] b, output [15:0] out);
    assign out = a | b;
endmodule

module mux16 (input a, input b, input sel, output out);
    assign out = sel? b : a;
endmodule

module Or8Way (input [7:0] in, output out);
    assign out = |in;
endmodule

module mux4way16 (
    input [15:0] a, b, c, d,
    input [1:0] sel,
    output reg [15:0] out
);
    always @(*) begin
        case (sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 16'b0;
        endcase
    end
endmodule

module mux8way16 (
    input [15:0] a, b, c, d, e, f, g, h,
    input [2:0] sel,
    output reg [15:0] out
);
    always @(*) begin
        case (sel)
            3'b000: out = a;
            3'b001: out = b;
            3'b010: out = c;
            3'b011: out = d;
            3'b100: out = e;
            3'b101: out = f;
            3'b110: out = g;
            3'b111: out = h;
            default: out = 16'b0;
        endcase
    end
endmodule

module dmux4way (
    input in, input [1:0] sel,
    output reg a, b, c, d
);
    always @(*) begin
        {a, b, c, d} = 4'b0000;
        case (sel)
            2'b00: a = in;
            2'b01: b = in;
            2'b10: c = in;
            2'b11: d = in;
        endcase
    end
endmodule

module dmux8way (
    input in, input [2:0] sel,
    output reg a, b, c, d, e, f, g, h
);
    always @(*) begin
        {a, b, c, d, e, f, g, h} = 8'b00000000;
        case (sel)
            3'b000: a = in;
            3'b001: b = in;
            3'b010: c = in;
            3'b011: d = in;
            3'b100: e = in;
            3'b101: f = in;
            3'b110: g = in;
            3'b111: h = in;
        endcase
    end
endmodule





