`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 10:50:41
// Design Name: 
// Module Name: alu_control
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
module alu_control(

    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [5:0] alu_control

);

always @(*) begin

    case(alu_op)

        // Load / Store
        2'b00:
            alu_control = 6'b000001;      // ADD

        // Branch - funct3 picks which comparison, ALU does the rest
        2'b01:
        begin
            case(funct3)
                3'b000:  alu_control = 6'b001011;   // BEQ
                3'b001:  alu_control = 6'b001100;   // BNE
                3'b100:  alu_control = 6'b001101;   // BLT
                3'b101:  alu_control = 6'b001110;   // BGE
                3'b110:  alu_control = 6'b001111;   // BLTU
                3'b111:  alu_control = 6'b010000;   // BGEU
                default: alu_control = 6'b001011;
            endcase
        end

        // R-Type / I-Type
        2'b10:
        begin

            case(funct3)

                3'b000:
                    alu_control = (funct7 == 7'b0100000) ?
                                   6'b000010 :   // SUB
                                   6'b000001;    // ADD

                3'b001:
                    alu_control = 6'b000011;      // SLL

                3'b010:
                    alu_control = 6'b000100;      // SLT

                3'b011:
                    alu_control = 6'b000101;      // SLTU

                3'b100:
                    alu_control = 6'b000110;      // XOR

                3'b101:
                    alu_control = (funct7 == 7'b0100000) ?
                                   6'b001000 :   // SRA
                                   6'b000111;    // SRL

                3'b110:
                    alu_control = 6'b001001;      // OR

                3'b111:
                    alu_control = 6'b001010;      // AND

                default:
                    alu_control = 6'b000001;

            endcase

        end

        default:
            alu_control = 6'b000001;

    endcase

end

endmodule