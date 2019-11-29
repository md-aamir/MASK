`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2019 09:12:59
// Design Name: 
// Module Name: debounce_no_pulse
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


module debounce_no_pulse(input clk, input clear, input inp_pb, output out_pb);

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
assign out_pb = q1 & q2 & q3;

endmodule