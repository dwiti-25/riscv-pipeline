# 5-Stage Pipelined RISC-V RV32I Processor

A fully functional 5-stage pipelined RISC-V processor implemented in Verilog with data forwarding and hazard detection.

## Pipeline Stages
IF → ID → EX → MEM → WB

With pipeline registers between each stage.

## Key Features

- **5-stage pipeline** — Instruction Fetch, Decode, Execute, Memory, Writeback
- **Data forwarding unit** — resolves RAW hazards without stalling
- **Hazard detection unit** — detects load-use hazards
- **Branch handling** — flushes pipeline on taken branches

## Modules

- **if_stage.v** — Instruction fetch, PC management
- **id_stage.v** — Decode + register file read
- **ex_stage.v** — ALU execution with forwarding muxes
- **mem_stage.v** — Data memory access
- **if_id_reg.v, id_ex_reg.v, ex_mem_reg.v, mem_wb_reg.v** — Pipeline registers
- **forwarding_unit.v** — Detects and controls data forwarding
- **hazard_unit.v** — Detects load-use hazards
- **top.v** — Top-level integration

## Supported Instructions

R-type: ADD, SUB, AND, OR, XOR, SLT
I-type: ADDI, LW
S-type: SW

## Simulation
iverilog -o sim.out src/alu.v src/register.v src/dmem.v src/imem.v src/decoder.v src/if_stage.v src/if_id_reg.v src/id_stage.v src/id_ex_reg.v src/ex_stage.v src/ex_mem_reg.v src/mem_stage.v src/mem_wb_reg.v src/forwarding_unit.v src/hazard_unit.v src/top.v tb/tb_top.v
vvp sim.out

## Verified Results

Data hazard test — 3 consecutive dependent instructions:
- x3 = x1 + x2 = 30 ✓
- x4 = x3 + x1 = 40 ✓ (forwarded from EX/MEM)
- x5 = x4 + x3 = 70 ✓ (forwarded from MEM/WB)

Forwarding correctly resolved all RAW hazards without stalling.
