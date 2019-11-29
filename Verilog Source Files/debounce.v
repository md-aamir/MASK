`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2019 02:58:46 PM
// Design Name: 
// Module Name: debounce
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


module debounce(input clk, input clear, input inp_pb, output out_pb);

reg q1, q2, q3;
always @(posedge clk)
begin
    if (clear == 1)
    begin
        q1 <= 0;
        q2 <= 0;
        q3 <= 0;
    end
    else
    begin
        q1 <= inp_pb;
        q2 <= q1;
        q3 <= q2;
    end
end
assign out_pb = q1 & q2 & (~q3);

endmodule
