`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2019 12:24:53 PM
// Design Name: 
// Module Name: ball_on_module
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


module ball_on_module            //module for ennemy ball which moves in shaded area
(   input game_end,
    input clk_65M, input clear, input [16:0] h_count, input pause,
    input [16:0] v_count, input game_start, input game_on, input istop,
    input [0:1023] r_data_lsb ,input [0:1023] r_data_msb,
    output reg [9:0] r_addr_lsb, output reg [9:0] r_addr_msb,
    output reg game_over, output reg ball_on,
    output reg game_stop
);
 
    parameter HPIXELS = 1344;
    parameter VLINES = 806;
    parameter HBP = 296;
    parameter HFP = 1320;
    parameter VBP = 35;
    parameter VFP = 803;
    parameter HSP = 136;
    parameter VSP = 6;
    parameter HSCREEN = 1024;
    parameter VSCREEN = 768;
    
    parameter XSTART_POSITION = 200;
    parameter YSTART_POSITION = 200;
    parameter BALL_SIZE = 10;
    parameter BALL_DEFAULT_VELOCITY = 4;
    

    
    reg [0:1023] doutb1_up_lsb, doutb1_up_msb, doutb1_down_lsb, doutb1_down_msb;
    wire [9:0] r_addr1_up_lsb, r_addr1_up_msb, r_addr1_down_lsb, r_addr1_down_msb;
    //reg [1:0] PS,NS;

    //2 read operations from bram are timed
    always @(posedge clk_65M)
    begin
        if(h_count >5 && h_count <10 && v_count==10)
            begin
                r_addr_msb <= r_addr1_up_msb;
                r_addr_lsb <= r_addr1_up_lsb;
            end
        else if(h_count >10 && h_count <15 && v_count==10)
            begin
                doutb1_up_lsb <= r_data_lsb;                        //bram data output at r_addr1_msb 
                doutb1_up_msb <= r_data_msb;                        //bram data output at r_addr1_lsb
            end
        else if(h_count >16 && h_count <20 && v_count==10)
            begin
                r_addr_msb <= r_addr1_down_msb;
                r_addr_lsb <= r_addr1_down_lsb;
            end
        else if(h_count >20 && h_count <25 && v_count==10)
            begin
                doutb1_down_lsb <= r_data_lsb;                      //bram data output at r_addr2_lsb
                doutb1_down_msb <= r_data_msb;                      //bram data output at r_addr2_msb
            end
    end
    
//    reg game_stop;
    wire [16:0] ball_xstart, ball_ystart, ball_xstop, ball_ystop;
    
    //ball_on is one when electron beam is in ball region
    always @(*)
    begin
        if (((h_count >= ball_xstart+HBP) && (h_count < ball_xstop+HBP)) && ((v_count >= ball_ystart+VBP) && (v_count < ball_ystop+VBP)))
            ball_on = 1;
        else
            ball_on = 0;
    end
    
    reg [16:0] ball_xstart_reg, ball_ystart_reg, ball_xstart_next, ball_ystart_next;
    assign ball_xstart = ball_xstart_reg;
    assign ball_xstop = ball_xstart_reg + BALL_SIZE;
    assign ball_ystart = ball_ystart_reg;
    assign ball_ystop = ball_ystart_reg + BALL_SIZE;
    
    assign r_addr1_up_lsb = ball_ystart-2;
    assign r_addr1_up_msb = ball_ystart-2;
    assign r_addr1_down_lsb = ball_ystop+2;
    assign r_addr1_down_msb = ball_ystop+2;
    
    always @(posedge clk_65M)
    begin
        if (clear == 1'b1)
        begin
            ball_xstart_reg <= XSTART_POSITION;
            ball_ystart_reg <= YSTART_POSITION;
        end
        else
        begin
            ball_xstart_reg <= ball_xstart_next;
            ball_ystart_reg <= ball_ystart_next;
        end
    end
    
    wire refr_tick;
    assign refr_tick = ((h_count == 0) && (v_count == 0));
    
    reg [16:0] ball_xstart_delta_reg, ball_ystart_delta_reg;
    reg [16:0] ball_xstart_delta_next, ball_ystart_delta_next;
    
   
    always @(*)
    begin
        ball_xstart_next = ball_xstart_reg;
        if (game_stop | pause | game_end)
            ball_xstart_next = ball_xstart_reg;
        else if (refr_tick == 1)
            ball_xstart_next = ball_xstart_reg + ball_xstart_delta_reg;
    end
    
    always @(*)
    begin
        ball_ystart_next = ball_ystart_reg;
        if (game_stop | pause | game_end)
            ball_ystart_next = ball_ystart_reg;
        else if (refr_tick == 1)
            ball_ystart_next = ball_ystart_reg + ball_ystart_delta_reg;
    end
    
    always @(posedge clk_65M)
    begin
        if (clear == 1)
        begin
            ball_xstart_delta_reg <= 0;
            ball_ystart_delta_reg <= 0;
        end
        else
        begin
            ball_xstart_delta_reg <= ball_xstart_delta_next;
            ball_ystart_delta_reg <= ball_ystart_delta_next;
        end
    end
    
    always @(*)
    begin
        if ((doutb1_up_msb[ball_xstart] & ~doutb1_up_lsb[ball_xstart] & doutb1_down_msb[ball_xstart] & ~doutb1_down_lsb[ball_xstart])
            | (doutb1_up_msb[ball_xstop] & ~doutb1_up_lsb[ball_xstop] & doutb1_down_msb[ball_xstop] & ~doutb1_down_lsb[ball_xstop])
            | (doutb1_up_msb[ball_xstart] & ~doutb1_up_lsb[ball_xstart] & doutb1_up_msb[ball_xstop] & ~doutb1_up_lsb[ball_xstop])
            | (doutb1_down_msb[ball_xstart] & ~doutb1_down_lsb[ball_xstart] & doutb1_down_msb[ball_xstop] & ~doutb1_down_lsb[ball_xstop]))
            
            game_over = 1'b1;
        
        else
        
            game_over = 1'b0; 
    end
    
    reg [16:0] ball_velocity_reg = BALL_DEFAULT_VELOCITY;
    always @(*)
    begin
        ball_xstart_delta_next = ball_xstart_delta_reg;
        if ((doutb1_up_lsb[ball_xstart] & doutb1_down_lsb[ball_xstart] & doutb1_up_msb[ball_xstart] & doutb1_down_msb[ball_xstart]))      //collision check of ball while moving right here
            ball_xstart_delta_next = ball_velocity_reg;                                             //ball go right
        else if ((doutb1_up_lsb[ball_xstop] & doutb1_down_lsb[ball_xstop] & doutb1_up_msb[ball_xstop] & doutb1_down_msb[ball_xstop]))     //collision check of ball while moving right here
            ball_xstart_delta_next = -ball_velocity_reg;                                            //ball go left
        else if (game_stop == 1 || game_start == 1)
            ball_xstart_delta_next = BALL_DEFAULT_VELOCITY;                                         //ball go right for positive default velocity as in this case
        else if (ball_velocity_reg > ball_xstart_delta_reg)
            ball_xstart_delta_next = ball_velocity_reg;                                             //ball go right
    end
    
    always @(*)
    begin
        ball_ystart_delta_next = ball_ystart_delta_reg;
        if ((doutb1_up_lsb[ball_xstart] & doutb1_up_lsb[ball_xstop] & doutb1_up_msb[ball_xstart] & doutb1_up_msb[ball_xstop]))          //collision check of ball while moving up here
            ball_ystart_delta_next = ball_velocity_reg;                             //ball go downward
        else if ((doutb1_down_lsb[ball_xstart] & doutb1_down_lsb[ball_xstop] & doutb1_down_msb[ball_xstart] & doutb1_down_msb[ball_xstop]))         //collision check of ball while moving left here
            ball_ystart_delta_next = -ball_velocity_reg;                            //ball go upward                                  
        else if (game_stop == 1 || game_start == 1)
            ball_ystart_delta_next = BALL_DEFAULT_VELOCITY;
    end
    
    always @(posedge clk_65M)
    begin
        if (clear)
            game_stop = 1;
        else if (game_start)
            game_stop = 0;
        else if (~game_on)
            game_stop = 1;
        else if(istop)
            game_stop = 1;
    end
    
endmodule
