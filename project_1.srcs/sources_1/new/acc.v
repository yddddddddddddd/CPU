`timescale 1ns / 1ps

module acc (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        ld_i,
    input  wire        clr_i,
    input  wire [15:0] data_i,
    output reg  [15:0] data_o
);

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        data_o <= 16'h0000;
    end
    else if(clr_i) begin
        data_o <= 16'h0000;
    end
    else if(ld_i) begin
        data_o <= data_i;
    end
end

endmodule