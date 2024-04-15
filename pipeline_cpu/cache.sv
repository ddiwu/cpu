`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 14:53:15
// Design Name: 
// Module Name: cache
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


module icache(
    input logic [31:0] PC,//npc要提前一个周期就开始读才能保证时序
    input logic        clk,
    input logic        rstn,
    input logic jump_en,
    input logic jump_en_r,
    output logic [31:0] inst,
    output logic sta
    );


    logic [7:0] index;
//    logic [19:0] tag;
    // logic [1:0] offset;
    logic valid,valid1,valid2,valid3;


    logic [31:0] data;
    logic [31:0] inst_ma0, inst_mb0,inst_ma1,inst_ma2,inst_mb1,inst_mb2,inst_mc1,inst_mc2,inst_mc0,inst_md0,inst_md1,inst_md2;//mem四个周期取到
    logic [31:0] inst_ma3,inst_mb3,inst_mc3,inst_md3;
    logic [31:0] PC_1, PC_2, PC_3, PC_4;
    logic [31:0] icnum1, icnum2, icnum3, icnum4, icnum5, icnum6, icnum7, icnum8;
//    logic [31:0] icnum1w, icnum2w, icnum3w, icnum4w, icnum5w, icnum6w, icnum7w, icnum8w;
    logic [19:0] ictag1,ictag2;
//    logic [19:0] ictag1w,ictag2w;
    logic wea1, wea2, wea3, wea4, wea5, wea6, wea7, wea8;
    logic wea_tag0, wea_tag1;
    logic [1:0] cnt;
    logic stall,stall1;

    //assign PC[11:4] = index1;
    // assign PC_1[31:12] = tag;//PC其实已经切换了
    //assign PC[3:2] = offset;
    assign sta = stall | ~valid;
    // assign q = stall1 & ~stall;

    // logic q;

    always@(posedge clk or negedge rstn)//cache未命中时延迟三个周期
    begin
        if(!rstn)
        begin
            cnt <= 2'b00;
            stall <= 1'b0;
        end
        else if(!valid && cnt == 2'b00)
        begin
            cnt <= 2'b01;//延迟三个周期
            stall <= 1'b1;
        end
        else if(cnt == 2'b00)
        begin
            stall <= 1'b0;
        end
        else 
        begin
            cnt <= cnt - 1;
        end
    end

    always@(*)
    begin
        if(!valid3)
        begin
            if(PC_4[3:2] == 2'b00)
            inst = inst_ma3;//分类一下
            else if(PC_4[3:2] == 2'b01)
            inst = inst_mb3;
            else if(PC_4[3:2] == 2'b10)
            inst = inst_mc3;
            else
            inst = inst_md3;
        end
        else if(valid)
        begin
            inst = data;
        end
        else 
        begin
            inst = 32'b0;
        end
    end


    Icache Icache_way0_1(
        .addra(index),
        .clka(clk),
        .dina(inst_ma3),
        //.douta(icnum1w),
        .ena(1'b1),
        .wea(wea1),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum1),
        .enb(1'b1)
    );

    Icache Icache_way0_2(
        .addra(index),
        .clka(clk),
        .dina(inst_mb3),
        //.douta(icnum2w),
        .ena(1'b1),
        .wea(wea2),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum2),
        .enb(1'b1)
    );

    Icache Icache_way0_3(
        .addra(index),
        .clka(clk),
        .dina(inst_mc3),
        //.douta(icnum3w),
        .ena(1'b1),
        .wea(wea3),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum3),
        .enb(1'b1)
    );

    Icache Icache_way0_4(
        .addra(index),
        .clka(clk),
        .dina(inst_md3),
        //.douta(icnum4w),
        .ena(1'b1),
        .wea(wea4),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum4),
        .enb(1'b1)
    );

    Icache Icache_way1_1(
        .addra(index),
        .clka(clk),
        .dina(inst_ma3),
        //.douta(icnum5w),
        .ena(1'b1),
        .wea(wea5),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum5),
        .enb(1'b1)
    );

    Icache Icache_way1_2(
        .addra(index),
        .clka(clk),
        .dina(inst_mb3),
        //.douta(icnum6w),
        .ena(1'b1),
        .wea(wea6),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum6),
        .enb(1'b1)
    );

    Icache Icache_way1_3(
        .addra(index),
        .clka(clk),
        .dina(inst_mc3),
        //.douta(icnum7w),
        .ena(1'b1),
        .wea(wea7),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum7),
        .enb(1'b1)
    );

    Icache Icache_way1_4(
        .addra(index),
        .clka(clk),
        .dina(inst_md3),
        //.douta(icnum8w),
        .ena(1'b1),
        .wea(wea8),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(icnum8),
        .enb(1'b1)
    );

    Icache Icache_tag0(
        .addra(index),
        .clka(clk),
        .dina(PC_4[31:12]),
        //.douta(ictag1w),
        .ena(1'b1),
        .wea(wea_tag0),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(ictag1),
        .enb(1'b1)
    );

    Icache Icache_tag1(
        .addra(index),
        .clka(clk),
        .dina(PC_4[31:12]),
        //.douta(ictag2w),
        .ena(1'b1),
        .wea(wea_tag1),
        .addrb(PC[11:4]),
        .clkb(clk),
        .doutb(ictag2),
        .enb(1'b1)
    );

    always@(*)
    begin
        if(!rstn)
        begin
            valid = 1'b1;
            data = 32'b0;
        end
        else if(stall | jump_en | jump_en_r | ~valid3)
        begin
            valid = 1'b1;
            data = 32'b0;
        end
        else if(PC_1[3:2] == 2'b00)
        begin
            if(ictag1 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum1;
            end
            else if(ictag2 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum5;
            end
            else 
            begin
                valid = 1'b0;
                data = 32'b0;
            end
        end
        else if(PC_1[3:2] == 2'b01)
        begin
            if(ictag1 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum2;
            end
            else if(ictag2 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum6;
            end
            else 
            begin
                valid = 1'b0;
                data = 32'b0;
            end
        end
        else if(PC_1[3:2] == 2'b10)
        begin
            if(ictag1 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum3;
            end
            else if(ictag2 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum7;
            end
            else
            begin
                valid = 1'b0;
                data = 32'b0;
            end
        end
        else
        begin
            if(ictag1 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum4;
            end
            else if(ictag2 == PC_1[31:12])
            begin
                valid = 1'b1;
                data = icnum8;
            end
            else
            begin
                valid = 1'b0;
                data = 32'b0;
            end
        end
    end


    Imem Imem(
        .addra({PC[18:4],2'b00}),
        .clka(clk),
        .dina(32'b0),//imem不写
        .douta(inst_ma0),
        .ena(1'b1),
        .wea(1'b0),
        .addrb({PC[18:4],2'b01}),
        .clkb(clk),
        .dinb(32'b0),//imem不写
        .doutb(inst_mb0),
        .enb(1'b1),
        .web(1'b0)
    );

    Imem Imem2(
        .addra({PC[18:4],2'b10}),
        .clka(clk),
        .dina(32'b0),//imem不写
        .douta(inst_mc0),
        .ena(1'b1),
        .wea(1'b0),
        .addrb({PC[18:4],2'b11}),
        .clkb(clk),
        .dinb(32'b0),//imem不写
        .doutb(inst_md0),
        .enb(1'b1),
        .web(1'b0)
    );

    always@(*)
    begin
        if(!valid3)
        begin
            // case(PC_4[3:2])
            //     2'b00: begin
            //         wea1 = PC[2];
            //         wea2 = 1'b0;
            //         wea3 = 1'b0;
            //         wea4 = 1'b0;
            //         wea5 = ~PC[2];
            //         wea6 = 1'b0;
            //         wea7 = 1'b0;
            //         wea8 = 1'b0;
            //         wea_tag0 = PC[2];
            //         wea_tag1 = ~PC[2];
            //         index = PC_4[11:4];
            //     end
            //     2'b01: begin
            //         wea1 = 1'b0;
            //         wea2 = PC[2];
            //         wea3 = 1'b0;
            //         wea4 = 1'b0;
            //         wea5 = 1'b0;
            //         wea6 = ~PC[2];
            //         wea7 = 1'b0;
            //         wea8 = 1'b0;
            //         wea_tag0 = PC[2];
            //         wea_tag1 = ~PC[2];
            //         index = PC_4[11:4];
            //     end
            //     2'b10: begin
            //         wea1 = 1'b0;
            //         wea2 = 1'b0;
            //         wea3 = PC[2];
            //         wea4 = 1'b0;
            //         wea5 = 1'b0;
            //         wea6 = 1'b0;
            //         wea7 = ~PC[2];
            //         wea8 = 1'b0;
            //         wea_tag0 = PC[2];
            //         wea_tag1 = ~PC[2];
            //         index = PC_4[11:4];
            //     end
            //     2'b11: begin
            //         wea1 = 1'b0;
            //         wea2 = 1'b0;
            //         wea3 = 1'b0;
            //         wea4 = PC[2];
            //         wea5 = 1'b0;
            //         wea6 = 1'b0;
            //         wea7 = 1'b0;
            //         wea8 = ~PC[2];
            //         wea_tag0 = PC[2];
            //         wea_tag1 = ~PC[2];
            //         index = PC_4[11:4];
            //     end
            // endcase
                    wea1 = PC[2];
                    wea2 = PC[2];
                    wea3 = PC[2];
                    wea4 = PC[2];
                    wea5 = ~PC[2];
                    wea6 = ~PC[2];
                    wea7 = ~PC[2];
                    wea8 = ~PC[2];
                    wea_tag0 = PC[2];
                    wea_tag1 = ~PC[2];
                    index = PC_4[11:4];
        end
        else 
        begin
            wea1 =  1'b0;
            wea2 =  1'b0;
            wea3 =  1'b0;
            wea4 =  1'b0;
            wea5 =  1'b0;
            wea6 =  1'b0;
            wea7 =  1'b0;
            wea8 =  1'b0;
            wea_tag0 = 1'b0;
            wea_tag1 = 1'b0;
            index = PC[11:4];
        end
    end

    always@(posedge clk)
    begin
        inst_ma1 <= inst_ma0;
        inst_ma2 <= inst_ma1;
        inst_ma3 <= inst_ma2;
        inst_mb1 <= inst_mb0;
        inst_mb2 <= inst_mb1;
        inst_mb3 <= inst_mb2;
        inst_mc1 <= inst_mc0;
        inst_mc2 <= inst_mc1;
        inst_mc3 <= inst_mc2;
        inst_md1 <= inst_md0;
        inst_md2 <= inst_md1;
        inst_md3 <= inst_md2;
        valid1 <= valid;
        valid2 <= valid1;
        valid3 <= valid2;
        PC_1 <= PC;
        PC_2 <= PC_1;
        PC_3 <= PC_2;
        PC_4 <= PC_3;
        stall1 <= stall;
    end
endmodule
