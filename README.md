# Single-Cycle RV32I RISC-V Processor in Verilog

A single-cycle implementation of the RISC-V **RV32I** base integer ISA, written in Verilog and verified with a self-checking testbench in Xilinx Vivado simulation.

![Architecture diagram](docs/architecture.png)
<!-- Add your architecture diagram at docs/architecture.png -->

## Features

- Full single-cycle datapath and control unit (one instruction per clock cycle)
- RV32I base integer instruction set
- Extended support for `JALR`, `AUIPC`, and `LUI`
- Self-checking testbench with automatic PASS/FAIL reporting
- Verified in Xilinx Vivado behavioral simulation

## Supported Instructions

| Type | Instructions |
|------|--------------|
| R-type | `ADD` `SUB` `SLL` `SLT` `SLTU` `XOR` `SRL` `SRA` `OR` `AND` |
| I-type (ALU) | `ADDI` `SLTI` `SLTIU` `XORI` `ORI` `ANDI` `SLLI` `SRLI` `SRAI` |
| Load | `LB` `LH` `LW` `LBU` `LHU` |
| Store | `SB` `SH` `SW` |
| Branch | `BEQ` `BNE` `BLT` `BGE` `BLTU` `BGEU` |
| Jump | `JAL` `JALR` |
| Upper immediate | `LUI` `AUIPC` |

> Edit this table to match exactly what your design implements.

## Architecture

The processor follows the classic single-cycle datapath:

1. **Program Counter (PC)** – holds the address of the current instruction; updated each cycle (PC+4, branch target, or jump target)
2. **Instruction Memory** – fetches the 32-bit instruction at PC
3. **Control Unit** – decodes opcode/funct fields and generates control signals
4. **Register File** – 32 x 32-bit registers, two read ports, one write port (`x0` hardwired to zero)
5. **Immediate Generator** – sign-extends I/S/B/U/J immediates
6. **ALU** – arithmetic, logic, shift, and comparison operations
7. **Data Memory** – load/store access
8. **Write-back Mux** – selects ALU result, memory data, PC+4, or immediate/AUIPC result for the register file

## Repository Structure

```
.
├── src/
│   ├── top.v              # Top-level processor
│   ├── pc.v               # Program counter
│   ├── control_unit.v     # Main decoder / control logic
│   ├── alu.v              # ALU
│   ├── alu_control.v      # ALU operation decoder
│   ├── regfile.v          # Register file
│   ├── imm_gen.v          # Immediate generator
│   ├── instr_mem.v        # Instruction memory
│   └── data_mem.v         # Data memory
├── tb/
│   └── tb_top.v           # Self-checking testbench
├── mem/
│   └── program.mem        # Test program (hex)
├── docs/
│   └── architecture.png   # Datapath diagram
└── README.md
```

> Rename files to match your actual project layout.

## Getting Started

### Prerequisites

- Xilinx Vivado (any recent version; the design uses plain Verilog)

### Run the Simulation

1. Clone the repo:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   ```
2. Open Vivado and create a new RTL project.
3. Add everything in `src/` as design sources and `tb/tb_top.v` as a simulation source.
4. Make sure the program file in `mem/` is loaded by the instruction memory (check the path in `instr_mem.v`).
5. Set `tb_top` as the simulation top and run **Behavioral Simulation**.
6. Check the Tcl console for the PASS/FAIL summary and inspect waveforms as needed.

## Verification

The testbench is self-checking: it runs a test program, compares register/memory state against expected values, and prints a PASS/FAIL result per check plus a final summary. It covers:

- ALU operations and immediates
- Load/store behavior
- Branches (taken and not taken)
- `JAL` / `JALR` link and target handling
- `LUI` and `AUIPC`

## Future Work

- Pipelined version (5-stage) with hazard detection and forwarding
- `M` extension (multiply/divide)
- CSR support and trap handling
- FPGA implementation and on-board demo
- Run the official RISC-V compliance tests

## Author

**Bhaskar**
Feel free to open an issue or reach out with feedback or questions.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
