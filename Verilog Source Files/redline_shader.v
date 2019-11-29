`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2019 12:13:58
// Design Name: 
// Module Name: getsamples
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


module redline_shader
(
    input clk, input [255:0] r_dout,
    output reg we, output reg ready = 1, input start,
    output reg [255:0] w_dout, output [6:0] w_addr, output [6:0] r_addr
);
    
    parameter INIT  =2'b00;
    parameter READ  =2'b01;
    parameter WRITE =2'b10;
    parameter WAIT  =2'b11;

    wire checkend;
    
    assign checkend = (w_addr == 95);
    reg [1:0] ps;
    reg [1:0] ns = 0;




    //parameter INC_ADDR = 3'b100;
    //parameter FINISH = 3'b011;
    //redundant
    //parameter check_player = 3'b101;
   // parameter update_addr = 3'b110;
    
    //reg [2:0]ns_next=0; //ns_next to keep track
    
    // reg start_prev;
    

    //ERROR REASON
   ////////////////////////////////////////
   // wire [6:0] w_addr_copy = w_addr;
   // wire [6:0] r_addr_copy = r_addr;
   ////////////////////////////////////////



    

    
    // always@(posedge clk)
    // begin
    //    start_prev=start;
    // end
    
    // always@(posedge clk)
    // begin
    //    if(start_prev==0 && start==0)
    //        ps=0;
    //    else
    //        ps = ns;
    // end

    always @(posedge clk)
    begin
        ps <= ns;
    end

    // reg [255:0] tdout_reg;
    // wire [255:0] tdout;

    //Sync write addr
    reg [6:0] w_addr_reg=0,w_addr_next;
    always @(posedge clk)    
    begin
        w_addr_reg = w_addr_next;
    end
    assign w_addr = w_addr_reg;    


    //Sync Read Addr
    reg [6:0] r_addr_reg=0,r_addr_next;
    always @(posedge clk)    
    begin
        r_addr_reg = r_addr_next;
    end
    assign r_addr = r_addr_reg;

    //Sync read data
    reg [255:0] r_data_reg=0;
    always @(posedge clk)    
    begin
        r_data_reg = r_dout;//r_dout is incoming data , r_data_reg is synchronised input data
    end


  

    //next state logic
    always@(*)
    begin
        case(ps)
            INIT:
                begin 
                    if(start)
                        begin
                            ns = READ;
                        end
                    else
                        ns = ps;
                end
            
            READ:
                ns = WAIT;
            WAIT:
                ns = WRITE;
            
            WRITE:
                if(checkend==1'b1)
                    begin
                        ns = INIT;
                    end
                else if(checkend == 1'b0)    
                        ns = READ;
        endcase
    end
      //output logic   
    always@(*)
    begin
        case(ps)
            INIT:
                begin 
                    we=0;
                    w_dout=0;   
                    w_addr_next =0;
                    r_addr_next = 0;
                    ready = 1;
                end
            
            READ:
                begin
                    we = 0;
                     r_addr_next=r_addr_reg;
                     ready = 0;
                end
            WAIT:
                we = 1;
            WRITE:
                begin
                    w_dout[127:0] = r_data_reg[127:0] | r_data_reg[255:128];
                    w_dout[255:128] = r_data_reg[127:0] | r_data_reg[255:128];
                    
                    w_addr_next=w_addr_reg+1;
                    r_addr_next=r_data_reg+1;
                    
                    ready=0;
//                    we = 0;
                end
        endcase
    end
endmodule
