`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2019 04:02:26 PM
// Design Name: 
// Module Name: vga_ctrl
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

module region
(
    input clk, input clear, input in_dir, input redline_exist, input redline_value,
    input [9:0] b1_x, input [9:0] b1_y,
    input [9:0] b2_x, input [9:0] b2_y,
    input [9:0] b3_x, input [9:0] b3_y,
    output [9:0] redline_x_ball, output [9:0] redline_y_ball, output reg check, output shade_sel
);

    reg [2:0] ns_ball_sel, ps_ball_sel;
    reg [9:0] sel_ball_x, sel_ball_y;

    always@(posedge clk)
    begin
        if(clear == 1)
        begin
            ps_ball_sel<=0;
        end
        else
        begin
            ps_ball_sel<=ns_ball_sel;
        end
    end

    always@(*)
    begin
        case(ps_ball_sel)
            0:  
                begin
                    sel_ball_x = b1_x;
                    sel_ball_y = b1_y;
                end
            1:  
                begin
                    sel_ball_x = b2_x;
                    sel_ball_y = b2_y;
                end
            2:  
                begin
                    sel_ball_x = b3_x;
                    sel_ball_y = b3_y;
                end
        endcase
    end
    
    reg [9:0] ball_dist;
    always@(*)
    begin
        if(in_dir==1)                                           //left or right - somya
            ball_dist = sel_ball_x;
        else
            ball_dist = sel_ball_y;
    end

    wire exist;
    wire [9:0] redline_dist;

    //redline r(.x_ball(sel_ball_x), .y_ball(sel_ball_y), .dir(in_dir), .exist(exist),  .value(redline_dist));
    assign redline_x_ball=sel_ball_x;
    assign redline_y_ball=sel_ball_y;
    assign exist=redline_exist;
    assign redline_dist=redline_value;
    
    reg [2:0] ps,ns;
    reg [1:0] present_shade_sel,next_shade_sel;
    
    always@(posedge clk)
    begin
        if(clear==1)
        begin
            ps <= 0;
            present_shade_sel <= 0;
            check <= 0;
        end
        else
        begin
            ps <= ns;
            present_shade_sel <= next_shade_sel;
        end
    end

    reg area;
//    reg present_shade_sel=0; //Unknown state
//    reg next_shade_sel=0; //Unknown state
    
    always@(*)
    begin
        case(ps)
            0:  
                begin
                    case(exist)
                        0: ns <= 5;
                        1: ns <= 1;
                    endcase
                end
            1:  
                begin
                    area = (redline_dist < ball_dist);
                    case(present_shade_sel)
                        0:  ns <= 2;
                        1:  ns <= 3;
                        2:  ns <= 4;
                        3:  ns <= 6;
                    endcase
                end
            2:  
                begin
                    if(area == 1)
                        next_shade_sel <= 2;
                    else
                        next_shade_sel <= 1;
                    ns <= 5;
                end
            3:  
                begin
                    if(area == 1)
                        next_shade_sel <= 3;
                    else
                        next_shade_sel <= 1;
                    ns <= 5;
                end
            4:  
                begin
                    if(area == 1)
                        next_shade_sel <= 2;
                    else
                        next_shade_sel <= 3;
                    ns <= 5;
                end
            5:  
                begin
                    ns_ball_sel <= ps_ball_sel+1;
                    ns <= 6;
                end
            6:  
                begin
                    if(ps_ball_sel > 4)
                    begin
                        check <= 1;
                        ns <= 6;
                    end
                    else
                    begin
                        if(present_shade_sel == 3)
                        begin
                            check <= 1;
                            ns <= 6;
                        end
                        else
                        begin
                            check <= 0;
                            ns <= 0;
                        end
                    end
                end
        endcase   
    end
    
    assign shade_sel=present_shade_sel;

endmodule