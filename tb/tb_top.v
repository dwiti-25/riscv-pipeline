module tb_top;

  reg clk, reset;

  top uut (.clk(clk), .reset(reset));

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb/tb_top.vcd");
    $dumpvars(0, tb_top);

    reset = 1; #20;
    reset = 0;

    $monitor("t=%0t pc=%0d x3=%0d x4=%0d x5=%0d",
              $time, uut.if_pc,
              uut.id_inst.rf_inst.registers[3],
              uut.id_inst.rf_inst.registers[4],
              uut.id_inst.rf_inst.registers[5]);

    #2000;
    $finish;
  end

endmodule
