`timescale 1ns / 1ps

module micro_sequencer (
    input  wire [7:0]  uaddr_i,
    input  wire [39:0] uctrl_i,
    input  wire [7:0]  ir_opcode_i,
    input  wire        flag_z_i,
    input  wire        flag_c_i,
    input  wire        flag_n_i,
    input  wire        flag_v_i,
    output reg  [7:0]  uaddr_next_o
);

// 提取字段
wire [7:0]  next_addr = uctrl_i[39:32];
wire [2:0]  next_sel  = uctrl_i[31:29];
wire [2:0]  cond_sel  = uctrl_i[28:26];

// 条件判断
wire cond_true;
assign cond_true = (cond_sel == 3'b000) ? 1'b1 :
                   (cond_sel == 3'b001) ? flag_z_i :
                   (cond_sel == 3'b010) ? ~flag_z_i :
                   (cond_sel == 3'b011) ? flag_c_i :
                   (cond_sel == 3'b100) ? flag_n_i :
                   (cond_sel == 3'b101) ? flag_v_i : 1'b0;

always @(*) begin
    case(next_sel)
        3'b000: uaddr_next_o = uaddr_i + 1;           // 顺序执行
        3'b001: uaddr_next_o = 8'h00;                 // 跳转到取指入口
        3'b010: uaddr_next_o = next_addr;             // 跳转到指定地址
        3'b011: begin                                 // 按 IR 操作码跳转
            case(ir_opcode_i[7:4])
                4'h1: uaddr_next_o = 8'h10;
                4'h2: uaddr_next_o = 8'h20;
                4'h3: uaddr_next_o = 8'h30;
                4'h4: uaddr_next_o = 8'h40;
                4'h5: uaddr_next_o = 8'h50;
                4'h6: uaddr_next_o = 8'h60;
                4'h8: uaddr_next_o = 8'h80;
                4'h9: uaddr_next_o = 8'h90;
                4'hA: uaddr_next_o = 8'hA0;
                4'hB: uaddr_next_o = 8'hB0;
                4'hC: uaddr_next_o = 8'hC0;
                4'h0: uaddr_next_o = 8'hF0;  // NOP
                default: uaddr_next_o = 8'h00;
            endcase
        end
        3'b100: begin  // 条件跳转
            if(cond_true) begin
                uaddr_next_o = next_addr;
            end
            else begin
                uaddr_next_o = uaddr_i + 1;
            end
        end
        default: uaddr_next_o = uaddr_i + 1;
    endcase
end

endmodule