`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2018 18:26:36
// Design Name: 
// Module Name: freqdiv
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

module freq_div(input clk,output clkdiv);
    parameter width=19;
    reg[width-1:0] count=0;
    always@(posedge clk)
    begin
        count<=count+1;
    end
    assign clkdiv=count[width-1];            
endmodule
