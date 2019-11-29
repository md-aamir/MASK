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

module vga_ctrl(input clk_65M, input clear, output reg h_sync, output reg v_sync, output reg vid_on, output [16:0] h_count, output [16:0] v_count);
    parameter HPIXELS = 1344;
    parameter VLINES = 806;
    parameter HBP = 296;
    parameter HFP = 1320;
    parameter VBP = 35;
    parameter VFP = 803;
    parameter HSP = 136;
    parameter VSP = 6;
    
    reg [16:0] h_count_reg, h_count_next;
    
    //for h_count
    always @(posedge clk_65M)
    begin
        if (clear == 1'b1)
            h_count_reg <= 0;
        else
            h_count_reg <= h_count_next;
    end
    
    always @(*)
    begin
        h_count_next = h_count_reg;
        if (h_count_reg == HPIXELS-1)
            h_count_next <= 12'd0;
        else
            h_count_next <= h_count_reg + 1;
    end
    
    assign h_count = h_count_reg;
    
    //for h_sync
    always @(*)
    begin
        if (h_count_reg < HSP)
            h_sync = 1'b0;
        else
            h_sync = 1'b1;
    end
    
    //for v_count_en which is high if we have completed the scan of one row and moving on to next row
    reg v_count_en;
    always @(*)
    begin
        if (h_count_reg == HPIXELS-1)
            v_count_en <= 1'b1;
        else
            v_count_en <= 1'b0;
    end 
    
    //v_count;
    reg [16:0]v_count_reg, v_count_next;
    always @(posedge clk_65M)
    begin
        if (clear == 1'b1)
            v_count_reg <= 0;
        else
            v_count_reg <= v_count_next;
    end
    
    //for v_count
    always @(*)
    begin
        v_count_next = v_count_reg;
        if (v_count_en == 1'b1)
            if (v_count_reg == VLINES-1)
                v_count_next <= 0;
            else
                v_count_next <= v_count_reg + 1;
    end
    assign v_count = v_count_reg;
    
    //for v_sync
    always @(*)
    begin
        if (v_count_reg < VSP)
            v_sync <= 1'b0;
        else
            v_sync <= 1'b1;
    end
    
    //for vid_on
    always @(*)
    begin
        if ((h_count_reg > HBP) && (h_count_reg < HFP) && (v_count_reg > VBP) && (v_count_reg < VFP))
            vid_on = 1'b1;
        else
            vid_on = 1'b0;
    end 
    
endmodule
