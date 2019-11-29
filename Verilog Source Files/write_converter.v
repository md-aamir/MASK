`timescale 1ns / 1ps

module write_converter
(
    input  [255:0] w_data_in, input  [6:0] w_addr_in,
    output reg [0:1023] w_data_out_lsb, output reg [0:1023] w_data_out_msb, output [9:0] w_addr_out
);

	assign w_addr_out = 8*w_addr_in;

	integer i=0;
	always @(*)
	begin
		for ( i = 0; i < 128; i=i+1)
		begin
			w_data_out_lsb[i*8] = w_data_in[i];
		end
		for ( i = 128; i < 256; i=i+1)
		begin
			w_data_out_msb[i*8] = w_data_in[i];
		end
	end
	
endmodule