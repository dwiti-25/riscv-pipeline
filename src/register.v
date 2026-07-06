module register_file (
  input        clk,
  input        we,
  input  [4:0] rd_addr1,
  input  [4:0] rd_addr2,
  input  [4:0] wr_addr,
  input  [31:0] wr_data,
  output [31:0] rd_data1,
  output [31:0] rd_data2
);

  reg [31:0] registers [31:0];

  always @(posedge clk) begin
    if (we)
      registers[wr_addr] <= wr_data;
  end

  assign rd_data1 = (rd_addr1 == 5'b0) ? 32'b0 : registers[rd_addr1];
  assign rd_data2 = (rd_addr2 == 5'b0) ? 32'b0 : registers[rd_addr2];

endmodule