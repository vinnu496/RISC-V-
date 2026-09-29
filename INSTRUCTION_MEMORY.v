`timescale 1ns / 1ps

module INSTRUCTION_MEMORY(

    input  [31:0] address,
    output [31:0] instruction

);

    // 256 x 32-bit Instruction Memory
    reg [31:0] memory [0:255];

    integer i;

    // Initialize Instruction Memory
    initial begin
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013;   // NOP
    end

    // Read Instruction
    assign instruction = memory[address[9:2]];

endmodule