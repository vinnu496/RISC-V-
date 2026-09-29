`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 18:12:20
// Design Name: 
// Module Name: control_unit
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

module control_unit(

    input  [6:0] opcode,

    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,
    output reg mem_to_reg,
    output reg branch,
    output reg jump,
    output reg jalr,
    output reg auipc,
    output reg lui,
    output reg [1:0] alu_op

);

always @(*) begin

    // Default values
    reg_write = 1'b0;
    alu_src   = 1'b0;
    mem_read  = 1'b0;
    mem_write = 1'b0;
    mem_to_reg= 1'b0;
    branch    = 1'b0;
    jump      = 1'b0;
    jalr      = 1'b0;
    auipc     = 1'b0;
    lui       = 1'b0;
    alu_op    = 2'b00;

    case(opcode)

        // R-Type
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 2'b10;
        end

        // I-Type (ADDI, ANDI, ORI...)
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b10;
        end

        // Load (LW)
        7'b0000011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            mem_read  = 1'b1;
            mem_to_reg= 1'b1;
            alu_op    = 2'b00;
        end

        // Store (SW)
        7'b0100011: begin
            alu_src   = 1'b1;
            mem_write = 1'b1;
            alu_op    = 2'b00;
        end

        // Branch (BEQ, BNE...)
        7'b1100011: begin
            branch = 1'b1;
            alu_op = 2'b01;
        end

        // JAL
        7'b1101111: begin
            reg_write = 1'b1;
            jump      = 1'b1;
        end

        // LUI
        7'b0110111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            lui       = 1'b1;
        end

        // AUIPC
        7'b0010111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            auipc     = 1'b1;
        end

        // JALR
        7'b1100111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            jump      = 1'b1;
            jalr      = 1'b1;
        end

        default: begin
            // Keep defaults
        end

    endcase

end

endmodule