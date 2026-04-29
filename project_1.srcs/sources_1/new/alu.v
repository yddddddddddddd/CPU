`timescale 1ns / 1ps

module alu (
    input  wire [15:0] acc_i,
    input  wire [15:0] mbr_i,
    input  wire [3:0]  alu_op_i,
    input  wire        alu_en_i,
    output reg  [15:0] y_o,
    output wire        flag_z_o,
    output wire        flag_c_o,
    output wire        flag_n_o,
    output wire        flag_v_o
);

reg [16:0] result_ext;

always @(*) begin
    if(alu_en_i) begin
        case(alu_op_i)
            4'b0000: begin  // LOAD: ֱͨ MBR
                y_o = mbr_i;
                result_ext = {17'b0};
            end
            4'b0001: begin  // ADD
                result_ext = {1'b0, acc_i} + {1'b0, mbr_i};
                y_o = result_ext[15:0];
            end
            4'b0010: begin  // SUB
                result_ext = {1'b0, acc_i} - {1'b0, mbr_i};
                y_o = result_ext[15:0];
            end
            4'b0011: begin  // AND
                y_o = acc_i & mbr_i;
                result_ext = {17'b0};
            end
            4'b0100: begin  // OR
                y_o = acc_i | mbr_i;
                result_ext = {17'b0};
            end
            4'b0101: begin  // XOR
                y_o = acc_i ^ mbr_i;
                result_ext = {17'b0};
            end
            4'b0110: begin  // NOT
                y_o = ~mbr_i;
                result_ext = {17'b0};
            end
            4'b0111: begin  // PASS_ACC
                y_o = acc_i;
                result_ext = {17'b0};
            end
            4'b1000: begin  // CLR
                y_o = 16'h0000;
                result_ext = {17'b0};
            end
            4'b1001: begin  // SHL
                y_o = {mbr_i[14:0], 1'b0};
                result_ext = {17'b0};
            end
            4'b1010: begin  // SHR
                y_o = {1'b0, mbr_i[15:1]};
                result_ext = {17'b0};
            end
            default: begin
                y_o = 16'h0000;
                result_ext = {17'b0};
            end
        endcase
    end
end

assign flag_z_o = (y_o == 16'h0000);
assign flag_n_o = y_o[15];
assign flag_c_o = result_ext[16];
assign flag_v_o = (acc_i[15] == mbr_i[15]) && (y_o[15] != acc_i[15]);

endmodule