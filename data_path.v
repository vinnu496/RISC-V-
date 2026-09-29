`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: data_path
// Description: Single-cycle RV32I datapath - top-level wiring
//
// Covers: R-type, I-type ALU ops, LW, SW, all 6 branches, JAL, JALR,
// AUIPC, LUI.
//
// Still out of scope (rare in a basic single-cycle assignment - check
// your spec before worrying about these): FENCE, ECALL/EBREAK, CSR ops,
// and byte/halfword loads-stores (LB/LH/LBU/LHU/SB/SH - data_memory.v
// is word-only right now).
//////////////////////////////////////////////////////////////////////////////////

module data_path(
    input clk,
    input reset
);

    // ---- Fetch ----
    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instruction;

    // ---- Decode ----
    wire [31:0] immediate;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // ---- Control signals ----
    wire        reg_write;
    wire        alu_src;
    wire        mem_read;
    wire        mem_write;
    wire        mem_to_reg;
    wire        branch;
    wire        jump;
    wire        jalr;
    wire        auipc;
    wire        lui;
    wire [1:0]  alu_op;
    wire [5:0]  alu_control_signal;

    // ---- Execute ----
    wire [31:0] alu_operand2;
    wire [31:0] alu_result;
    wire [31:0] pc_plus_imm;        // pc + immediate, reused by branch/auipc/jal

    // ---- Memory ----
    wire [31:0] memory_data;

    // ---- Writeback (chained low -> high priority) ----
    wire [31:0] mem_or_alu;         // alu_result   vs memory_data
    wire [31:0] lui_stage;          // above        vs immediate      (lui)
    wire [31:0] auipc_stage;        // above        vs pc+immediate   (auipc)
    wire [31:0] write_back_data;    // above        vs pc_plus4       (jal/jalr)

    // ---- Next-PC ----
    wire        branch_taken;
    wire [31:0] branch_addr;
    wire [31:0] jalr_target;
    wire [31:0] jump_addr;


    // ============ 1. Fetch ============

    instruction_fetch_unit ifu (
        .clk(clk),
        .reset(reset),
        .branch_taken(branch_taken),
        .jump(jump),
        .branch_addr(branch_addr),
        .jump_addr(jump_addr),
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    INSTRUCTION_MEMORY imem (
        .address(pc),
        .instruction(instruction)
    );


    // ============ 2. Decode ============

    imm_gen imm_gen_inst (
        .instruction(instruction),
        .immediate(immediate)
    );

    control_unit control_unit_inst (
        .opcode(instruction[6:0]),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .auipc(auipc),
        .lui(lui),
        .alu_op(alu_op)
    );

    register_file register_file_inst (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    alu_control alu_control_inst (
        .alu_op(alu_op),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .alu_control(alu_control_signal)
    );


    // ============ 3. Execute ============

    mux2x1 alu_src_mux (
        .in0(read_data2),      // R-type
        .in1(immediate),       // I-type / loads / stores / jalr / auipc / lui
        .sel(alu_src),
        .out(alu_operand2)
    );

    alu alu_inst (
        .src1(read_data1),
        .src2(alu_operand2),
        .alu_control(alu_control_signal),
        .result(alu_result)
    );

    assign pc_plus_imm = pc + immediate;


    // ============ 4. Memory ============

    data_memory data_memory_inst (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),   // store value always comes from rs2
        .read_data(memory_data)
    );


    // ============ 5. Writeback ============
    // lui/auipc results never went through the ALU meaningfully (rs1
    // isn't a real register field for either), so they're patched in
    // directly here rather than adding an ALU-operand-1 mux.

    mux2x1 mem_to_reg_mux (
        .in0(alu_result),
        .in1(memory_data),
        .sel(mem_to_reg),
        .out(mem_or_alu)
    );

    mux2x1 lui_mux (
        .in0(mem_or_alu),
        .in1(immediate),
        .sel(lui),
        .out(lui_stage)
    );

    mux2x1 auipc_mux (
        .in0(lui_stage),
        .in1(pc_plus_imm),
        .sel(auipc),
        .out(auipc_stage)
    );

    // jal/jalr write pc+4 (the return address), not the ALU result
    mux2x1 jump_wb_mux (
        .in0(auipc_stage),
        .in1(pc_plus4),
        .sel(jump),
        .out(write_back_data)
    );


    // ============ Next-PC resolution ============

    assign branch_taken = branch & (alu_result == 32'd1);
    assign branch_addr  = pc_plus_imm;

    // jalr target is rs1 + imm with bit 0 cleared; jal target is pc + imm
    assign jalr_target  = (read_data1 + immediate) & ~32'd1;
    assign jump_addr     = jalr ? jalr_target : pc_plus_imm;

endmodule
