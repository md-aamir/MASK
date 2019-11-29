`timescale 1ns / 1ps

module read_converter
(
    input [6:0] r_addr_in, input [0:1023] r_data_in_lsb, input [0:1023] r_data_in_msb ,
    output  reg [255:0] r_data_out=0, output  [9:0] r_addr_out //same for lsb and msb
);

	assign r_addr_out = 8*r_addr_in;

	integer i=0;
	always @(*)
	begin
		for ( i = 0; i < 128; i=i+1)
		begin
		    r_data_out[i] = r_data_in_lsb[i*8];
		    r_data_out[i+128] = r_data_in_msb[i*8];
		end
	end
endmodule