`timescale 1ns / 1ps

module cpu_core (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        cpu_en_i,
    input  wire        step_i,

    output wire [7:0]  mem_addr_o,
    output wire [15:0] mem_wdata_o,
    input  wire [15:0] mem_rdata_i,
    output wire        mem_we_o,
    output wire        mem_re_o,

    input  wire [2:0]  dbg_sel_i,
    output wire [15:0] dbg_data_o,
    output wire        halt_o
);

wire [39:0] uctrl;
wire [7:0]  ir_opcode;
wire        flag_z, flag_c, flag_n, flag_v;

datapath u_datapath (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .uctrl_i(uctrl),
    .mem_rdata_i(mem_rdata_i),
    .mem_addr_o(mem_addr_o),
    .mem_wdata_o(mem_wdata_o),
    .ir_opcode_o(ir_opcode),
    .flag_z_o(flag_z),
    .flag_c_o(flag_c),
    .flag_n_o(flag_n),
    .flag_v_o(flag_v),
    .dbg_sel_i(dbg_sel_i),
    .dbg_data_o(dbg_data_o)
);

micro_ctrl u_micro_ctrl (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .cpu_en_i(cpu_en_i),
    .step_i(step_i),
    .ir_opcode_i(ir_opcode),
    .flag_z_i(flag_z),
    .flag_c_i(flag_c),
    .flag_n_i(flag_n),
    .flag_v_i(flag_v),
    .uctrl_o(uctrl),
    .halt_o(halt_o),
    .uaddr_dbg_o()
);

assign mem_we_o = uctrl[11];
assign mem_re_o = uctrl[12];

endmodule