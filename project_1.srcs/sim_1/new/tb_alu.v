`timescale 1ns / 1ps

module tb_alu();

reg         clk_i;
reg         rst_n_i;
reg         cpu_en_i;
reg         run_mode_i;
reg         step_key_i;
reg  [7:0]  sw_i;

wire [15:0] led_o;
wire [7:0]  seg_o;
wire [7:0]  an_o;
wire        halt_o;

cpu_top u_cpu_top (
    .clk_i(clk_i),
    .rst_n_i(rst_n_i),
    .cpu_en_i(cpu_en_i),
    .run_mode_i(run_mode_i),
    .step_key_i(step_key_i),
    .sw_i(sw_i),
    .led_o(led_o),
    .seg_o(seg_o),
    .an_o(an_o),
    .halt_o(halt_o)
);

initial begin
    clk_i = 0;
    forever #10 clk_i = ~clk_i;
end

initial begin
    $display("========== CPU 整体测试 ==========");
    
    // 复位
    rst_n_i = 0;
    cpu_en_i = 1;
    run_mode_i = 1;  // 连续模式
    step_key_i = 0;
    sw_i = 3'b000;
    #100;
    rst_n_i = 1;
    #100;
    $display("复位完成，开始执行程序");
    
    // 运行足够长时间
    #500000;
    
    $display("========== 测试完成 ==========");
    $finish;
end

// 监控关键信号
always @(posedge clk_i) begin
    if(u_cpu_top.u_cpu_core.u_datapath.pc_out !== 8'hxx) begin
        $display("PC=%h, IR=%h, ACC=%h", 
                 u_cpu_top.u_cpu_core.u_datapath.pc_out,
                 u_cpu_top.u_cpu_core.u_datapath.ir_out,
                 u_cpu_top.u_cpu_core.u_datapath.acc_out);
    end
end

endmodule