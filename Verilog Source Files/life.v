`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2019 21:02:32
// Design Name: 
// Module Name: lives
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


module life                 //module to calculate lives of the player
(
    input game_stop,input clear,
    output reg [1:0] lives=3 , output game_end
);
    
    assign game_end = (lives ==0);         
    parameter LIFE = 3;         //default no. of lives is 3

    always @(posedge game_stop or posedge clear)
    begin
        if(clear)
            begin
                lives=LIFE;
            end
        else if(game_stop & lives !=0)
            begin
                lives = lives-1;
            end
    end

endmodule
