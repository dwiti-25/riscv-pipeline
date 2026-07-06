module id_stage (
  input        clk,
  input        we,
  input  [31:0] instr,
  input  [31:0] pc,
  input  [31:0] pc_plus4,
  input  [4:0]  wr_addr,
  input  [31:0] wr_data,
  output [31:0] rd_data1,
  output [31:0] rd_data2,
  output [31:0] imm,
  output [4:0]  rd,
  output [4:0]  rs1,
  output [4:0]  rs2,
  output [3:0]  alu_ctrl,
  output        reg_write,
  output        alu_src,
  output        mem_write,
  output        mem_to_reg,
  output        branch
);
// Decoder
  decoder dec_inst (
    .instr(instr),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .alu_ctrl(alu_ctrl),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch)
  );

  // Register File
  register_file rf_inst (
    .clk(clk),
    .we(we),
    .rd_addr1(rs1),
    .rd_addr2(rs2),
    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .rd_data1(rd_data1),
    .rd_data2(rd_data2)
  );

endmodule