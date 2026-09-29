`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2026 17:20:13
// Design Name: 
// Module Name: instruction_fetch_unit
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

module instruction_fetch_unit(

    input clk,
    input reset,

    input branch_taken,
    input jump,

    input [31:0] branch_addr,
    input [31:0] jump_addr,

    output reg [31:0] pc,
    output [31:0] pc_plus4

);

assign pc_plus4 = pc + 32'd4;

always @(posedge clk) begin

    if(reset)
        pc <= 32'd0;

    else if(jump)
        pc <= jump_addr;

    else if(branch_taken)
        pc <= branch_addr;

    else
        pc <= pc_plus4;

end

endmodule