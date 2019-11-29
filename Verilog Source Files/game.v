`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2019 03:02:39 PM
// Design Name: 
// Module Name: game
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

module game                 //only module with write access to bram, display and writing performed in this module
(   
    input clk_65M, input clear, input [16:0] h_count, input [16:0] v_count, 
    input vid_on, input game_on,
    input [4:1] ball_on, input player_on,input we,
    
    input [0:82] doutb5, output [7:0] rom_lives_addr,
    input [0:191] doutb4, output [7:0] rom_instruction_addr,
    input [0:255] doutb3, output [6:0] rom_intsc_addr,
    input [0:1023] doutb0,input [0:1023] doutb1, 
    output [9 : 0] r_addr0, output [9 : 0] r_addr1,
    output [7:0] addr_gover,input [0:31] dout_gover,

    output reg [9 : 0] w_addr0, output reg [0:1023] w_data0,
    output reg [0:1023] w_data1,output reg [9 : 0] w_addr1,
    output [8:0] brom_count_addr_t,input [0:31] brom_count_data_t,//address and data for count display in tens
    output [8:0] brom_count_addr_o,input [0:31] brom_count_data_o,//address and data for count display in ones
    
    input istop,
    output reg [3:0] vga_red, output reg [3:0] vga_green, output reg [3:0] vga_blue,
    output reg game_win, 
    //output reg [1:0] led,

    input test,
    input [3:0] score_ones,score_tens,
    input game_start,
    
    input [1:0] life, input game_end,output reg [6:0] score
    //from redline
//    input [9:0] w_addr_write_red , 
//    input [0:1023] wdata_lsb_red,
//    input [0:1023] wdata_msb_red
);
            
    parameter HPIXELS = 1344;
    parameter VLINES = 806;
    parameter HBP = 296;//296
    parameter HFP = 1320;//24
    parameter VBP = 35;//35
    parameter VFP = 803;//
    parameter HSP = 136;
    parameter VSP = 6;
    parameter HSCREEN = 1024;
    parameter VSCREEN = 768;
    
    //parameters for screen
    parameter screen_xstart = 256;
    parameter screen_xsize = 256;
    parameter screen_ystart = 256;
    parameter screen_ysize = 128;
    
    //parameters for side screen which includes instructions, lives, score
    parameter side_screen_xstart = 713;
    parameter side_screen_xsize = 311;
    parameter side_screen_ystart = 0;
    parameter side_screen_ysize = 768;
    
    //parameters for instruction
    parameter instruction_xstart = 768;
    parameter instruction_xsize = 192;
    parameter instruction_ystart = 0;
    parameter instruction_ysize = 189;
    
    //parameters for lives star 1
    parameter lives1_xstart = 768;
    parameter lives1_xsize = 83;
    parameter lives1_ystart = 252;
    parameter lives1_ysize = 63;
    
    //parameters for lives star 2
    parameter lives2_xstart = 768;
    parameter lives2_xsize = 83;
    parameter lives2_ystart = 315;
    parameter lives2_ysize = 63;
    
    //parameters for lives star 3
    parameter lives3_xstart = 768;
    parameter lives3_xsize = 83;
    parameter lives3_ystart = 378;
    parameter lives3_ysize = 63;

    //parameters for score count
        //tens
    parameter count_xstart_t = lives2_xstart+100;
    parameter count_ystart_t= lives2_ystart;
        //ones
    parameter count_xstart_o =count_xstart_t+34  ;
    parameter count_ystart_o = lives2_ystart;
    parameter count_size = 31;

  
    parameter MASK_XSIZE = 31;
    parameter MASK_YSIZE = 31;
    //ga display parameters

//parameters for game over
    parameter GA_X_START = 500;
    parameter GA_Y_START = 300;
    
    //me display parameters
    parameter ME_X_START = GA_X_START+32;
    parameter ME_Y_START = GA_Y_START;
    
    //ov display parameters
    parameter OV_X_START = ME_X_START+32;
    parameter OV_Y_START = GA_Y_START+40;
    
    //me display parameters
    parameter ER_X_START = OV_X_START+32;
    parameter ER_Y_START = GA_Y_START+40;
    
    
            
    //assign wea = 0; 
    reg game_stop;
    //assigning screen addresses-A1
    reg [1:0] screen;
    reg  [16 : 0] rom_screen_addr0;
    reg  [16 : 0] rom_screen_addr1;
    wire  [16 : 0] rom_screen_pix ;

    wire  [16 : 0] rom_iscreen_addr;
    wire  [16 : 0] rom_iscreen_pix ;
    
    wire [16:0] x_start,y_start;
    reg [16:0] x_start_reg,y_start_reg,x_start_next,y_start_next;

    assign x_start = x_start_reg;
    assign y_start = y_start_reg;
    
    reg ga_on,me_on,ov_on,er_on;

    //on signal for ov display 
    always @(*)
    begin
        if ((h_count >= OV_X_START+HBP) && (h_count < OV_X_START+MASK_XSIZE+HBP) 
        && (v_count >= OV_Y_START+VBP) && (v_count < OV_Y_START+MASK_YSIZE+VBP))
        begin
            ov_on = 1;
        end
        else
        begin
            ov_on = 0;
        end
    end

    //on signal for ga display
    always @(*)
    begin
        if ((h_count >= GA_X_START+HBP) && (h_count < GA_X_START+MASK_XSIZE+HBP) 
        && (v_count >= GA_Y_START+VBP) && (v_count < GA_Y_START+MASK_YSIZE+VBP))
        begin
            ga_on = 1;
        end
        else
        begin
            ga_on = 0;
        end
    end

    //on signal for me display
    always @(*)
    begin
        if ((h_count >= ME_X_START+HBP) && (h_count < ME_X_START+MASK_XSIZE+HBP) 
        && (v_count >= ME_Y_START+VBP) && (v_count < ME_Y_START+MASK_YSIZE+VBP))
        begin
            me_on = 1;
        end
        else
        begin
            me_on = 0;
        end
    end

    //on signal for er display
    always @(*)
    begin
        if ((h_count >= ER_X_START+HBP) && (h_count < ER_X_START+MASK_XSIZE+HBP) 
        && (v_count >= ER_Y_START+VBP) && (v_count < ER_Y_START+MASK_YSIZE+VBP))
        begin
            er_on = 1;
        end
        else
        begin
            er_on = 0;
        end
    end

    //reg [3:0] factor;
 //display game over   
    always@(posedge clk_65M)
    begin
        x_start_reg<=x_start_next;
    end

    always@(*)
    begin
        if(ga_on==1)
            x_start_next = GA_X_START;
        else if(me_on==1)
            x_start_next = ME_X_START;
        else if(ov_on==1)
            x_start_next = OV_X_START;
        else if(er_on==1)
            x_start_next = ER_X_START;
        else
            x_start_next = x_start_reg;
    end
    
    always@(posedge clk_65M)
    begin
        y_start_reg<=y_start_next;
    end
    
    always@(*)
    begin
        if(ga_on==1)
            y_start_next = GA_Y_START;
        else if(me_on==1)
            y_start_next = ME_Y_START;
        else if(ov_on==1)
            y_start_next = OV_Y_START;
        else if(er_on==1)
            y_start_next = ER_Y_START;
        else
            y_start_next = y_start_reg;
    end
 //

    wire [3:0] factor;
    reg [3:0] factor_reg,factor_next;

    assign factor = factor_reg;
    
    always@(posedge clk_65M)
    begin
        factor_reg<=factor_next;
    end

    always@(*)
    begin
        if(ga_on==1)
            factor_next = 4'd0;
        else if(me_on==1)
            factor_next = 4'd1;
        else if(ov_on==1)
            factor_next = 4'd2;
        else if(er_on==1)
            factor_next = 4'd3;
        else
            factor_next = factor_reg;
    end

    //introduction screen display 
    assign rom_iscreen_addr = v_count[4:0]-VBP[4:0]-y_start;
    assign addr_gover = rom_iscreen_addr[4:0]+32*factor;
    reg ga_screen;
    
    assign rom_iscreen_pix = h_count[4:0]-HBP[4:0]-x_start;
    assign r_addr0 = rom_screen_addr0;
    assign r_addr1 = rom_screen_addr1;
    assign rom_screen_pix = h_count - HBP;
    
    //instruction screen display
    reg intscr;
    wire  [16 : 0] rom_intsc_pix ;
    assign rom_intsc_addr = v_count[6:0] - VBP[6:0];
    assign rom_intsc_pix = h_count[7:0] - HBP[7:0];
    
    reg instruction;
    wire  [16 : 0] rom_instruction_pix ;
    assign rom_instruction_addr = v_count[7:0] - VBP[7:0];
    assign rom_instruction_pix = h_count[7:0] - HBP[7:0];
    
    //lives display
    reg life1, life2, life3;
    wire  [16 : 0] rom_lives_pix ;
    assign rom_lives_addr = v_count[5:0] - VBP[5:0];
    assign rom_lives_pix = h_count[6:0] - HBP[6:0];
    
    reg side_screen_on, instruction_on;
    
    always @(*)
    begin
        if (((h_count >= side_screen_xstart+HBP) && (h_count < side_screen_xstart+side_screen_xsize+HBP)) && ((v_count >= side_screen_ystart+VBP) && (v_count < side_screen_ystart+side_screen_ysize+VBP)))
            side_screen_on = 1;
        else
            side_screen_on = 0;
    end
    
    always @(*)
    begin
        if (((h_count >= instruction_xstart+HBP) && (h_count < instruction_xstart+instruction_xsize+HBP)) && ((v_count >= instruction_ystart+VBP) && (v_count < instruction_ystart+instruction_ysize+VBP)))
            instruction_on = 1;
        else
            instruction_on = 0;
    end

    //screen display
    reg screen_on;
    always @(*)
    begin
        if (((h_count >= screen_xstart+HBP) && (h_count < screen_xstart+screen_xsize+HBP)) && ((v_count >= screen_ystart+VBP) && (v_count < screen_ystart+screen_ysize+VBP)))
            screen_on = 1;
        else
            screen_on = 0;
    end
    
    reg lives_on1, lives_on2, lives_on3;
    always @(*)
    begin
        if (((h_count >= lives1_xstart+HBP) && (h_count < lives1_xstart+lives1_xsize+HBP)) && ((v_count >= lives1_ystart+VBP) && (v_count < lives1_ystart+lives1_ysize+VBP)))
            lives_on1 = (life != 2'd0);
        else
            lives_on1 = 0;
    end
    
    always @(*)
    begin
        if (((h_count >= lives2_xstart+HBP) && (h_count < lives2_xstart+lives2_xsize+HBP)) && ((v_count >= lives2_ystart+VBP) && (v_count < lives2_ystart+lives2_ysize+VBP)))
            lives_on2 = (life > 2'd1);
        else
            lives_on2 = 0;
    end
    
    always @(*)
    begin
        if (((h_count >= lives3_xstart+HBP) && (h_count < lives3_xstart+lives3_xsize+HBP)) && ((v_count >= lives3_ystart+VBP) && (v_count < lives3_ystart+lives3_ysize+VBP)))
            lives_on3 = (life == 2'd3);
        else
            lives_on3 = 0;
    end
    
    //counting display
    reg count_on_o, count_on_t, count_o, count_t;
    wire [16:0] rom_count_addr_o, rom_count_pix_o;
    wire [16:0] rom_count_addr_t, rom_count_pix_t;
    
    //1 digit score display 
    always @(*)
    begin
        if (((h_count >= count_xstart_o+HBP) && (h_count < count_xstart_o+count_size+HBP)) && 
        ((v_count >= count_ystart_o+VBP) && (v_count < count_ystart_o+count_size+VBP)))
            count_on_o = 1;
        else
            count_on_o = 0;
    end
    
    //2nd digit score display 
    always @(*)
    begin
        if (((h_count >= count_xstart_t+HBP) && (h_count < count_xstart_t+count_size+HBP)) && ((v_count >= count_ystart_t+VBP) && (v_count < count_ystart_t+count_size+VBP)))
            count_on_t = 1;
        else
            count_on_t = 0;
    end

    //count xstart and ystart

    
    //ones
    assign rom_count_addr_o = v_count[4:0] - VBP[4:0] - count_ystart_o;
    assign brom_count_addr_o = rom_count_addr_o[4:0] +  score_ones*32;
    assign rom_count_pix_o = h_count[4:0] - HBP[4:0] - count_xstart_o;
    
    //tens
    assign rom_count_addr_t = v_count[4:0] - VBP[4:0] - count_ystart_o;
    assign brom_count_addr_t = rom_count_addr_t[4:0] + score_tens*32;
    assign rom_count_pix_t = h_count[4:0] - HBP[4:0] - count_xstart_t;
    
    
    
    reg [0:1023] temp0;
    reg [0:1023] temp1;
    

    wire write_wall;
    assign write_wall=(h_count>0 && h_count <500 && v_count==10);
//    assign write_wall = 0;

    reg [16:0] v_count_test,h_count_test;  

    //write to bram operations  
    always@(posedge clk_65M)
    begin
        if(game_start & vid_on)                 //remove the red line
            begin
               //fetch     
                rom_screen_addr0= v_count - VBP;
                rom_screen_addr1= v_count - VBP;
                w_addr0 =v_count - VBP;
                w_addr1 =v_count - VBP;
                w_data0 = doutb0;
                w_data1 = doutb0;
            end
                     
        else if(we & ~test)                      // write access to redline draw
            begin
                //fetch
                            
                rom_screen_addr0= v_count - VBP;
                rom_screen_addr1= v_count - VBP;
                //store
                temp1 = doutb1;
                temp0 = doutb0;
                //edit row
                temp0[rom_screen_pix]=0;                  //shade red
                temp1[rom_screen_pix]=1;                  //shade red
                //set write addresses
                w_addr0 =v_count - VBP;
                w_addr1 =v_count - VBP;
                //store
                w_data0 = temp0;
                w_data1 = temp1;
            end
        else if(test & vid_on) // redline to shaded color
            begin
                rom_screen_addr0= v_count - VBP;
                rom_screen_addr1= v_count - VBP;
                w_addr0 =v_count - VBP;
                w_addr1 =v_count - VBP;

                w_data0 = doutb1;
                w_data1 = doutb1;
                
            end
        else if(clear & vid_on)         //set bram to initial state
            begin
                //fetch
                v_count_test = v_count - VBP;
                rom_screen_addr0 = v_count_test;
                rom_screen_addr1 = v_count_test;
                
                if(v_count_test >0 &  v_count_test <32)      
                begin
                    temp0=~(1023'b0);
                    temp1=~(1023'b0);                  
                end
                else if( v_count_test>VSCREEN-32 &  &  v_count_test <VSCREEN)
                    begin
                        temp0=~(1023'b0);
                        temp1=~(1023'b0);                  
                    end
                else
                    begin
                        temp0={~32'd0,651'd0,~341'd0};
                        temp1={~32'd0,651'd0,~341'd0};                  
                    end
                //set write addresses
                w_addr0 =v_count - VBP;
                w_addr1 =v_count - VBP;
                //store
                w_data0 = temp0;
                w_data1 = temp1;
            end
        else
            begin
                //fetch            
                rom_screen_addr0= v_count - VBP;
                rom_screen_addr1= v_count - VBP;
                w_addr0 =v_count - VBP;
                w_addr1 =v_count - VBP;
                w_data0 = doutb0;
                w_data1 = doutb1;
            end                  
    end
    

    //score count    
    reg [20:0] i_countscore_next ,i_countscore_reg;
    wire refr_tick;
    reg [20:0] i_countscore;
    
    always@(posedge clk_65M)
        begin
            if(refr_tick)
                begin
                    i_countscore = i_countscore_reg;
                    score = i_countscore >>12;
                    if(score >= 25)//50% area covered
                        game_win = 1;
                    else
                        game_win = 0; 
                end
        end
        
    always @(posedge clk_65M)
    begin
        i_countscore_reg <= i_countscore_next;
    end

    assign refr_tick = ((h_count == 0) && (v_count == 0));

    //display
    always @(*)
    begin
        vga_red = 4'd0;
        vga_green = 4'd0;
        vga_blue = 4'd0;
        if (vid_on == 1'b1 && game_on == 1'b1 && game_end == 1'b1)          //game over display
        begin
            ga_screen = dout_gover[rom_iscreen_pix]; 
            if (ga_screen==1)
            begin
                
                if(ga_on)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
                else if(me_on)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
                else if(ov_on)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
                else if(er_on)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
           end
        end
        
        else if (vid_on == 1'b1 && game_on == 1'b1 && ball_on[3] == 1'b1)   //ball display
        begin
            vga_red = 4'd15;
            vga_green = 4'd15;
            vga_blue = 4'd15;
        end
        else if (vid_on == 1'b1 && game_on == 1'b1 && ball_on[2] == 1'b1)   //ball display
        begin
            vga_red = 4'd15;
            vga_green = 4'd15;
            vga_blue = 4'd15;
        end
        else if (vid_on == 1'b1 && game_on == 1'b1 && ball_on[1] == 1'b1)   //ball display
        begin
            vga_red = 4'd15;
            vga_green = 4'd15;
            vga_blue = 4'd15;
        end
        else if (vid_on == 1'b1 && game_on == 1'b1 && ball_on[4] == 1'b1)   //boundary ball display
        begin
            vga_red = 4'd0;
            vga_green = 4'd0;
            vga_blue = 4'd0;
        end
        else if (vid_on == 1'b1 && game_on == 1'b1 && player_on == 1'b1)   //player display
        begin
            vga_red = 4'd3;
            vga_green = 4'd15;
            vga_blue = 4'd6;
        end
        else if (vid_on == 1'b1 && game_on == 1'b1 && side_screen_on == 1'b1)   //side screen and its contents
        begin
            if (instruction_on == 1'b1)             //instruction display
            begin
                instruction = doutb4[rom_instruction_pix]; 
                if(instruction)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd0;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
            end
        
            else if (lives_on1)             //lives display 1
            begin
                life1 = doutb5[rom_lives_pix]; 
                if(life1)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd0;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
            end
            else if (lives_on2)             //lives display 2
            begin
                life2 = doutb5[rom_lives_pix]; 
                if(life2)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd0;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
            end
            else if (lives_on3)             //lives display 3
            begin
                life3 = doutb5[rom_lives_pix]; 
                if(life3)
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd0;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
            end
            else if(count_on_o)         //ones digit of score display
            begin
                count_o = brom_count_data_o[rom_count_pix_o];
                if (count_o == 1'b1)
                begin
                    vga_red = 4'd9;
                    vga_green = 4'd3;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd0;
                end
            end
            else if(count_on_t)     //tens digit score display
            begin
                count_t = brom_count_data_t[rom_count_pix_t];
                if (count_t == 1'b1)
                begin
                    vga_red = 4'd9;
                    vga_green = 4'd3;
                    vga_blue = 4'd15;
                end
                else
                begin
                    vga_red = 4'd15;
                    vga_green = 4'd15;
                    vga_blue = 4'd0;
                end

            end
            else
                begin
                    vga_red = 4'd0;
                    vga_green = 4'd0;
                    vga_blue = 4'd0;
                end
        end
        else if ( refr_tick | vid_on == 1 && game_on == 1)                             //background display
        begin

            screen = {doutb1[rom_screen_pix],doutb0[rom_screen_pix]}; 
            if (refr_tick | screen == 2'b11)//shaded                    //score count
            begin           
                vga_red = 4'd0;//violet
                vga_green = 4'd8;
                vga_blue = 4'd8;
                begin
                    if(refr_tick)
                        i_countscore_next = 0;
                    else if(h_count < HSCREEN-320)//shaded
                        i_countscore_next = i_countscore_reg+1;
                      
                end
            end
            else if(screen==2'd00)//unshaded
            begin
                vga_red = 4'd0;     //black
                vga_green = 4'd0;
                vga_blue = 4'd0;
            end
            else if(screen==2'b10)//redline
            begin
                vga_red = 4'd15; //red
                vga_green = 4'd0;
                vga_blue = 4'd0;
                
            end
            else //default color
            begin
                vga_red = 4'd2; //red
                vga_green = 4'd9;
                vga_blue = 4'd13;
                
            end
        end
        else if (vid_on == 1'b1 & screen_on)                                          //introduction screen display
        begin                                                             
            intscr = doutb3[rom_intsc_pix];
            if(intscr)
            begin
                vga_red = 4'd15;
                vga_green = 4'd15;
                vga_blue = 4'd15;
            end
            else
            begin
                vga_red = 4'd0;
                vga_green = 4'd0;
                vga_blue = 4'd0;
            end
        end
        
   end
   
endmodule
