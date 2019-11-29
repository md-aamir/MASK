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


module give_directions          //module to control movement of player according to push buttons
(
    input clk, input up, input down, input left, input right, 
    output reg up_p, output reg down_p, output reg left_p, output reg right_p,
    input istop,output game_over,input in_shaded,input game_stop,
    input game_end
);
    

always @(posedge clk)
begin

    if(istop | game_stop | game_end )               //stop the player when it is out
        begin
            up_p    <= 0;
            down_p  <= 0;
            left_p  <= 0;
            right_p <= 0;
        end

    else if(up & (down_p!=1'b1 ))
        begin                                          //up, player moves up when it was not going down initially
            up_p    <= 1;
            down_p  <= 0;
            left_p  <= 0;
            right_p <= 0;
        end

    else if(down & (up_p!=1'b1 ))
        begin                                        //down, player moves down when it was not going up initially
            up_p    <= 0;
            down_p  <= 1;
            left_p  <= 0;
            right_p <= 0;
        end

    else if(left & (right_p!=1'b1 ))
        begin                                          //left, player moves left when it was not going right initially
            up_p    <= 0;
            down_p  <= 0;
            left_p  <= 1;
            right_p <= 0;
        end

    else if(right & (left_p!=1'b1 ))    
        begin                                          //right, player moves right when it was not going left initially
            up_p    <= 0;
            down_p  <= 0;
            left_p  <= 0;
            right_p <= 1;
        end

    else
        begin                                           //store previous values
            up_p    <= up_p ;
            down_p  <= down_p;
            left_p  <= left_p;
            right_p <= right_p;
        end
end
endmodule
