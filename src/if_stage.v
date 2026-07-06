module if_stage (
  input        clk,
  input        reset,
  input  [31:0] pc_next,
  output [31:0] pc,
  output [31:0] instr,
  output [31:0] pc_plus4
);

reg [31:0] pc_reg = 32'd0;
 always @(posedge clk) begin
    if (reset)
      pc_reg <= 32'd0;
    else
      pc_reg <= pc_next;
  end

  assign pc = pc_reg;
  assign pc_plus4 = pc_reg + 32'd4;

imem imem_inst (
    .addr(pc_reg),
    .instr(instr)
  );

  endmodule
