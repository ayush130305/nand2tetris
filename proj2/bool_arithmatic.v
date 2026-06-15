module half_adder(input a,input b, output sum, output carry);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder(input a,input b, input c, output sum, output carry);
    wire s1, c1, c2;

    half_adder HA1 (.a(a),  .b(b), .sum(s1),  .carry(c1));
    half_adder HA2 (.a(s1), .b(c), .sum(sum), .carry(c2));
    
    assign carry = c1 | c2;
endmodule

module add16 (input [15:0] a, input [15:0] b, output [15:0] out);
   wire [16:0] c; 
   
    half_adder HA0 (.a(a[0]), .b(b[0]), .sum(out[0]), .carry(c[0]));
   
    full_adder FA1  (.a(a[1]),  .b(b[1]),  .c(c[0]),  .sum(out[1]),  .carry(c[1]));
    full_adder FA2  (.a(a[2]),  .b(b[2]),  .c(c[1]),  .sum(out[2]),  .carry(c[2]));
    full_adder FA3  (.a(a[3]),  .b(b[3]),  .c(c[2]),  .sum(out[3]),  .carry(c[3]));
    full_adder FA4  (.a(a[4]),  .b(b[4]),  .c(c[3]),  .sum(out[4]),  .carry(c[4]));
    full_adder FA5  (.a(a[5]),  .b(b[5]),  .c(c[4]),  .sum(out[5]),  .carry(c[5]));
    full_adder FA6  (.a(a[6]),  .b(b[6]),  .c(c[5]),  .sum(out[6]),  .carry(c[6]));
    full_adder FA7  (.a(a[7]),  .b(b[7]),  .c(c[6]),  .sum(out[7]),  .carry(c[7]));
    full_adder FA8  (.a(a[8]),  .b(b[8]),  .c(c[7]),  .sum(out[8]),  .carry(c[8]));
    full_adder FA9  (.a(a[9]),  .b(b[9]),  .c(c[8]),  .sum(out[9]),  .carry(c[9]));
    full_adder FA10 (.a(a[10]), .b(b[10]), .c(c[9]),  .sum(out[10]), .carry(c[10]));
    full_adder FA11 (.a(a[11]), .b(b[11]), .c(c[10]), .sum(out[11]), .carry(c[11]));
    full_adder FA12 (.a(a[12]), .b(b[12]), .c(c[11]), .sum(out[12]), .carry(c[12]));
    full_adder FA13 (.a(a[13]), .b(b[13]), .c(c[12]), .sum(out[13]), .carry(c[13]));
    full_adder FA14 (.a(a[14]), .b(b[14]), .c(c[13]), .sum(out[14]), .carry(c[14]));
    full_adder FA15 (.a(a[15]), .b(b[15]), .c(c[14]), .sum(out[15]), .carry(c[15])); 
endmodule

module inc16(input [15:0] in, output [15:0] out);
    assign out = in + 16'd1;
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