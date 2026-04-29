`timescale 1ns / 1ps

module mbr (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        ld_from_mem,   // 从内存加载
    input  wire        ld_from_acc,   // 从 ACC 加载
    input  wire        clr_i,
    input  wire [15:0] mem_i,
    input  wire [15:0] acc_i,
    output reg  [15:0] data_o
);

wire [15:0] mbr_in;
assign mbr_in = (ld_from_mem) ? mem_i : 
                (ld_from_acc) ? acc_i : 16'h0000;

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        data_o <= 16'h0000;
    end
    else if(clr_i) begin
        data_o <= 16'h0000;
    end
    else if(ld_from_mem || ld_from_acc) begin
        data_o <= mbr_in;
    end
end

endmodule