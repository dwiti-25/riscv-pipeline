module hazard_unit (
  input  [4:0] id_rs1,
  input  [4:0] id_rs2,
  input  [4:0] ex_rd,
  input        ex_mem_to_reg,
  output reg   stall
);

  always @(*) begin
    if (ex_mem_to_reg && ex_rd != 0 &&
        (ex_rd == id_rs1 || ex_rd == id_rs2))
      stall = 1;
    else
      stall = 0;
  end

endmodule