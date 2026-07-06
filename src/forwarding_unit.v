module forwarding_unit (
  input  [4:0] ex_rs1,
  input  [4:0] ex_rs2,
  input  [4:0] mem_rd,
  input        mem_reg_write,
  input  [4:0] wb_rd,
  input        wb_reg_write,
  output reg [1:0] fwd_a,
  output reg [1:0] fwd_b
);

  always @(*) begin
    // Forward A
    if (mem_reg_write && mem_rd != 0 && mem_rd == ex_rs1)
      fwd_a = 2'b10;  // forward from EX/MEM
    else if (wb_reg_write && wb_rd != 0 && wb_rd == ex_rs1)
      fwd_a = 2'b01;  // forward from MEM/WB
    else
      fwd_a = 2'b00;  // no forwarding

    // Forward B
    if (mem_reg_write && mem_rd != 0 && mem_rd == ex_rs2)
      fwd_b = 2'b10;
    else if (wb_reg_write && wb_rd != 0 && wb_rd == ex_rs2)
      fwd_b = 2'b01;
    else
      fwd_b = 2'b00;
  end

endmodule