module id_ex_reg (
  input        clk,
  input        reset,
  input        flush,
  input  [31:0] id_pc,
  input  [31:0] id_pc_plus4,
  input  [31:0] id_rd_data1,
  input  [31:0] id_rd_data2,
  input  [31:0] id_imm,
  input  [4:0]  id_rs1,
  input  [4:0]  id_rs2,
  input  [4:0]  id_rd,
  input  [3:0]  id_alu_ctrl,
  input         id_reg_write,
  input         id_alu_src,
  input         id_mem_write,
  input         id_mem_to_reg,
  input         id_branch,
  output reg [31:0] ex_pc,
  output reg [31:0] ex_pc_plus4,
  output reg [31:0] ex_rd_data1,
  output reg [31:0] ex_rd_data2,
  output reg [31:0] ex_imm,
  output reg [4:0]  ex_rs1,
  output reg [4:0]  ex_rs2,
  output reg [4:0]  ex_rd,
  output reg [3:0]  ex_alu_ctrl,
  output reg        ex_reg_write,
  output reg        ex_alu_src,
  output reg        ex_mem_write,
  output reg        ex_mem_to_reg,
  output reg        ex_branch
);

  always @(posedge clk) begin
    if (reset || flush) begin
      ex_pc        <= 0; ex_pc_plus4  <= 0;
      ex_rd_data1  <= 0; ex_rd_data2  <= 0;
      ex_imm       <= 0; ex_rs1       <= 0;
      ex_rs2       <= 0; ex_rd        <= 0;
      ex_alu_ctrl  <= 0; ex_reg_write <= 0;
      ex_alu_src   <= 0; ex_mem_write <= 0;
      ex_mem_to_reg<= 0; ex_branch    <= 0;
    end else begin
      ex_pc        <= id_pc;        ex_pc_plus4  <= id_pc_plus4;
      ex_rd_data1  <= id_rd_data1;  ex_rd_data2  <= id_rd_data2;
      ex_imm       <= id_imm;       ex_rs1       <= id_rs1;
      ex_rs2       <= id_rs2;       ex_rd        <= id_rd;
      ex_alu_ctrl  <= id_alu_ctrl;  ex_reg_write <= id_reg_write;
      ex_alu_src   <= id_alu_src;   ex_mem_write <= id_mem_write;
      ex_mem_to_reg<= id_mem_to_reg; ex_branch   <= id_branch;
    end
  end

endmodule