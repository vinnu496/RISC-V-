`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2026 10:45:31
// Design Name: 
// Module Name: data_memory
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

module data_memory(

    input clk,

    input mem_read,
    input mem_write,

    input [31:0] address,
    input [31:0] write_data,

    output reg [31:0] read_data

);

    // 256 x 32-bit Data Memory
    reg [31:0] memory [0:255];

    integer i;

    // Initialize memory to zero
    initial begin
        for(i = 0; i < 256; i = i + 1)
            memory[i] = 32'd0;
    end

    // Write Operation
    always @(posedge clk) begin
        if(mem_write)
            memory[address[9:2]] <= write_data;
    end

    // Read Operation
    always @(*) begin
        if(mem_read)
            read_data = memory[address[9:2]];
        else
            read_data = 32'd0;
    end

endmodule