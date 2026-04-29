`timescale 1ns / 1ps

module main_memory (
    input  wire        clk_i,
    input  wire [7:0]  addr_i,
    input  wire [15:0] wdata_i,
    input  wire        we_i,
    input  wire        re_i,
    output reg  [15:0] rdata_o
);

reg [15:0] mem [0:255];
integer i;

initial begin
    for(i = 0; i < 256; i = i + 1) begin
        mem[i] = 16'h0000;
    end
    
    // ========== 多功能乘法程序 ==========
    // 可修改地址32和33的值来改变乘数
    
    // 初始化被乘数和乘数
    mem[0] = 16'h1020;  // LOAD 地址32 (被乘数 A)
    mem[1] = 16'h2022;  // STORE 地址34 (保存 A)
    mem[2] = 16'h1021;  // LOAD 地址33 (乘数 B)
    mem[3] = 16'h2023;  // STORE 地址35 (保存 B)
    mem[4] = 16'h1024;  // LOAD 地址36 (结果初始为0)
    mem[5] = 16'h2024;  // STORE 地址36
    
    // 检查乘数是否为0
    mem[6] = 16'h1023;  // LOAD 地址35 (B)
    mem[7] = 16'h600e;  // JZ 地址14 (B=0 直接输出0)
    
    // 乘法循环
    mem[8] = 16'h1024;  // LOAD 地址36 (result)
    mem[9] = 16'h3022;  // ADD 地址34 (+A)
    mem[10] = 16'h2024; // STORE 地址36
    
    mem[11] = 16'h1023; // LOAD 地址35 (B)
    mem[12] = 16'h3025; // ADD 地址37 (B-1)
    mem[13] = 16'h2023; // STORE 地址35
    mem[14] = 16'h1023; // LOAD 地址35
    mem[15] = 16'h6008; // JZ 地址8 (B=0 结束)
    mem[16] = 16'h5008; // JMP 地址8 (继续循环)
    
    // 输出结果
    mem[17] = 16'h1024; // LOAD 地址36 (result)
    mem[18] = 16'h5000; // JMP 0
    
    // ========== 数据区 ==========
    mem[32] = 16'h0007;  // 被乘数 A (可修改)
    mem[33] = 16'h0005;  // 乘数 B (可修改)
    mem[34] = 16'h0000;  // 临时 A
    mem[35] = 16'h0000;  // 临时 B
    mem[36] = 16'h0000;  // result
    mem[37] = 16'hFFFF;  // -1
end

always @(posedge clk_i) begin
    if(we_i) begin
        mem[addr_i] <= wdata_i;
    end
    if(re_i) begin
        rdata_o <= mem[addr_i];
    end
end

endmodule