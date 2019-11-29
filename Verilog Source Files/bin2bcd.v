`timescale 1ns / 1ps

module bin2bcd(input [6:0] number, output reg [3:0] tens, output reg [3:0] ones);
   
   // Internal variable for storing bits
   reg [14:0] shift;
   integer i;
   
   always @(number)
   begin
      // Clear previous number and store new number in shift register
      shift[14:7] = 0;
      shift[6:0] = number;
      
      // Loop eight times
      for (i=0; i<7; i=i+1) begin
         if (shift[10:7] >= 5)
            shift[10:7] = shift[10:7] + 3;
            
         if (shift[14:11] >= 5)
            shift[14:11] = shift[14:11] + 3;
            
//         if (shift[18:15] >= 5)
//            shift[18:15] = shift[18:15] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
//      hundreds = shift[18:15];
      tens     = shift[14:11];
      ones     = shift[10:7];
 
      
   end
 
endmodule