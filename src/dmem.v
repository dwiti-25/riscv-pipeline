module dmem (
  input        clk,
  input        we,
  input  [31:0] addr,
  input  [31:0] wr_data,
  output [31:0] rd_data
);
reg [31:0] mem [0:255];  // 256 words of memory

  always @(posedge clk) begin
    if (we)
      mem[addr[9:2]] <= wr_data;  // write on clock edge
  end

  assign rd_data = mem[addr[9:2]];  // read anytime

endmodule