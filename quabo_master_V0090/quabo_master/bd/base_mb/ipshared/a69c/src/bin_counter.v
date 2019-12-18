`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2018 01:09:51 PM
// Design Name: 
// Module Name: bin_counter
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
module bin_counter(
    input pulse_in,
    input reset,
    input hold,
    input clk,
    output reg [15:0] count_out
    );
    
    always @ (posedge clk) begin
        if (reset) count_out <= 0;
        else if (pulse_in && !hold) count_out <= count_out + 1;
    end
endmodule
