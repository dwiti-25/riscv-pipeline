module mem_stage (
  input        clk,
  input        mem_write,
  input        mem_to_reg,
  input  [31:0] alu_result,
  input  [31:0] rd_data2,
  output [31:0] read_data,
  output [31:0] result
);

  dmem dmem_inst (
    .clk(clk),
    .we(mem_write),
    .addr(alu_result),
    .wr_data(rd_data2),
    .rd_data(read_data)
  );

  assign result = mem_to_reg ? read_data : alu_result;

endmodule
