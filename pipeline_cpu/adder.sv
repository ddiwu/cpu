`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/08 23:45:15
// Design Name: 
// Module Name: adder
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


module adder(
    input [31:0]A,
    input [31:0]B,
    input Cin,//加减法
    output carry,
    output overflow,
    output [31:0] y
    );
    //logic [32:0] h;

    //assign h = {1'b0,A} + {1'b0,B} + {32'b0,Cin};
    assign {carry, y} = A + B + Cin;
    assign overflow = (~Cin & ~A[31] & ~B[31] & y[31]) | (~Cin & A[31] & B[31] & ~y[31]) | (Cin & A[31] & ~B[31] & ~y[31]) | (Cin & ~A[31] & B[31] & y[31]);

endmodule
