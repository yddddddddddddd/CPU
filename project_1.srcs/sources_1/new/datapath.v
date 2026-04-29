`timescale 1ns / 1ps

module datapath (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire [39:0] uctrl_i,
    input  wire [15:0] mem_rdata_i,

    output wire [7:0]  mem_addr_o,
    output wire [15:0] mem_wdata_o,

    output wire [7:0]  ir_opcode_o,
    output wire        flag_z_o,
    output wire        flag_c_o,
    output wire        flag_n_o,
    output wire        flag_v_o,

    input  wire [2:0]  dbg_sel_i,
    output reg  [15:0] dbg_data_o
);

// 提取微指令控制位
wire        ld_mar      = uctrl_i[21];
wire        sel_mar_pc  = uctrl_i[20];
wire        ld_mbr_mem  = uctrl_i[19];
wire        ld_mbr_acc  = uctrl_i[18];
wire        ld_pc       = uctrl_i[17];
wire        inc_pc      = uctrl_i[16];
wire        ld_ir       = uctrl_i[15];
wire        ld_br       = uctrl_i[14];
wire        ld_acc      = uctrl_i[13];
wire        mem_re      = uctrl_i[12];
wire        mem_we      = uctrl_i[11];
wire [2:0]  bus_sel     = uctrl_i[10:8];
wire        halt        = uctrl_i[7];
wire        alu_en      = uctrl_i[6];
wire [3:0]  alu_op      = uctrl_i[25:22];

// 内部寄存器
wire [7:0]  pc_out, ir_out, mar_out;
wire [15:0] mbr_out, br_out, acc_out, alu_out;

// PC
pc u_pc (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(ld_pc),           // 直接使用微指令的 ld_pc
    .inc_i(inc_pc),
    .clr_i(1'b0),
    .data_i(mbr_out[7:0]),
    .data_o(pc_out)
);

// IR
ir u_ir (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(ld_ir),
    .clr_i(1'b0),
    .data_i(mbr_out[15:8]),
    .data_o(ir_out)
);

// MAR
mar u_mar (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(ld_mar),
    .sel_pc(sel_mar_pc),
    .clr_i(1'b0),
    .pc_i(pc_out),
    .mbr_i(mbr_out[7:0]),
    .data_o(mar_out)
);

// MBR
mbr u_mbr (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_from_mem(ld_mbr_mem),
    .ld_from_acc(ld_mbr_acc),
    .clr_i(1'b0),
    .mem_i(mem_rdata_i),
    .acc_i(acc_out),
    .data_o(mbr_out)
);

// BR
br u_br (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(ld_br),
    .clr_i(1'b0),
    .data_i(alu_out),
    .data_o(br_out)
);

// ACC
acc u_acc (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .ld_i(ld_acc),
    .clr_i(1'b0),
    .data_i(alu_out),
    .data_o(acc_out)
);

// ALU
wire alu_flag_z, alu_flag_c, alu_flag_n, alu_flag_v;

alu u_alu (
    .acc_i(acc_out),
    .mbr_i(mbr_out),
    .alu_op_i(alu_op),
    .alu_en_i(alu_en),
    .y_o(alu_out),
    .flag_z_o(alu_flag_z),
    .flag_c_o(alu_flag_c),
    .flag_n_o(alu_flag_n),
    .flag_v_o(alu_flag_v)
);

// 标志位寄存器（锁存，保持到下一次 ALU 运算）
reg flag_z_reg, flag_c_reg, flag_n_reg, flag_v_reg;

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        flag_z_reg <= 1'b0;
        flag_c_reg <= 1'b0;
        flag_n_reg <= 1'b0;
        flag_v_reg <= 1'b0;
    end
    else if(alu_en) begin
        flag_z_reg <= alu_flag_z;
        flag_c_reg <= alu_flag_c;
        flag_n_reg <= alu_flag_n;
        flag_v_reg <= alu_flag_v;
    end
end

// 输出锁存后的标志位
assign flag_z_o = flag_z_reg;
assign flag_c_o = flag_c_reg;
assign flag_n_o = flag_n_reg;
assign flag_v_o = flag_v_reg;

assign mem_addr_o = mar_out;
assign mem_wdata_o = mbr_out;
assign ir_opcode_o = ir_out;

// 调试输出
always @(*) begin
    case(dbg_sel_i)
        3'b000: dbg_data_o = {8'h00, pc_out};
        3'b001: dbg_data_o = {8'h00, ir_out};
        3'b010: dbg_data_o = {8'h00, mar_out};
        3'b011: dbg_data_o = mbr_out;
        3'b100: dbg_data_o = acc_out;
        3'b101: dbg_data_o = br_out;
        3'b110: dbg_data_o = alu_out;
        default: dbg_data_o = 16'h0000;
    endcase
end

endmodule