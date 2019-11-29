`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kinshu
// 
// Create Date: 13.10.2019 01:58:37
// Design Name: PS2 mouse ctrl
// Module Name: moosze
// Project Name: MASK
// Target Devices: BASYS3
// Tool Versions: vivado 2019.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module moosze( input clk_25, input clr, input sel,
			 inout PS2C, inout PS2D,
			 output reg [7:0] byte3,
			 output reg [8:0] x_data,
			 output reg [8:0] y_data);

	parameter START = 0;
	parameter CLK_LO = 1;
	parameter DAT_LO = 2;
	parameter REL_CLK = 3;
	parameter SEND_BYTE = 4;
	parameter WT_ACK = 5;
	parameter WT_CLK_LO = 6;
	parameter WT_C_D_REL = 7;
	parameter WT_CLK_LO1 = 8;
	parameter WT_CLK_HI1 = 9;
	parameter GET_ACK = 10;
	parameter WT_CLK_LO2 = 11;
	parameter WT_CLK_HI2 = 12;
	parameter GET_M_DATA = 13;

	reg [3:0] state=0;

	reg ps2cf=1,ps2df=1,cen,den,sndflg,xs,ys;
	reg ps2cin,ps2din,ps2cio,ps2dio;
	reg [7:0] ps2c_filter,ps2d_filter;

	reg [8:0] x_mouse_v, y_mouse_v;
	reg [8:0] x_mouse_d, y_mouse_d;
	reg [10:0] shift1,shift2,shift3;
	reg [9:0] f4cmd;
	reg [3:0] bit_count;
	reg [3:0] bit_count1;
	reg [5:0] bit_count3;
	reg [11:0] count;

	parameter [11:0] count_max = 11'h9C4; //2500
	parameter [3:0] bit_count_max = 4'b1010; //10
	parameter [3:0] bit_count1_max = 4'b1100; //12
	parameter [5:0] bit_count3_max = 6'b100001; //33

	always @(*)
	begin
		ps2cio <=  (cen==1)?ps2cin: 'bz;
		ps2dio <=  (den==1)?ps2din: 'bz;
		
	end

	always@(posedge clk_25 or posedge clr)
	begin
		if(clr==1)
		begin
			ps2c_filter<= 8'b00000000;
			ps2d_filter<= 8'b00000000;
			ps2cf<=1;
			ps2df<=1;
		end
		else 
		begin
			ps2c_filter[7]<=ps2cio;
			ps2c_filter[6:0]<=ps2c_filter[7:1];
			ps2d_filter[7]<=ps2dio;
			ps2d_filter[6:0]<=ps2d_filter[7:1];

			if(ps2c_filter==8'hFF)
				ps2cf<=1;
			else if(ps2c_filter==8'h00)
				ps2cf<=0;
			
			if(ps2d_filter==8'hFF)
				ps2df<=1;
			else if(ps2d_filter==8'h00)
				ps2df<=0;
		
		end
	end

	always@(posedge clk_25)
	begin
		if(clr==1)
		begin
			state<=START;
			cen<=0;
			den<=0;
			ps2cin<=0;
			count<=11'b00000000000;
			bit_count1<=4'b0000;
			bit_count3<=4'b0000;
			shift1<= 11'b00000000000;
			shift2<= 11'b00000000000;
			shift3<= 11'b00000000000;
			x_mouse_v<=9'b000000000;
			y_mouse_v<=9'b000000000;
			x_mouse_d<=9'b000000000;
			y_mouse_d<=9'b000000000;
			sndflg<=0;
		end
		else
		begin

			case(state)
				START:
				begin
					cen=1;
					ps2cin=0;
					count=11'b00000000000;
					state=CLK_LO;
				end
				CLK_LO:
				begin
					if (count<count_max)
					begin
						count<=count+1'b1;
						state<=CLK_LO;
					end
					else
					begin
						state<=DAT_LO;
						den<=1'b1;
					end
				end
				DAT_LO:
				begin
					state<=REL_CLK;
					cen<=1'b0;
				end
				REL_CLK:
				begin
					sndflg<=1'b1;
					state<=SEND_BYTE;
				end
				SEND_BYTE:
				begin
					if(bit_count<bit_count_max)
						state<=SEND_BYTE;
					else
					begin
						state<=WT_ACK;
						sndflg<=1'b0;
						den<=1'b0;
					end
				end
				WT_ACK:
				begin
					if(ps2df==1)
						state<=WT_ACK;
					else
						state<=WT_CLK_LO;
				end
				WT_CLK_LO:
				begin
					if(ps2cf==1)
						state<=WT_CLK_LO;
					else
						state<=WT_C_D_REL;
				end
				WT_C_D_REL:
				begin
					if(ps2cf==1 && ps2df==1)
					begin
						state<=WT_CLK_LO1;
						bit_count1<=0;
					end
					else
						state<=WT_C_D_REL;
				end
				WT_CLK_LO1:
				begin
					if(bit_count1<bit_count1_max)
					begin
						if(ps2cf==1)
							state<=WT_CLK_LO1;
						else
						begin
							state<=WT_CLK_HI1;
							shift1<=ps2df&shift1[10:1];
						end
					end
					else
						state<=GET_ACK;
				end
				WT_CLK_HI1:
				begin
					if(ps2cf==0)
						state<=WT_CLK_HI1;
					else
					begin
						state<=WT_CLK_LO1;
						bit_count1<=bit_count1+1;
					end
				end
				GET_ACK:
				begin
					y_mouse_v<=shift1[9:1];
					x_mouse_v<=shift2[8:0];
					byte3<={shift1[10:5],shift1[1:0]};
					state<=WT_CLK_LO2;
					bit_count3<=0;
				end
				WT_CLK_LO2:
				begin
					if(bit_count3<bit_count3_max)
					begin
						if(ps2cf==1)
							state<=WT_CLK_LO2;
						else
						begin
							state<=WT_CLK_HI2;
							shift1<={ps2df,shift1[10:1]};
							shift2<={shift1[0],shift2[10:1]};
							shift3<={shift2[0],shift3[10:1]};
						end
					end
					else
					begin
						x_mouse_v<={shift3[5],shift2[8:1]};
						y_mouse_v<={shift3[6],shift1[8:1]};
						byte3<=shift3[8:1];
						state<=GET_M_DATA;
					end
				end
				WT_CLK_HI2:
				begin
					if(ps2cf==0)
						state<=WT_CLK_HI2;
					else
					begin
						state<=WT_CLK_LO2;
						bit_count3<=bit_count3+1;
					end
				end
				GET_M_DATA:
				begin
					x_mouse_d<=x_mouse_d+x_mouse_v;
					y_mouse_d<=y_mouse_d+y_mouse_v;
					bit_count3<=0;
					state<=WT_CLK_LO2;
				end
			endcase	
		end	
	end

	always @(negedge ps2cf or posedge clr or posedge sndflg)
	begin
		if(clr==1)
		begin
			f4cmd<=10'b1011110100;
			ps2din<=0;
			bit_count<=0;
		end
		else if(ps2cf==0 && sndflg==1)
		begin
			ps2din<=f4cmd[0];
			f4cmd[8:0]<=f4cmd[9:1];
			f4cmd[9]<=0;
			bit_count<=bit_count+1'b1;
		end
	end

	always@(*)
	begin
		if(sel==0)
		begin
			x_data<=x_mouse_v;
			y_data<=y_mouse_v;
		end
		else
		begin
			x_data<=x_mouse_d;
			y_data<=y_mouse_d;
		end
	end

    assign PS2C=ps2cio;
	assign PS2D=ps2dio;
endmodule
