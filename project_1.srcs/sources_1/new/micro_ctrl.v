`timescale 1ns / 1ps

module micro_ctrl (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        cpu_en_i,
    input  wire        step_i,
    input  wire [7:0]  ir_opcode_i,
    input  wire        flag_z_i,
    input  wire        flag_c_i,
    input  wire        flag_n_i,
    input  wire        flag_v_i,
    output wire [39:0] uctrl_o,
    output wire        halt_o,
    output wire [7:0]  uaddr_dbg_o
);

wire [7:0]  uaddr_current;
wire [7:0]  uaddr_next;
wire        car_ld;

car_reg u_car_reg (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(car_ld),
    .uaddr_next_i(uaddr_next),
    .uaddr_o(uaddr_current)
);

control_memory u_control_memory (
    .uaddr_i(uaddr_current),
    .uctrl_o(uctrl_o)
);

micro_sequencer u_micro_sequencer (
    .uaddr_i(uaddr_current),
    .uctrl_i(uctrl_o),
    .ir_opcode_i(ir_opcode_i),
    .flag_z_i(flag_z_i),
    .flag_c_i(flag_c_i),
    .flag_n_i(flag_n_i),
    .flag_v_i(flag_v_i),
    .uaddr_next_o(uaddr_next)
);

assign car_ld = cpu_en_i;
assign uaddr_dbg_o = uaddr_current;
assign halt_o = uctrl_o[7];

endmodule