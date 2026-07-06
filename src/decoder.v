module decoder (
  input  [31:0] instr,
  output [4:0]  rd,
  output [4:0]  rs1,
  output [4:0]  rs2,
  output [31:0] imm,
  output [3:0]  alu_ctrl,
  output        reg_write,
  output        alu_src,
  output        mem_write,
  output        mem_to_reg,
  output        branch
);

  assign rd  = instr[11:7];
  assign rs1 = instr[19:15];
  assign rs2 = instr[24:20];
  assign imm = {{20{instr[31]}}, instr[31:20]};

  wire [6:0] opcode   = instr[6:0];
  wire [2:0] funct3   = instr[14:12];
  wire       funct7_5 = instr[30];

  assign alu_ctrl   = (opcode == 7'b0110011 && funct3 == 3'b000 && funct7_5 == 0) ? 4'b0000 : // ADD
                      (opcode == 7'b0110011 && funct3 == 3'b000 && funct7_5 == 1) ? 4'b0001 : // SUB
                      (opcode == 7'b0110011 && funct3 == 3'b111) ? 4'b0010 :                   // AND
                      (opcode == 7'b0110011 && funct3 == 3'b110) ? 4'b0011 :                   // OR
                      (opcode == 7'b0110011 && funct3 == 3'b100) ? 4'b0100 :                   // XOR
                      (opcode == 7'b0010011 && funct3 == 3'b000) ? 4'b0000 :                   // ADDI
                      4'b0000;                                                                   // default ADD

  assign reg_write  = (opcode == 7'b0110011) || (opcode == 7'b0010011) || (opcode == 7'b0000011);
  assign alu_src    = (opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b0100011);
  assign mem_write  = (opcode == 7'b0100011);
  assign mem_to_reg = (opcode == 7'b0000011);
  assign branch     = (opcode == 7'b1100011);

endmodule