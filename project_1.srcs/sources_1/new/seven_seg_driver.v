`timescale 1ns / 1ps

module seven_seg_driver (
    input  wire        clk_i,
    input  wire        rst_n_i,
    input  wire [15:0] data_i,
    output reg  [7:0]  seg_o,
    output reg  [7:0]  an_o
);

reg [15:0] clk_div;
reg [1:0]  scan_cnt;

// 时钟分频（约1kHz扫描频率）
always @(posedge clk_i or negedge rst_n_i) begin
    if(!rst_n_i) begin
        clk_div <= 16'd0;
        scan_cnt <= 2'd0;
    end
    else begin
        clk_div <= clk_div + 1'b1;
        if(clk_div == 16'd50000) begin
            clk_div <= 16'd0;
            scan_cnt <= scan_cnt + 1'b1;
        end
    end
end

// 数码管段选译码
function [7:0] seg_decode;
    input [3:0] hex;
    begin
        case(hex)
            4'h0: seg_decode = 8'hC0;
            4'h1: seg_decode = 8'hF9;
            4'h2: seg_decode = 8'hA4;
            4'h3: seg_decode = 8'hB0;
            4'h4: seg_decode = 8'h99;
            4'h5: seg_decode = 8'h92;
            4'h6: seg_decode = 8'h82;
            4'h7: seg_decode = 8'hF8;
            4'h8: seg_decode = 8'h80;
            4'h9: seg_decode = 8'h90;
            4'hA: seg_decode = 8'h88;
            4'hB: seg_decode = 8'h83;
            4'hC: seg_decode = 8'hC6;
            4'hD: seg_decode = 8'hA1;
            4'hE: seg_decode = 8'h86;
            4'hF: seg_decode = 8'h8E;
            default: seg_decode = 8'hFF;
        endcase
    end
endfunction

// 位选和段选
always @(*) begin
    case(scan_cnt)
        2'b00: begin
            an_o = 8'b11111110;
            seg_o = seg_decode(data_i[3:0]);
        end
        2'b01: begin
            an_o = 8'b11111101;
            seg_o = seg_decode(data_i[7:4]);
        end
        2'b10: begin
            an_o = 8'b11111011;
            seg_o = seg_decode(data_i[11:8]);
        end
        2'b11: begin
            an_o = 8'b11110111;
            seg_o = seg_decode(data_i[15:12]);
        end
        default: begin
            an_o = 8'b11111111;
            seg_o = 8'hFF;
        end
    endcase
end

endmodule