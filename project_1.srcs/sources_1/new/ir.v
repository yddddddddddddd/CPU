`timescale 1ns / 1ps

module ir (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        ld_i,
    input  wire        clr_i,
    input  wire [7:0]  data_i,
    output reg  [7:0]  data_o
);

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        data_o <= 8'h00;
    end
    else if(clr_i) begin
        data_o <= 8'h00;
    end
    else if(ld_i) begin
        data_o <= data_i;
    end
end

endmodule