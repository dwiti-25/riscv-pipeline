module ex_mem_reg (
  input        clk,
  input        reset,
  input  [31:0] ex_alu_result,
  input  [31:0] ex_rd_data2,
  input  [4:0]  ex_rd,
  input         ex_reg_write,
  input         ex_mem_write,
  input         ex_mem_to_reg,
  output reg [31:0] mem_alu_result,
  output reg [31:0] mem_rd_data2,
  output reg [4:0]  mem_rd,
  output reg        mem_reg_write,
  output reg        mem_mem_write,
  output reg        mem_mem_to_reg
);

  always @(posedge clk) begin
    if (reset) begin
      mem_alu_result <= 0;
      mem_rd_data2   <= 0;
      mem_rd         <= 0;
      mem_reg_write  <= 0;
      mem_mem_write  <= 0;
      mem_mem_to_reg <= 0;
    end else begin
      mem_alu_result <= ex_alu_result;
      mem_rd_data2   <= ex_rd_data2;
      mem_rd         <= ex_rd;
      mem_reg_write  <= ex_reg_write;
      mem_mem_write  <= ex_mem_write;
      mem_mem_to_reg <= ex_mem_to_reg;
    end
  end

endmodule