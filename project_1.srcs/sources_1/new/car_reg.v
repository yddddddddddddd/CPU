`timescale 1ns / 1ps

module car_reg (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        ld_i,
    input  wire [7:0]  uaddr_next_i,
    output reg  [7:0]  uaddr_o
);

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        uaddr_o <= 8'h00;
    end
    else if(ld_i) begin
        uaddr_o <= uaddr_next_i;
    end
end

endmodule