`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2019 12:02:01 PM
// Design Name: 
// Module Name: SPI_access
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
// This module accepts an ARM and a GO input; on the rising edge of GO when ARM is high,
//   the int output is asserted for one cycle
//////////////////////////////////////////////////////////////////////////////////


//module SPI_access(
//    input clk,
//    input arm,
//    input go,
//    output int_out
//    );
//    reg go_d1;
//    always @ (posedge clk) begin
//        go_d1 <= go;
//    end
//    assign int_out = go && !go_d1 && arm;
    
//endmodule

module SPI_access(
    input clk,
    input arm,
    input go,
    output reg int_out
    );
    reg go_d1;
    always @ (posedge clk) begin
        go_d1 <= go;
    end
    
always @(posedge clk)
    begin
     if(go && !go_d1 && arm)
        int_out <= 1;
     else if(arm == 0)
        int_out <= 0;
     else
        int_out <= int_out;
    end
    
endmodule