`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 17:54:42
// Design Name: 
// Module Name: register_file
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

module register_file(

    input clk,
    input reset,
    input reg_write,

    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,

    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2

);

    // 32 Registers (x0 - x31)
    reg [31:0] registers [0:31];

    integer i;

    // Reset and Write Logic
    always @(posedge clk) begin

        if (reset) begin
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end

        else if(reg_write && (rd != 5'd0))
            registers[rd] <= write_data;

    end

    // Read Logic
    assign read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule