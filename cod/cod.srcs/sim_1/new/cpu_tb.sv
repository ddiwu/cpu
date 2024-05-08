`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/04 15:43:09
// Design Name: 
// Module Name: cpu_tb
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

module cpu_tb();
    reg clk = 1'b1;
    reg rst = 1'b1;
    
    always  #5 clk = ~clk;
    initial #22 rst = 1'b0;

    reg [31:0] CPU_Debug_DataCache_A2 = 0;
    reg [31:0] CPU_Debug_DataCache_WD2 = 0;
    reg [3:0] CPU_Debug_DataCache_WE2 = 0;
    wire [31:0] CPU_Debug_DataCache_RD2;
    reg [31:0] CPU_Debug_InstCache_A2 = 0;
    reg [31:0] CPU_Debug_InstCache_WD2 = 0;
    reg [3:0] CPU_Debug_InstCache_WE2 = 0;
    wire [31:0] CPU_Debug_InstCache_RD2;

    
    
    RV32ICore  RV32ICore_inst (
        .CPU_CLK(clk),
        .CPU_RST(rst),
        .CPU_Debug_DataCache_A2(CPU_Debug_DataCache_A2),
        .CPU_Debug_DataCache_WD2(CPU_Debug_DataCache_WD2),
        .CPU_Debug_DataCache_WE2(CPU_Debug_DataCache_WE2),
        .CPU_Debug_DataCache_RD2(CPU_Debug_DataCache_RD2),
        .CPU_Debug_InstCache_A2(CPU_Debug_InstCache_A2),
        .CPU_Debug_InstCache_WD2(CPU_Debug_InstCache_WD2),
        .CPU_Debug_InstCache_WE2(CPU_Debug_InstCache_WE2),
        .CPU_Debug_InstCache_RD2(CPU_Debug_InstCache_RD2)
      );
    
endmodule