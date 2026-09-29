//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2026 15:09:23
// Design Name: 
// Module Name: top_riscv
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

module top_riscv(

    input clk,
    input reset

);

    data_path datapath_inst(

        .clk(clk),
        .reset(reset)

    );

endmodule