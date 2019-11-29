`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2019 9:09:23 PM
// Design Name: 
// Module Name: block_ram
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

//read first mode
//800x600 pixel, write/read operation operates on 128 bit data, 96 possible addresses

module bram_Opt             //module for optimizing bram usage, here 256x96 (on board) bram is mapped to 1024x768 size bram (screen size)
(
    input r_clk, input w_clk, input w_en, input r_en, input clear,
    input [9:0] w_addr_lsb, input [9:0] w_addr_msb, input [1023:0] w_data_msb, input [1023:0] w_data_lsb,
    input [9:0] r_addr_lsb, output reg [1023:0] r1_data_lsb,
    input [9:0] r_addr_msb, output reg [1023:0] r1_data_msb
);

//  wire w_clk, r_clk;
    wire [9:0] w_addr_in;
    wire [9:0] r_addr_in;
    
    assign w_addr_in=w_addr_lsb;
    assign r_addr_in=r_addr_lsb; 
    
    reg [6:0] w_addr, r_addr;
    reg [255:0] w_din;
    wire [255:0] r_dout;
    
    
    blk_mem_gen_1 bRAM                  //256x96 bram initialization
    (
        .clka(w_clk),    // input wire clka
        .wea(w_en),      // input wire [0 : 0] wea
        .addra(w_addr),  // input wire [6 : 0] addra
        .dina(w_din),    // input wire [255 : 0] dina
        .clkb(r_clk),    // input wire clkb
        .enb(r_en),      // input wire enb
        .addrb(r_addr),  // input wire [6 : 0] addrb
        .doutb(r_dout)  // output wire [255 : 0] doutb
    );
    
    always@(*) //writing rdata 
    begin
//        r1_data_lsb[] <= {8{r_dout[0-127]}};
        r1_data_lsb[7:0] <= {8{r_dout[0]}};
        r1_data_lsb[15:8] <= {8{r_dout[1]}};
        r1_data_lsb[23:16] <= {8{r_dout[2]}};
        r1_data_lsb[31:24] <= {8{r_dout[3]}};
        r1_data_lsb[39:32] <= {8{r_dout[4]}};
        r1_data_lsb[47:40] <= {8{r_dout[5]}};
        r1_data_lsb[55:48] <= {8{r_dout[6]}};
        r1_data_lsb[63:56] <= {8{r_dout[7]}};
        r1_data_lsb[71:64] <= {8{r_dout[8]}};
        r1_data_lsb[79:72] <= {8{r_dout[9]}};
        r1_data_lsb[87:80] <= {8{r_dout[10]}};
        r1_data_lsb[95:88] <= {8{r_dout[11]}};
        r1_data_lsb[103:96] <= {8{r_dout[12]}};
        r1_data_lsb[111:104] <= {8{r_dout[13]}};
        r1_data_lsb[119:112] <= {8{r_dout[14]}};
        r1_data_lsb[127:120] <= {8{r_dout[15]}};
        r1_data_lsb[135:128] <= {8{r_dout[16]}};
        r1_data_lsb[143:136] <= {8{r_dout[17]}};
        r1_data_lsb[151:144] <= {8{r_dout[18]}};
        r1_data_lsb[159:152] <= {8{r_dout[19]}};
        r1_data_lsb[167:160] <= {8{r_dout[20]}};
        r1_data_lsb[175:168] <= {8{r_dout[21]}};
        r1_data_lsb[183:176] <= {8{r_dout[22]}};
        r1_data_lsb[191:184] <= {8{r_dout[23]}};
        r1_data_lsb[199:192] <= {8{r_dout[24]}};
        r1_data_lsb[207:200] <= {8{r_dout[25]}};
        r1_data_lsb[215:208] <= {8{r_dout[26]}};
        r1_data_lsb[223:216] <= {8{r_dout[27]}};
        r1_data_lsb[231:224] <= {8{r_dout[28]}};
        r1_data_lsb[239:232] <= {8{r_dout[29]}};
        r1_data_lsb[247:240] <= {8{r_dout[30]}};
        r1_data_lsb[255:248] <= {8{r_dout[31]}};
        r1_data_lsb[263:256] <= {8{r_dout[32]}};
        r1_data_lsb[271:264] <= {8{r_dout[33]}};
        r1_data_lsb[279:272] <= {8{r_dout[34]}};
        r1_data_lsb[287:280] <= {8{r_dout[35]}};
        r1_data_lsb[295:288] <= {8{r_dout[36]}};
        r1_data_lsb[303:296] <= {8{r_dout[37]}};
        r1_data_lsb[311:304] <= {8{r_dout[38]}};
        r1_data_lsb[319:312] <= {8{r_dout[39]}};
        r1_data_lsb[327:320] <= {8{r_dout[40]}};
        r1_data_lsb[335:328] <= {8{r_dout[41]}};
        r1_data_lsb[343:336] <= {8{r_dout[42]}};
        r1_data_lsb[351:344] <= {8{r_dout[43]}};
        r1_data_lsb[359:352] <= {8{r_dout[44]}};
        r1_data_lsb[367:360] <= {8{r_dout[45]}};
        r1_data_lsb[375:368] <= {8{r_dout[46]}};
        r1_data_lsb[383:376] <= {8{r_dout[47]}};
        r1_data_lsb[391:384] <= {8{r_dout[48]}};
        r1_data_lsb[399:392] <= {8{r_dout[49]}};
        r1_data_lsb[407:400] <= {8{r_dout[50]}};
        r1_data_lsb[415:408] <= {8{r_dout[51]}};
        r1_data_lsb[423:416] <= {8{r_dout[52]}};
        r1_data_lsb[431:424] <= {8{r_dout[53]}};
        r1_data_lsb[439:432] <= {8{r_dout[54]}};
        r1_data_lsb[447:440] <= {8{r_dout[55]}};
        r1_data_lsb[455:448] <= {8{r_dout[56]}};
        r1_data_lsb[463:456] <= {8{r_dout[57]}};
        r1_data_lsb[471:464] <= {8{r_dout[58]}};
        r1_data_lsb[479:472] <= {8{r_dout[59]}};
        r1_data_lsb[487:480] <= {8{r_dout[60]}};
        r1_data_lsb[495:488] <= {8{r_dout[61]}};
        r1_data_lsb[503:496] <= {8{r_dout[62]}};
        r1_data_lsb[511:504] <= {8{r_dout[63]}};
        r1_data_lsb[519:512] <= {8{r_dout[64]}};
        r1_data_lsb[527:520] <= {8{r_dout[65]}};
        r1_data_lsb[535:528] <= {8{r_dout[66]}};
        r1_data_lsb[543:536] <= {8{r_dout[67]}};
        r1_data_lsb[551:544] <= {8{r_dout[68]}};
        r1_data_lsb[559:552] <= {8{r_dout[69]}};
        r1_data_lsb[567:560] <= {8{r_dout[70]}};
        r1_data_lsb[575:568] <= {8{r_dout[71]}};
        r1_data_lsb[583:576] <= {8{r_dout[72]}};
        r1_data_lsb[591:584] <= {8{r_dout[73]}};
        r1_data_lsb[599:592] <= {8{r_dout[74]}};
        r1_data_lsb[607:600] <= {8{r_dout[75]}};
        r1_data_lsb[615:608] <= {8{r_dout[76]}};
        r1_data_lsb[623:616] <= {8{r_dout[77]}};
        r1_data_lsb[631:624] <= {8{r_dout[78]}};
        r1_data_lsb[639:632] <= {8{r_dout[79]}};
        r1_data_lsb[647:640] <= {8{r_dout[80]}};
        r1_data_lsb[655:648] <= {8{r_dout[81]}};
        r1_data_lsb[663:656] <= {8{r_dout[82]}};
        r1_data_lsb[671:664] <= {8{r_dout[83]}};
        r1_data_lsb[679:672] <= {8{r_dout[84]}};
        r1_data_lsb[687:680] <= {8{r_dout[85]}};
        r1_data_lsb[695:688] <= {8{r_dout[86]}};
        r1_data_lsb[703:696] <= {8{r_dout[87]}};
        r1_data_lsb[711:704] <= {8{r_dout[88]}};
        r1_data_lsb[719:712] <= {8{r_dout[89]}};
        r1_data_lsb[727:720] <= {8{r_dout[90]}};
        r1_data_lsb[735:728] <= {8{r_dout[91]}};
        r1_data_lsb[743:736] <= {8{r_dout[92]}};
        r1_data_lsb[751:744] <= {8{r_dout[93]}};
        r1_data_lsb[759:752] <= {8{r_dout[94]}};
        r1_data_lsb[767:760] <= {8{r_dout[95]}};
        r1_data_lsb[775:768] <= {8{r_dout[96]}};
        r1_data_lsb[783:776] <= {8{r_dout[97]}};
        r1_data_lsb[791:784] <= {8{r_dout[98]}};
        r1_data_lsb[799:792] <= {8{r_dout[99]}};
        r1_data_lsb[807:800] <= {8{r_dout[100]}};
        r1_data_lsb[815:808] <= {8{r_dout[101]}};
        r1_data_lsb[823:816] <= {8{r_dout[102]}};
        r1_data_lsb[831:824] <= {8{r_dout[103]}};
        r1_data_lsb[839:832] <= {8{r_dout[104]}};
        r1_data_lsb[847:840] <= {8{r_dout[105]}};
        r1_data_lsb[855:848] <= {8{r_dout[106]}};
        r1_data_lsb[863:856] <= {8{r_dout[107]}};
        r1_data_lsb[871:864] <= {8{r_dout[108]}};
        r1_data_lsb[879:872] <= {8{r_dout[109]}};
        r1_data_lsb[887:880] <= {8{r_dout[110]}};
        r1_data_lsb[895:888] <= {8{r_dout[111]}};
        r1_data_lsb[903:896] <= {8{r_dout[112]}};
        r1_data_lsb[911:904] <= {8{r_dout[113]}};
        r1_data_lsb[919:912] <= {8{r_dout[114]}};
        r1_data_lsb[927:920] <= {8{r_dout[115]}};
        r1_data_lsb[935:928] <= {8{r_dout[116]}};
        r1_data_lsb[943:936] <= {8{r_dout[117]}};
        r1_data_lsb[951:944] <= {8{r_dout[118]}};
        r1_data_lsb[959:952] <= {8{r_dout[119]}};
        r1_data_lsb[967:960] <= {8{r_dout[120]}};
        r1_data_lsb[975:968] <= {8{r_dout[121]}};
        r1_data_lsb[983:976] <= {8{r_dout[122]}};
        r1_data_lsb[991:984] <= {8{r_dout[123]}};
        r1_data_lsb[999:992] <= {8{r_dout[124]}};
        r1_data_lsb[1007:1000] <= {8{r_dout[125]}};
        r1_data_lsb[1015:1008] <= {8{r_dout[126]}};
        r1_data_lsb[1023:1016] <= {8{r_dout[127]}};

        r1_data_msb[7:0] <= {8{r_dout[128]}};
        r1_data_msb[15:8] <= {8{r_dout[129]}};
        r1_data_msb[23:16] <= {8{r_dout[130]}};
        r1_data_msb[31:24] <= {8{r_dout[131]}};
        r1_data_msb[39:32] <= {8{r_dout[132]}};
        r1_data_msb[47:40] <= {8{r_dout[133]}};
        r1_data_msb[55:48] <= {8{r_dout[134]}};
        r1_data_msb[63:56] <= {8{r_dout[135]}};
        r1_data_msb[71:64] <= {8{r_dout[136]}};
        r1_data_msb[79:72] <= {8{r_dout[137]}};
        r1_data_msb[87:80] <= {8{r_dout[138]}};
        r1_data_msb[95:88] <= {8{r_dout[139]}};
        r1_data_msb[103:96] <= {8{r_dout[140]}};
        r1_data_msb[111:104] <= {8{r_dout[141]}};
        r1_data_msb[119:112] <= {8{r_dout[142]}};
        r1_data_msb[127:120] <= {8{r_dout[143]}};
        r1_data_msb[135:128] <= {8{r_dout[144]}};
        r1_data_msb[143:136] <= {8{r_dout[145]}};
        r1_data_msb[151:144] <= {8{r_dout[146]}};
        r1_data_msb[159:152] <= {8{r_dout[147]}};
        r1_data_msb[167:160] <= {8{r_dout[148]}};
        r1_data_msb[175:168] <= {8{r_dout[149]}};
        r1_data_msb[183:176] <= {8{r_dout[150]}};
        r1_data_msb[191:184] <= {8{r_dout[151]}};
        r1_data_msb[199:192] <= {8{r_dout[152]}};
        r1_data_msb[207:200] <= {8{r_dout[153]}};
        r1_data_msb[215:208] <= {8{r_dout[154]}};
        r1_data_msb[223:216] <= {8{r_dout[155]}};
        r1_data_msb[231:224] <= {8{r_dout[156]}};
        r1_data_msb[239:232] <= {8{r_dout[157]}};
        r1_data_msb[247:240] <= {8{r_dout[158]}};
        r1_data_msb[255:248] <= {8{r_dout[159]}};
        r1_data_msb[263:256] <= {8{r_dout[160]}};
        r1_data_msb[271:264] <= {8{r_dout[161]}};
        r1_data_msb[279:272] <= {8{r_dout[162]}};
        r1_data_msb[287:280] <= {8{r_dout[163]}};
        r1_data_msb[295:288] <= {8{r_dout[164]}};
        r1_data_msb[303:296] <= {8{r_dout[165]}};
        r1_data_msb[311:304] <= {8{r_dout[166]}};
        r1_data_msb[319:312] <= {8{r_dout[167]}};
        r1_data_msb[327:320] <= {8{r_dout[168]}};
        r1_data_msb[335:328] <= {8{r_dout[169]}};
        r1_data_msb[343:336] <= {8{r_dout[170]}};
        r1_data_msb[351:344] <= {8{r_dout[171]}};
        r1_data_msb[359:352] <= {8{r_dout[172]}};
        r1_data_msb[367:360] <= {8{r_dout[173]}};
        r1_data_msb[375:368] <= {8{r_dout[174]}};
        r1_data_msb[383:376] <= {8{r_dout[175]}};
        r1_data_msb[391:384] <= {8{r_dout[176]}};
        r1_data_msb[399:392] <= {8{r_dout[177]}};
        r1_data_msb[407:400] <= {8{r_dout[178]}};
        r1_data_msb[415:408] <= {8{r_dout[179]}};
        r1_data_msb[423:416] <= {8{r_dout[180]}};
        r1_data_msb[431:424] <= {8{r_dout[181]}};
        r1_data_msb[439:432] <= {8{r_dout[182]}};
        r1_data_msb[447:440] <= {8{r_dout[183]}};
        r1_data_msb[455:448] <= {8{r_dout[184]}};
        r1_data_msb[463:456] <= {8{r_dout[185]}};
        r1_data_msb[471:464] <= {8{r_dout[186]}};
        r1_data_msb[479:472] <= {8{r_dout[187]}};
        r1_data_msb[487:480] <= {8{r_dout[188]}};
        r1_data_msb[495:488] <= {8{r_dout[189]}};
        r1_data_msb[503:496] <= {8{r_dout[190]}};
        r1_data_msb[511:504] <= {8{r_dout[191]}};
        r1_data_msb[519:512] <= {8{r_dout[192]}};
        r1_data_msb[527:520] <= {8{r_dout[193]}};
        r1_data_msb[535:528] <= {8{r_dout[194]}};
        r1_data_msb[543:536] <= {8{r_dout[195]}};
        r1_data_msb[551:544] <= {8{r_dout[196]}};
        r1_data_msb[559:552] <= {8{r_dout[197]}};
        r1_data_msb[567:560] <= {8{r_dout[198]}};
        r1_data_msb[575:568] <= {8{r_dout[199]}};
        r1_data_msb[583:576] <= {8{r_dout[200]}};
        r1_data_msb[591:584] <= {8{r_dout[201]}};
        r1_data_msb[599:592] <= {8{r_dout[202]}};
        r1_data_msb[607:600] <= {8{r_dout[203]}};
        r1_data_msb[615:608] <= {8{r_dout[204]}};
        r1_data_msb[623:616] <= {8{r_dout[205]}};
        r1_data_msb[631:624] <= {8{r_dout[206]}};
        r1_data_msb[639:632] <= {8{r_dout[207]}};
        r1_data_msb[647:640] <= {8{r_dout[208]}};
        r1_data_msb[655:648] <= {8{r_dout[209]}};
        r1_data_msb[663:656] <= {8{r_dout[210]}};
        r1_data_msb[671:664] <= {8{r_dout[211]}};
        r1_data_msb[679:672] <= {8{r_dout[212]}};
        r1_data_msb[687:680] <= {8{r_dout[213]}};
        r1_data_msb[695:688] <= {8{r_dout[214]}};
        r1_data_msb[703:696] <= {8{r_dout[215]}};
        r1_data_msb[711:704] <= {8{r_dout[216]}};
        r1_data_msb[719:712] <= {8{r_dout[217]}};
        r1_data_msb[727:720] <= {8{r_dout[218]}};
        r1_data_msb[735:728] <= {8{r_dout[219]}};
        r1_data_msb[743:736] <= {8{r_dout[220]}};
        r1_data_msb[751:744] <= {8{r_dout[221]}};
        r1_data_msb[759:752] <= {8{r_dout[222]}};
        r1_data_msb[767:760] <= {8{r_dout[223]}};
        r1_data_msb[775:768] <= {8{r_dout[224]}};
        r1_data_msb[783:776] <= {8{r_dout[225]}};
        r1_data_msb[791:784] <= {8{r_dout[226]}};
        r1_data_msb[799:792] <= {8{r_dout[227]}};
        r1_data_msb[807:800] <= {8{r_dout[228]}};
        r1_data_msb[815:808] <= {8{r_dout[229]}};
        r1_data_msb[823:816] <= {8{r_dout[230]}};
        r1_data_msb[831:824] <= {8{r_dout[231]}};
        r1_data_msb[839:832] <= {8{r_dout[232]}};
        r1_data_msb[847:840] <= {8{r_dout[233]}};
        r1_data_msb[855:848] <= {8{r_dout[234]}};
        r1_data_msb[863:856] <= {8{r_dout[235]}};
        r1_data_msb[871:864] <= {8{r_dout[236]}};
        r1_data_msb[879:872] <= {8{r_dout[237]}};
        r1_data_msb[887:880] <= {8{r_dout[238]}};
        r1_data_msb[895:888] <= {8{r_dout[239]}};
        r1_data_msb[903:896] <= {8{r_dout[240]}};
        r1_data_msb[911:904] <= {8{r_dout[241]}};
        r1_data_msb[919:912] <= {8{r_dout[242]}};
        r1_data_msb[927:920] <= {8{r_dout[243]}};
        r1_data_msb[935:928] <= {8{r_dout[244]}};
        r1_data_msb[943:936] <= {8{r_dout[245]}};
        r1_data_msb[951:944] <= {8{r_dout[246]}};
        r1_data_msb[959:952] <= {8{r_dout[247]}};
        r1_data_msb[967:960] <= {8{r_dout[248]}};
        r1_data_msb[975:968] <= {8{r_dout[249]}};
        r1_data_msb[983:976] <= {8{r_dout[250]}};
        r1_data_msb[991:984] <= {8{r_dout[251]}};
        r1_data_msb[999:992] <= {8{r_dout[252]}};
        r1_data_msb[1007:1000] <= {8{r_dout[253]}};
        r1_data_msb[1015:1008] <= {8{r_dout[254]}};
        r1_data_msb[1023:1016] <= {8{r_dout[255]}};
    end
    
    always@(*)
    begin
        w_addr <= w_addr_in/8;
        r_addr <= r_addr_in/8;
    end
    
    always@(*) //writing wdin 
    begin
        w_din[0] = |w_data_lsb[7:0];
        w_din[1] = |w_data_lsb[15:8];
        w_din[2] = |w_data_lsb[23:16];
        w_din[3] = |w_data_lsb[31:24];
        w_din[4] = |w_data_lsb[39:32];
        w_din[5] = |w_data_lsb[47:40];
        w_din[6] = |w_data_lsb[55:48];
        w_din[7] = |w_data_lsb[63:56];
        w_din[8] = |w_data_lsb[71:64];
        w_din[9] = |w_data_lsb[79:72];
        w_din[10] = |w_data_lsb[87:80];
        w_din[11] = |w_data_lsb[95:88];
        w_din[12] = |w_data_lsb[103:96];
        w_din[13] = |w_data_lsb[111:104];
        w_din[14] = |w_data_lsb[119:112];
        w_din[15] = |w_data_lsb[127:120];
        w_din[16] = |w_data_lsb[135:128];
        w_din[17] = |w_data_lsb[143:136];
        w_din[18] = |w_data_lsb[151:144];
        w_din[19] = |w_data_lsb[159:152];
        w_din[20] = |w_data_lsb[167:160];
        w_din[21] = |w_data_lsb[175:168];
        w_din[22] = |w_data_lsb[183:176];
        w_din[23] = |w_data_lsb[191:184];
        w_din[24] = |w_data_lsb[199:192];
        w_din[25] = |w_data_lsb[207:200];
        w_din[26] = |w_data_lsb[215:208];
        w_din[27] = |w_data_lsb[223:216];
        w_din[28] = |w_data_lsb[231:224];
        w_din[29] = |w_data_lsb[239:232];
        w_din[30] = |w_data_lsb[247:240];
        w_din[31] = |w_data_lsb[255:248];
        w_din[32] = |w_data_lsb[263:256];
        w_din[33] = |w_data_lsb[271:264];
        w_din[34] = |w_data_lsb[279:272];
        w_din[35] = |w_data_lsb[287:280];
        w_din[36] = |w_data_lsb[295:288];
        w_din[37] = |w_data_lsb[303:296];
        w_din[38] = |w_data_lsb[311:304];
        w_din[39] = |w_data_lsb[319:312];
        w_din[40] = |w_data_lsb[327:320];
        w_din[41] = |w_data_lsb[335:328];
        w_din[42] = |w_data_lsb[343:336];
        w_din[43] = |w_data_lsb[351:344];
        w_din[44] = |w_data_lsb[359:352];
        w_din[45] = |w_data_lsb[367:360];
        w_din[46] = |w_data_lsb[375:368];
        w_din[47] = |w_data_lsb[383:376];
        w_din[48] = |w_data_lsb[391:384];
        w_din[49] = |w_data_lsb[399:392];
        w_din[50] = |w_data_lsb[407:400];
        w_din[51] = |w_data_lsb[415:408];
        w_din[52] = |w_data_lsb[423:416];
        w_din[53] = |w_data_lsb[431:424];
        w_din[54] = |w_data_lsb[439:432];
        w_din[55] = |w_data_lsb[447:440];
        w_din[56] = |w_data_lsb[455:448];
        w_din[57] = |w_data_lsb[463:456];
        w_din[58] = |w_data_lsb[471:464];
        w_din[59] = |w_data_lsb[479:472];
        w_din[60] = |w_data_lsb[487:480];
        w_din[61] = |w_data_lsb[495:488];
        w_din[62] = |w_data_lsb[503:496];
        w_din[63] = |w_data_lsb[511:504];
        w_din[64] = |w_data_lsb[519:512];
        w_din[65] = |w_data_lsb[527:520];
        w_din[66] = |w_data_lsb[535:528];
        w_din[67] = |w_data_lsb[543:536];
        w_din[68] = |w_data_lsb[551:544];
        w_din[69] = |w_data_lsb[559:552];
        w_din[70] = |w_data_lsb[567:560];
        w_din[71] = |w_data_lsb[575:568];
        w_din[72] = |w_data_lsb[583:576];
        w_din[73] = |w_data_lsb[591:584];
        w_din[74] = |w_data_lsb[599:592];
        w_din[75] = |w_data_lsb[607:600];
        w_din[76] = |w_data_lsb[615:608];
        w_din[77] = |w_data_lsb[623:616];
        w_din[78] = |w_data_lsb[631:624];
        w_din[79] = |w_data_lsb[639:632];
        w_din[80] = |w_data_lsb[647:640];
        w_din[81] = |w_data_lsb[655:648];
        w_din[82] = |w_data_lsb[663:656];
        w_din[83] = |w_data_lsb[671:664];
        w_din[84] = |w_data_lsb[679:672];
        w_din[85] = |w_data_lsb[687:680];
        w_din[86] = |w_data_lsb[695:688];
        w_din[87] = |w_data_lsb[703:696];
        w_din[88] = |w_data_lsb[711:704];
        w_din[89] = |w_data_lsb[719:712];
        w_din[90] = |w_data_lsb[727:720];
        w_din[91] = |w_data_lsb[735:728];
        w_din[92] = |w_data_lsb[743:736];
        w_din[93] = |w_data_lsb[751:744];
        w_din[94] = |w_data_lsb[759:752];
        w_din[95] = |w_data_lsb[767:760];
        w_din[96] = |w_data_lsb[775:768];
        w_din[97] = |w_data_lsb[783:776];
        w_din[98] = |w_data_lsb[791:784];
        w_din[99] = |w_data_lsb[799:792];
        w_din[100] = |w_data_lsb[807:800];
        w_din[101] = |w_data_lsb[815:808];
        w_din[102] = |w_data_lsb[823:816];
        w_din[103] = |w_data_lsb[831:824];
        w_din[104] = |w_data_lsb[839:832];
        w_din[105] = |w_data_lsb[847:840];
        w_din[106] = |w_data_lsb[855:848];
        w_din[107] = |w_data_lsb[863:856];
        w_din[108] = |w_data_lsb[871:864];
        w_din[109] = |w_data_lsb[879:872];
        w_din[110] = |w_data_lsb[887:880];
        w_din[111] = |w_data_lsb[895:888];
        w_din[112] = |w_data_lsb[903:896];
        w_din[113] = |w_data_lsb[911:904];
        w_din[114] = |w_data_lsb[919:912];
        w_din[115] = |w_data_lsb[927:920];
        w_din[116] = |w_data_lsb[935:928];
        w_din[117] = |w_data_lsb[943:936];
        w_din[118] = |w_data_lsb[951:944];
        w_din[119] = |w_data_lsb[959:952];
        w_din[120] = |w_data_lsb[967:960];
        w_din[121] = |w_data_lsb[975:968];
        w_din[122] = |w_data_lsb[983:976];
        w_din[123] = |w_data_lsb[991:984];
        w_din[124] = |w_data_lsb[999:992];
        w_din[125] = |w_data_lsb[1007:1000];
        w_din[126] = |w_data_lsb[1015:1008];
        w_din[127] = |w_data_lsb[1023:1016];
        
                
                
        //        w_din[128] <= w_data_msb[i*8];  
        w_din[128] = |w_data_msb[7:0];
        w_din[129] = |w_data_msb[15:8];
        w_din[130] = |w_data_msb[23:16];
        w_din[131] = |w_data_msb[31:24];
        w_din[132] = |w_data_msb[39:32];
        w_din[133] = |w_data_msb[47:40];
        w_din[134] = |w_data_msb[55:48];
        w_din[135] = |w_data_msb[63:56];
        w_din[136] = |w_data_msb[71:64];
        w_din[137] = |w_data_msb[79:72];
        w_din[138] = |w_data_msb[87:80];
        w_din[139] = |w_data_msb[95:88];
        w_din[140] = |w_data_msb[103:96];
        w_din[141] = |w_data_msb[111:104];
        w_din[142] = |w_data_msb[119:112];
        w_din[143] = |w_data_msb[127:120];
        w_din[144] = |w_data_msb[135:128];
        w_din[145] = |w_data_msb[143:136];
        w_din[146] = |w_data_msb[151:144];
        w_din[147] = |w_data_msb[159:152];
        w_din[148] = |w_data_msb[167:160];
        w_din[149] = |w_data_msb[175:168];
        w_din[150] = |w_data_msb[183:176];
        w_din[151] = |w_data_msb[191:184];
        w_din[152] = |w_data_msb[199:192];
        w_din[153] = |w_data_msb[207:200];
        w_din[154] = |w_data_msb[215:208];
        w_din[155] = |w_data_msb[223:216];
        w_din[156] = |w_data_msb[231:224];
        w_din[157] = |w_data_msb[239:232];
        w_din[158] = |w_data_msb[247:240];
        w_din[159] = |w_data_msb[255:248];
        w_din[160] = |w_data_msb[263:256];
        w_din[161] = |w_data_msb[271:264];
        w_din[162] = |w_data_msb[279:272];
        w_din[163] = |w_data_msb[287:280];
        w_din[164] = |w_data_msb[295:288];
        w_din[165] = |w_data_msb[303:296];
        w_din[166] = |w_data_msb[311:304];
        w_din[167] = |w_data_msb[319:312];
        w_din[168] = |w_data_msb[327:320];
        w_din[169] = |w_data_msb[335:328];
        w_din[170] = |w_data_msb[343:336];
        w_din[171] = |w_data_msb[351:344];
        w_din[172] = |w_data_msb[359:352];
        w_din[173] = |w_data_msb[367:360];
        w_din[174] = |w_data_msb[375:368];
        w_din[175] = |w_data_msb[383:376];
        w_din[176] = |w_data_msb[391:384];
        w_din[177] = |w_data_msb[399:392];
        w_din[178] = |w_data_msb[407:400];
        w_din[179] = |w_data_msb[415:408];
        w_din[180] = |w_data_msb[423:416];
        w_din[181] = |w_data_msb[431:424];
        w_din[182] = |w_data_msb[439:432];
        w_din[183] = |w_data_msb[447:440];
        w_din[184] = |w_data_msb[455:448];
        w_din[185] = |w_data_msb[463:456];
        w_din[186] = |w_data_msb[471:464];
        w_din[187] = |w_data_msb[479:472];
        w_din[188] = |w_data_msb[487:480];
        w_din[189] = |w_data_msb[495:488];
        w_din[190] = |w_data_msb[503:496];
        w_din[191] = |w_data_msb[511:504];
        w_din[192] = |w_data_msb[519:512];
        w_din[193] = |w_data_msb[527:520];
        w_din[194] = |w_data_msb[535:528];
        w_din[195] = |w_data_msb[543:536];
        w_din[196] = |w_data_msb[551:544];
        w_din[197] = |w_data_msb[559:552];
        w_din[198] = |w_data_msb[567:560];
        w_din[199] = |w_data_msb[575:568];
        w_din[200] = |w_data_msb[583:576];
        w_din[201] = |w_data_msb[591:584];
        w_din[202] = |w_data_msb[599:592];
        w_din[203] = |w_data_msb[607:600];
        w_din[204] = |w_data_msb[615:608];
        w_din[205] = |w_data_msb[623:616];
        w_din[206] = |w_data_msb[631:624];
        w_din[207] = |w_data_msb[639:632];
        w_din[208] = |w_data_msb[647:640];
        w_din[209] = |w_data_msb[655:648];
        w_din[210] = |w_data_msb[663:656];
        w_din[211] = |w_data_msb[671:664];
        w_din[212] = |w_data_msb[679:672];
        w_din[213] = |w_data_msb[687:680];
        w_din[214] = |w_data_msb[695:688];
        w_din[215] = |w_data_msb[703:696];
        w_din[216] = |w_data_msb[711:704];
        w_din[217] = |w_data_msb[719:712];
        w_din[218] = |w_data_msb[727:720];
        w_din[219] = |w_data_msb[735:728];
        w_din[220] = |w_data_msb[743:736];
        w_din[221] = |w_data_msb[751:744];
        w_din[222] = |w_data_msb[759:752];
        w_din[223] = |w_data_msb[767:760];
        w_din[224] = |w_data_msb[775:768];
        w_din[225] = |w_data_msb[783:776];
        w_din[226] = |w_data_msb[791:784];
        w_din[227] = |w_data_msb[799:792];
        w_din[228] = |w_data_msb[807:800];
        w_din[229] = |w_data_msb[815:808];
        w_din[230] = |w_data_msb[823:816];
        w_din[231] = |w_data_msb[831:824];
        w_din[232] = |w_data_msb[839:832];
        w_din[233] = |w_data_msb[847:840];
        w_din[234] = |w_data_msb[855:848];
        w_din[235] = |w_data_msb[863:856];
        w_din[236] = |w_data_msb[871:864];
        w_din[237] = |w_data_msb[879:872];
        w_din[238] = |w_data_msb[887:880];
        w_din[239] = |w_data_msb[895:888];
        w_din[240] = |w_data_msb[903:896];
        w_din[241] = |w_data_msb[911:904];
        w_din[242] = |w_data_msb[919:912];
        w_din[243] = |w_data_msb[927:920];
        w_din[244] = |w_data_msb[935:928];
        w_din[245] = |w_data_msb[943:936];
        w_din[246] = |w_data_msb[951:944];
        w_din[247] = |w_data_msb[959:952];
        w_din[248] = |w_data_msb[967:960];
        w_din[249] = |w_data_msb[975:968];
        w_din[250] = |w_data_msb[983:976];
        w_din[251] = |w_data_msb[991:984];
        w_din[252] = |w_data_msb[999:992];
        w_din[253] = |w_data_msb[1007:1000];
        w_din[254] = |w_data_msb[1015:1008];
        w_din[255] = |w_data_msb[1023:1016];
    end
    
endmodule
