`timescale 1ns / 1ps

module mar (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        ld_i,
    input  wire        sel_pc,        // 1=从PC加载, 0=从MBR加载
    input  wire        clr_i,
    input  wire [7:0]  pc_i,
    input  wire [7:0]  mbr_i,
    output reg  [7:0]  data_o
);

wire [7:0] mar_in;
assign mar_in = (sel_pc) ? pc_i : mbr_i;

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        data_o <= 8'h00;
    end
    else if(clr_i) begin
        data_o <= 8'h00;
    end
    else if(ld_i) begin
        data_o <= mar_in;
    end
end

endmodule