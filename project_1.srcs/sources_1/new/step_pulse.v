`timescale 1ns / 1ps

module step_pulse (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire        step_key_i,
    output reg         step_pulse_o
);

reg key_ff1, key_ff2;

always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        key_ff1 <= 1'b0;
        key_ff2 <= 1'b0;
        step_pulse_o <= 1'b0;
    end
    else begin
        key_ff1 <= step_key_i;
        key_ff2 <= key_ff1;
        step_pulse_o <= ~key_ff2 & key_ff1;  // ÉÏÉıÑØ¼ì²â
    end
end

endmodule