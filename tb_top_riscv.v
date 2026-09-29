`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_top_riscv
// Description: Self-checking testbench for the single-cycle RV32I core.
//
// Exercises: addi, add (R-type), sw, lw, beq (taken), bne (taken),
// lui, auipc, jal, jalr.
//
// Loads program.mem straight into the instruction memory array via a
// hierarchical reference, since INSTRUCTION_MEMORY.v now just fills
// itself with NOPs on its own (no built-in $readmemh anymore).
//////////////////////////////////////////////////////////////////////////////////

module tb_top_riscv;

    reg clk;
    reg reset;

    top_riscv uut (
        .clk(clk),
        .reset(reset)
    );

    // ---- Clock: 10ns period ----
    initial clk = 0;
    always #5 clk = ~clk;

    // ---- Load program straight into instruction memory ----
    initial begin
        $readmemh("C:/Users/vigne/RISC V PROCESSOR/RISC V PROCESSOR.srcs/sources_1/new/program.mem", uut.datapath_inst.imem.memory);
    end

    // ---- Per-cycle trace ----
    always @(posedge clk) begin
        if (!reset)
            $display("t=%0t  pc=%08h  instr=%08h", $time,
                      uut.datapath_inst.pc, uut.datapath_inst.instruction);
    end

    // ---- Reset, run, check ----
    integer errors;
    initial begin
        errors = 0;
        reset = 1;
        repeat (2) @(posedge clk);
        reset = 0;

        // 22 instructions, one per cycle in a single-cycle design;
        // run comfortably past that, the program parks in an
        // infinite self-branch at the end so extra cycles are harmless.
        repeat (30) @(posedge clk);

        // ---- Checks ----
        check(1,  32'd5,          "addi x1,x0,5");
        check(2,  32'd10,         "addi x2,x0,10");
        check(3,  32'd15,         "add x3,x1,x2");
        check(4,  32'd15,         "lw x4,20(x0)");
        check(5,  32'd1,          "beq taken -> x5=1 (not 99)");
        check(6,  32'd2,          "bne taken -> x6=2 (not 99)");
        check(9,  32'h12345000,   "lui x9,0x12345");
        check(10, 32'h00001030,   "auipc x10,0x1 at pc=0x30");
        check(7,  32'h00000038,   "jal x7 return addr = 0x38");
        check(8,  32'd3,          "jal landed at 0x3C -> x8=3 (not 99)");
        check(11, 32'h00000048,   "jalr x11 return addr = 0x48");
        check(13, 32'd7,          "jalr landed at 0x50 -> x13=7");
        check(12, 32'd0,          "x12 never written (jalr skipped it)");

        if (errors == 0)
            $display("\n*** ALL CHECKS PASSED ***");
        else
            $display("\n*** %0d CHECK(S) FAILED ***", errors);

        $finish;
    end

    task check(input [4:0] regnum, input [31:0] expected, input [255:0] label);
        reg [31:0] actual;
        begin
            actual = uut.datapath_inst.register_file_inst.registers[regnum];
            if (actual !== expected) begin
                errors = errors + 1;
                $display("FAIL  x%0d = %08h, expected %08h   (%0s)",
                          regnum, actual, expected, label);
            end else begin
                $display("PASS  x%0d = %08h                    (%0s)",
                          regnum, actual, label);
            end
        end
    endtask

endmodule