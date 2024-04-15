`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/09 14:29:42
// Design Name: 
// Module Name: forwarding
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


module forwarding(
    input [4:0] rf_addr1,
    input [4:0] rf_addr2,
    input [4:0] rf_rd_2r,
    input [4:0] rf_rd_3r,
    input wb_sel_3r,
    output logic [1:0] rf_data1_sel,
    output logic [1:0] rf_data2_sel,
    input logic stall1,
    input logic stall2
    );

    //组合逻辑单元没有延迟，一个周期干好,通过寄存器里wb_sel指，提前判断给哪个（防止落到下一个周期更为复杂）

    logic stall;
    assign stall = stall1 | stall2;
    always @(*)//stall时就不要进行判断啦
    begin
        if(rf_addr1 == rf_rd_2r && rf_rd_2r != 5'b0 && !stall1)
            rf_data1_sel = 2'b01;
        else if(rf_addr1 == rf_rd_3r && wb_sel_3r == 1'b1 && !stall2)
            rf_data1_sel = 2'b10;
        else if(rf_addr1 == rf_rd_3r && wb_sel_3r == 1'b0 && !stall2)
            rf_data1_sel = 2'b11;
        else
            rf_data1_sel = 2'b00;
    end

    always @(*)
    begin
        if(rf_addr2 == rf_rd_2r && rf_rd_2r != 5'b0 && !stall1)
            rf_data2_sel = 2'b01;
        else if(rf_addr2 == rf_rd_3r && wb_sel_3r == 1'b1 && !stall2)
            rf_data2_sel = 2'b10;
        else if(rf_addr2 == rf_rd_3r && wb_sel_3r == 1'b0 && !stall2)
            rf_data2_sel = 2'b11;
        else
            rf_data2_sel = 2'b00;
    end


endmodule
