module top (
  input clk,
  input reset
);

  wire [31:0] if_pc, if_instr, if_pc_plus4;
  wire [31:0] id_pc, id_instr, id_pc_plus4;
  wire [31:0] id_rd_data1, id_rd_data2, id_imm;
  wire [4:0]  id_rd, id_rs1, id_rs2;
  wire [3:0]  id_alu_ctrl;
  wire        id_reg_write, id_alu_src, id_mem_write, id_mem_to_reg, id_branch;
  wire [31:0] ex_pc, ex_pc_plus4, ex_rd_data1, ex_rd_data2, ex_imm;
  wire [4:0]  ex_rd, ex_rs1, ex_rs2;
  wire [3:0]  ex_alu_ctrl;
  wire        ex_reg_write, ex_alu_src, ex_mem_write, ex_mem_to_reg, ex_branch;
  wire [31:0] ex_alu_result, ex_rd_data2_out, ex_branch_target;
  wire        ex_zero, ex_branch_taken;
  wire [31:0] mem_alu_result, mem_rd_data2;
  wire [4:0]  mem_rd;
  wire        mem_reg_write, mem_mem_write, mem_mem_to_reg;
  wire [31:0] mem_result;
  wire [31:0] wb_result;
  wire [4:0]  wb_rd;
  wire        wb_reg_write;
  wire [1:0]  fwd_a, fwd_b;
  wire        stall;

  wire [31:0] pc_next;
  assign pc_next = ex_branch_taken ? ex_branch_target : if_pc_plus4;

  if_stage if_inst (
    .clk(clk), .reset(reset), .pc_next(pc_next),
    .pc(if_pc), .instr(if_instr), .pc_plus4(if_pc_plus4)
  );

  if_id_reg if_id_inst (
    .clk(clk), .reset(reset), .flush(ex_branch_taken),
    .if_pc(if_pc), .if_instr(if_instr), .if_pc_plus4(if_pc_plus4),
    .id_pc(id_pc), .id_instr(id_instr), .id_pc_plus4(id_pc_plus4)
  );

  id_stage id_inst (
    .clk(clk), .we(wb_reg_write),
    .instr(id_instr), .pc(id_pc), .pc_plus4(id_pc_plus4),
    .wr_addr(wb_rd), .wr_data(wb_result),
    .rd_data1(id_rd_data1), .rd_data2(id_rd_data2),
    .imm(id_imm), .rd(id_rd), .rs1(id_rs1), .rs2(id_rs2),
    .alu_ctrl(id_alu_ctrl), .reg_write(id_reg_write),
    .alu_src(id_alu_src), .mem_write(id_mem_write),
    .mem_to_reg(id_mem_to_reg), .branch(id_branch)
  );

  id_ex_reg id_ex_inst (
    .clk(clk), .reset(reset), .flush(ex_branch_taken),
    .id_pc(id_pc), .id_pc_plus4(id_pc_plus4),
    .id_rd_data1(id_rd_data1), .id_rd_data2(id_rd_data2),
    .id_imm(id_imm), .id_rs1(id_rs1), .id_rs2(id_rs2),
    .id_rd(id_rd), .id_alu_ctrl(id_alu_ctrl),
    .id_reg_write(id_reg_write), .id_alu_src(id_alu_src),
    .id_mem_write(id_mem_write), .id_mem_to_reg(id_mem_to_reg),
    .id_branch(id_branch),
    .ex_pc(ex_pc), .ex_pc_plus4(ex_pc_plus4),
    .ex_rd_data1(ex_rd_data1), .ex_rd_data2(ex_rd_data2),
    .ex_imm(ex_imm), .ex_rs1(ex_rs1), .ex_rs2(ex_rs2),
    .ex_rd(ex_rd), .ex_alu_ctrl(ex_alu_ctrl),
    .ex_reg_write(ex_reg_write), .ex_alu_src(ex_alu_src),
    .ex_mem_write(ex_mem_write), .ex_mem_to_reg(ex_mem_to_reg),
    .ex_branch(ex_branch)
  );

  ex_stage ex_inst (
    .pc(ex_pc), .rd_data1(ex_rd_data1), .rd_data2(ex_rd_data2),
    .imm(ex_imm), .alu_ctrl(ex_alu_ctrl), .alu_src(ex_alu_src),
    .branch(ex_branch), .fwd_a(fwd_a), .fwd_b(fwd_b),
    .ex_mem_result(mem_alu_result), .mem_wb_result(wb_result),
    .alu_result(ex_alu_result), .zero(ex_zero),
    .branch_taken(ex_branch_taken), .branch_target(ex_branch_target),
    .rd_data2_out(ex_rd_data2_out)
  );

  ex_mem_reg ex_mem_inst (
    .clk(clk), .reset(reset),
    .ex_alu_result(ex_alu_result), .ex_rd_data2(ex_rd_data2_out),
    .ex_rd(ex_rd), .ex_reg_write(ex_reg_write),
    .ex_mem_write(ex_mem_write), .ex_mem_to_reg(ex_mem_to_reg),
    .mem_alu_result(mem_alu_result), .mem_rd_data2(mem_rd_data2),
    .mem_rd(mem_rd), .mem_reg_write(mem_reg_write),
    .mem_mem_write(mem_mem_write), .mem_mem_to_reg(mem_mem_to_reg)
  );

  mem_stage mem_inst (
    .clk(clk), .mem_write(mem_mem_write),
    .mem_to_reg(mem_mem_to_reg),
    .alu_result(mem_alu_result), .rd_data2(mem_rd_data2),
    .read_data(), .result(mem_result)
  );

  mem_wb_reg mem_wb_inst (
    .clk(clk), .reset(reset),
    .mem_result(mem_result), .mem_rd(mem_rd),
    .mem_reg_write(mem_reg_write),
    .wb_result(wb_result), .wb_rd(wb_rd),
    .wb_reg_write(wb_reg_write)
  );

  forwarding_unit fwd_inst (
    .ex_rs1(ex_rs1), .ex_rs2(ex_rs2),
    .mem_rd(mem_rd), .mem_reg_write(mem_reg_write),
    .wb_rd(wb_rd), .wb_reg_write(wb_reg_write),
    .fwd_a(fwd_a), .fwd_b(fwd_b)
  );

  hazard_unit haz_inst (
    .id_rs1(id_rs1), .id_rs2(id_rs2),
    .ex_rd(ex_rd), .ex_mem_to_reg(ex_mem_to_reg),
    .stall(stall)
  );

endmodule