`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2019 01:18:07 PM
// Design Name: 
// Module Name: shading
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

/*
    00 unshaded
    01 dont know
    10 red line
    11 border
*/
module shading
(
    input clk, input [1:0] shade_sel, input [16:0] h_count, input [16:0] v_count,
    input check, input clear, input [0:799] r_data1, input [0:799] r_data2,
    output [16:0] r_addr1, output [16:0] r_addr2,
    output reg [9:0] w_addr1, output reg [9:0] w_addr2,
    output reg [0:799] w_data1, output reg [0:799] w_data2
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
    
    //S0=border, S1=shade_on, S2=shade_off, S3=done
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
    reg [1:0] ps, ns;
    
    integer i, j;
    wire [10:0] ball_pos;
    reg [0:799] lsb, msb;
    
    wire [16:0] rom_screen_addr, rom_screen_pix;
    assign rom_screen_addr = v_count - VBP;
    assign r_addr1 = rom_screen_addr;
    assign r_addr2 = rom_screen_addr;
    assign rom_screen_pix = h_count - HBP;
     
    //read
    always @(posedge clk)
    begin
        lsb = r_data1;
        msb = r_data2;
    end
    
    //present state
    always @(posedge clk or posedge clear)
    begin
        if (clear)
            ps <= S0;
        else
            ps <= ns;
    end
    
    //next state
    always @(*)
    begin
        case (ps)
            S0: if (shade_sel == 2'd2)                                       //at the border
                    begin
                        if (~(msb[rom_screen_pix] | lsb[rom_screen_pix]))
                            ns <= S0;
                        else if (msb[rom_screen_pix] ^ lsb[rom_screen_pix])                            //either 1 or 2
                            ns <= S1;                                                                      //shade on
                    end
                else if (shade_sel == 2'd1)
                    begin
                        if ((~(msb[rom_screen_pix] | lsb[rom_screen_pix])) | (msb[rom_screen_pix] & ~lsb[rom_screen_pix]))
                            ns <= S1;                                                                     //shade on
                    end
                else if (shade_sel == 2'd3)
                begin
                    if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])
                        ns <= S1;
                end 
            S1: if (shade_sel == 2'd2)                                       
                    begin
                        if (~(msb[rom_screen_pix] | lsb[rom_screen_pix]))
                            ns <= S1;
                        else if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])                            
                            ns <= S2;                                                                   //shade off
                        else if (msb[rom_screen_pix] & lsb[rom_screen_pix])
                            ns <= S3;
                    end
                else if (shade_sel == 2'd1)
                    begin
                        if (~(msb[rom_screen_pix] | lsb[rom_screen_pix]))
                            ns <= S1;                                                                     //shade on
                        else if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])
                            ns <= S2;
                        else if (msb[rom_screen_pix] & lsb[rom_screen_pix])
                            ns <= S3;
                    end
                else if (shade_sel == 2'd3)
                begin
                    if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])
                        ns <= S1;
                end
            S2: if (shade_sel == 2'd2)                                       
                    begin
                        if (~(msb[rom_screen_pix] | lsb[rom_screen_pix]))
                            ns <= S1;
                        else if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])                            
                            ns <= S2;                                                  //shade off
                        else if (msb[rom_screen_pix] & lsb[rom_screen_pix])
                            ns <= S3;
                    end
                else if (shade_sel == 2'd1)
                    begin
                        if (~(msb[rom_screen_pix] | lsb[rom_screen_pix]))
                            ns <= S1;                                                                     //shade on
                        else if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])
                            ns <= S2;
                        else if (msb[rom_screen_pix] & lsb[rom_screen_pix])
                            ns <= S3;
                    end
                else if (shade_sel == 2'd3)
                begin
                    if (msb[rom_screen_pix] & ~lsb[rom_screen_pix])
                        ns <= S1;
                end
        endcase
    end
    
    always @(*)
    begin
//        if (clear)
//        begin
//            w_addr1 <= r_addr1;
//            w_addr2 <= r_addr2;
//            w_data1 <= 800'd0;
//            w_data2 <= 800'd0;
//        end
        if (ps == S3 | ps == S1)
        begin
            lsb[rom_screen_pix] <= 1;
            msb[rom_screen_pix] <= 1;
            w_addr1 <= r_addr1;
            w_addr2 <= r_addr2;
            w_data1 <= lsb;
            w_data2 <= msb;
        end
    end
    
endmodule
