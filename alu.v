`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 16:55:35
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module alu(
    input  [31:0] src1,
    input  [31:0] src2,
    input  [5:0]  alu_control,
    output reg [31:0] result
);

always @(*) begin
    case (alu_control)

        // Arithmetic
        6'b000001: result = src1 + src2;                                   // ADD
        6'b000010: result = src1 - src2;                                   // SUB

        // Shift
        6'b000011: result = src1 << src2[4:0];                             // SLL
        6'b000111: result = src1 >> src2[4:0];                             // SRL
        6'b001000: result = $signed(src1) >>> src2[4:0];                   // SRA

        // Comparison
        6'b000100: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0;       // SLT
        6'b000101: result = ($unsigned(src1) < $unsigned(src2)) ? 32'd1 : 32'd0;   // SLTU

        // Logical
        6'b000110: result = src1 ^ src2;                                   // XOR
        6'b001001: result = src1 | src2;                                   // OR
        6'b001010: result = src1 & src2;                                   // AND

        // Branch operations
        6'b001011: result = (src1 == src2) ? 32'd1 : 32'd0;                // BEQ
        6'b001100: result = (src1 != src2) ? 32'd1 : 32'd0;                // BNE
        6'b001101: result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0; // BLT
        6'b001110: result = ($signed(src1) >= $signed(src2)) ? 32'd1 : 32'd0; // BGE
        6'b001111: result = ($unsigned(src1) < $unsigned(src2)) ? 32'd1 : 32'd0; // BLTU
        6'b010000: result = ($unsigned(src1) >= $unsigned(src2)) ? 32'd1 : 32'd0; // BGEU

        default: result = 32'd0;

    endcase
end

endmodule