`timescale 1ns / 1ps
//  功能说明
    //  立即数拓展，将指令中的立即数部分拓展为完整立即数
// 输入
    // Inst              指令的[31:7]
    // ImmType           立即数类型
// 输出
    // imm               补全的立即数
// 实验要求
    // finish


`include "Parameters.v"   
module ImmExtend(
    input wire [31:0] inst,
    input wire [2:0] imm_type,
    output reg [31:0] imm
    );

    always@(*)
    begin
        case(imm_type)
            `RTYPE: imm = {27'b0, inst[14:10]};//立即数移位运算
            `S12:   imm = {{20{inst[21]}}, inst[21:10]};
            `U12:   imm = {{20{1'b0}}, inst[21:10]};
            `F20:   imm = {inst[24:5], 12'b0};
            `S16:   imm = {{14{inst[25]}}, inst[25:10], 2'b0};
            `S26:   imm = {{4{inst[25]}}, inst[9:0], inst[25:10], 2'b0};

            default: imm = 32'b0;
        endcase
    end
endmodule
