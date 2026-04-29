`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        cpu_en_i,
    input  wire        run_mode_i,
    input  wire        step_key_i,
    input  wire [7:0]  sw_i,

    output wire [15:0] led_o,
    output wire [7:0]  seg_o,
    output wire [7:0]  an_o,
    output wire        halt_o
);

wire        step_pulse;
wire [7:0]  mem_addr;
wire [15:0] mem_wdata;
wire [15:0] mem_rdata;
wire        mem_we;
wire        mem_re;
wire [15:0] dbg_data;

// 单步脉冲产生
step_pulse u_step_pulse (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .step_key_i(step_key_i),
    .step_pulse_o(step_pulse)
);

// CPU 使能（连续模式或单步脉冲）
wire cpu_en;
assign cpu_en = (run_mode_i == 1'b1) ? cpu_en_i : step_pulse;

// CPU 核心
cpu_core u_cpu_core (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .cpu_en_i(cpu_en),
    .step_i(step_pulse),
    .mem_addr_o(mem_addr),
    .mem_wdata_o(mem_wdata),
    .mem_rdata_i(mem_rdata),
    .mem_we_o(mem_we),
    .mem_re_o(mem_re),
    .dbg_sel_i(sw_i[2:0]),
    .dbg_data_o(dbg_data),
    .halt_o(halt_o)
);

// 主存储器
main_memory u_main_memory (
    .clk_i(clk_i),
    .addr_i(mem_addr),
    .wdata_i(mem_wdata),
    .we_i(mem_we),
    .re_i(mem_re),
    .rdata_o(mem_rdata)
);

// 调试显示
debug_display u_debug_display (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .dbg_data_i(dbg_data),
    .status_i({halt_o, mem_we, mem_re, 13'b0}),
    .led_o(led_o),
    .seg_o(seg_o),
    .an_o(an_o)
);

endmodule