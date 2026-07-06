module if_id_reg (
  input        clk,
  input        reset,
  input        flush,
  input  [31:0] if_pc,
  input  [31:0] if_instr,
  input  [31:0] if_pc_plus4,
  output reg [31:0] id_pc,
  output reg [31:0] id_instr,
  output reg [31:0] id_pc_plus4
);

  always @(posedge clk) begin
    if (reset || flush) begin
      id_pc       <= 32'd0;
      id_instr    <= 32'd0;
      id_pc_plus4 <= 32'd0;
    end else begin
      id_pc       <= if_pc;
      id_instr    <= if_instr;
      id_pc_plus4 <= if_pc_plus4;
    end
  end

endmodule