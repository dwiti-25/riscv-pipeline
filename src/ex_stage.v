module ex_stage (
  input  [31:0] pc,
  input  [31:0] rd_data1,
  input  [31:0] rd_data2,
  input  [31:0] imm,
  input  [3:0]  alu_ctrl,
  input         alu_src,
  input         branch,
  input  [1:0]  fwd_a,
  input  [1:0]  fwd_b,
  input  [31:0] ex_mem_result,
  input  [31:0] mem_wb_result,
  output [31:0] alu_result,
  output        zero,
  output        branch_taken,
  output [31:0] branch_target,
  output [31:0] rd_data2_out
);

// Forwarding mux for ALU input A
  wire [31:0] alu_a = (fwd_a == 2'b10) ? ex_mem_result :
                      (fwd_a == 2'b01) ? mem_wb_result :
                      rd_data1;

  // Forwarding mux for ALU input B (before alu_src mux)
  wire [31:0] fwd_b_data = (fwd_b == 2'b10) ? ex_mem_result :
                           (fwd_b == 2'b01) ? mem_wb_result :
                           rd_data2;

  // ALU src mux — use immediate or register
  wire [31:0] alu_b = alu_src ? imm : fwd_b_data;

  // ALU instantiation
  alu alu_inst (
    .a(alu_a),
    .b(alu_b),
    .alu_ctrl(alu_ctrl),
    .result(alu_result),
    .zero(zero)
  );

  // Branch target = PC + (imm << 1)
  assign branch_target = pc + (imm << 1);
  assign branch_taken  = branch && zero;
  assign rd_data2_out  = fwd_b_data;

endmodule