`timescale 1ns / 1ps

module debug_display (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire [15:0] dbg_data_i,
    input  wire [15:0] status_i,
    output wire [15:0] led_o,
    output wire [7:0]  seg_o,
    output wire [7:0]  an_o
);

// LED 输出
assign led_o = {status_i[15:8], dbg_data_i[7:0]};

// 简单的数码管显示（显示 dbg_data_i 的低16位）
seven_seg_driver u_seven_seg (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .data_i(dbg_data_i),
    .seg_o(seg_o),
    .an_o(an_o)
);

endmodule