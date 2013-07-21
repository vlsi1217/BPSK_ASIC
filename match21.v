

`timescale 1ns/10ps
module mf(clk,reset,flagin,din,dout,flagout1,sync,eof);
input clk, flagin,reset;
input [31:0] din;
output reg [7:0] dout; 
reg [31:0] dout1;
reg [4:0] flag_in_reg;
output flagout1;
wire flagout;
output reg sync;
output eof;
reg signed[31:0] sr[0:499];
// 4 stages of addition
reg signed[31:0] pre0 [0:99]; 
reg signed[31:0] p1 [0:19];
reg signed[31:0] p2 [0:3];
reg signed[31:0] p3;
//reg sync;
reg syncflag;
reg [9:0] final_reg;
integer cnt; //cnt10;


//////////////////////////////////////////////////////////
// input FF
//////////////////////////////////////////////////////////
always @(negedge (clk) or posedge (reset))
begin: block1
	integer i,j,k;
	//if (reset || sync) begin
	if (reset) begin
		for (i=0; i<500; i=i+1) begin
			sr[i] <= #1 0;
		end
	end
	else if (sync) begin
		for (i=0; i<500; i=i+1) begin
			sr[i] <= #1 0;
		end
	end
	else if (flagin == 1) begin
		//sr[0] <= #1 din;
		flag_in_reg[0] <= #1 flagin;
		//for (k=0; k < 25; k=k+1) begin           //credit for Jayesh!!! NICE
			sr[0] <= #1 din;
		//end
		for (j=1; j<500; j=j+1) begin
			sr[j] <= #1 sr[j-1];
		end 
	end else 
	flag_in_reg[0] <= #1 0;
end


always @ (negedge (clk) or posedge (reset)) 
begin: block2	
integer l;
if (reset) begin

	for (l=0; l<100; l=l+1) begin
		pre0[l] <= #1 0;
	end
end else if (flag_in_reg[0] == 1) begin
	flag_in_reg[1] <= #1 flag_in_reg[0];

	// the first stage
pre0[5] <= #1 sr[25]+sr[26]+sr[27]+sr[28]+sr[29];
pre0[6] <= #1 sr[30]+sr[31]+sr[32]+sr[33]+sr[34];
pre0[7] <= #1 sr[35]+sr[36]+sr[37]+sr[38]+sr[39];
pre0[8] <= #1 sr[40]+sr[41]+sr[42]+sr[43]+sr[44];
pre0[9] <= #1 sr[45]+sr[46]+sr[47]+sr[48]+sr[49];
pre0[10] <= #1 sr[50]+sr[51]+sr[52]+sr[53]+sr[54];
pre0[11] <= #1 sr[55]+sr[56]+sr[57]+sr[58]+sr[59];
pre0[12] <= #1 sr[60]+sr[61]+sr[62]+sr[63]+sr[64];
pre0[13] <= #1 sr[65]+sr[66]+sr[67]+sr[68]+sr[69];
pre0[14] <= #1 sr[70]+sr[71]+sr[72]+sr[73]+sr[74];
pre0[40] <= #1 sr[200]+sr[201]+sr[202]+sr[203]+sr[204];
pre0[41] <= #1 sr[205]+sr[206]+sr[207]+sr[208]+sr[209];
pre0[42] <= #1 sr[210]+sr[211]+sr[212]+sr[213]+sr[214];
pre0[43] <= #1 sr[215]+sr[216]+sr[217]+sr[218]+sr[219];
pre0[44] <= #1 sr[220]+sr[221]+sr[222]+sr[223]+sr[224];
pre0[45] <= #1 sr[225]+sr[226]+sr[227]+sr[228]+sr[229];
pre0[46] <= #1 sr[230]+sr[231]+sr[232]+sr[233]+sr[234];
pre0[47] <= #1 sr[235]+sr[236]+sr[237]+sr[238]+sr[239];
pre0[48] <= #1 sr[240]+sr[241]+sr[242]+sr[243]+sr[244];
pre0[49] <= #1 sr[245]+sr[246]+sr[247]+sr[248]+sr[249];
pre0[50] <= #1 sr[250]+sr[251]+sr[252]+sr[253]+sr[254];
pre0[51] <= #1 sr[255]+sr[256]+sr[257]+sr[258]+sr[259];
pre0[52] <= #1 sr[260]+sr[261]+sr[262]+sr[263]+sr[264];
pre0[53] <= #1 sr[265]+sr[266]+sr[267]+sr[268]+sr[269];
pre0[54] <= #1 sr[270]+sr[271]+sr[272]+sr[273]+sr[274];
pre0[65] <= #1 sr[325]+sr[326]+sr[327]+sr[328]+sr[329];
pre0[66] <= #1 sr[330]+sr[331]+sr[332]+sr[333]+sr[334];
pre0[67] <= #1 sr[335]+sr[336]+sr[337]+sr[338]+sr[339];
pre0[68] <= #1 sr[340]+sr[341]+sr[342]+sr[343]+sr[344];
pre0[69] <= #1 sr[345]+sr[346]+sr[347]+sr[348]+sr[349];
pre0[75] <= #1 sr[375]+sr[376]+sr[377]+sr[378]+sr[379];
pre0[76] <= #1 sr[380]+sr[381]+sr[382]+sr[383]+sr[384];
pre0[77] <= #1 sr[385]+sr[386]+sr[387]+sr[388]+sr[389];
pre0[78] <= #1 sr[390]+sr[391]+sr[392]+sr[393]+sr[394];
pre0[79] <= #1 sr[395]+sr[396]+sr[397]+sr[398]+sr[399];
pre0[80] <= #1 sr[400]+sr[401]+sr[402]+sr[403]+sr[404];
pre0[81] <= #1 sr[405]+sr[406]+sr[407]+sr[408]+sr[409];
pre0[82] <= #1 sr[410]+sr[411]+sr[412]+sr[413]+sr[414];
pre0[83] <= #1 sr[415]+sr[416]+sr[417]+sr[418]+sr[419];
pre0[84] <= #1 sr[420]+sr[421]+sr[422]+sr[423]+sr[424];
pre0[0] <= #1 sr[0]+sr[1]+sr[2]+sr[3]+sr[4];
pre0[1] <= #1 sr[5]+sr[6]+sr[7]+sr[8]+sr[9];
pre0[2] <= #1 sr[10]+sr[11]+sr[12]+sr[13]+sr[14];
pre0[3] <= #1 sr[15]+sr[16]+sr[17]+sr[18]+sr[19];
pre0[4] <= #1 sr[20]+sr[21]+sr[22]+sr[23]+sr[24];
pre0[15] <= #1 sr[75]+sr[76]+sr[77]+sr[78]+sr[79];
pre0[16] <= #1 sr[80]+sr[81]+sr[82]+sr[83]+sr[84];
pre0[17] <= #1 sr[85]+sr[86]+sr[87]+sr[88]+sr[89];
pre0[18] <= #1 sr[90]+sr[91]+sr[92]+sr[93]+sr[94];
pre0[19] <= #1 sr[95]+sr[96]+sr[97]+sr[98]+sr[99];
pre0[25] <= #1 sr[125]+sr[126]+sr[127]+sr[128]+sr[129];
pre0[26] <= #1 sr[130]+sr[131]+sr[132]+sr[133]+sr[134];
pre0[27] <= #1 sr[135]+sr[136]+sr[137]+sr[138]+sr[139];
pre0[28] <= #1 sr[140]+sr[141]+sr[142]+sr[143]+sr[144];
pre0[29] <= #1 sr[145]+sr[146]+sr[147]+sr[148]+sr[149];
pre0[30] <= #1 sr[150]+sr[151]+sr[152]+sr[153]+sr[154];
pre0[31] <= #1 sr[155]+sr[156]+sr[157]+sr[158]+sr[159];
pre0[32] <= #1 sr[160]+sr[161]+sr[162]+sr[163]+sr[164];
pre0[33] <= #1 sr[165]+sr[166]+sr[167]+sr[168]+sr[169];
pre0[34] <= #1 sr[170]+sr[171]+sr[172]+sr[173]+sr[174];
pre0[35] <= #1 sr[175]+sr[176]+sr[177]+sr[178]+sr[179];
pre0[36] <= #1 sr[180]+sr[181]+sr[182]+sr[183]+sr[184];
pre0[37] <= #1 sr[185]+sr[186]+sr[187]+sr[188]+sr[189];
pre0[38] <= #1 sr[190]+sr[191]+sr[192]+sr[193]+sr[194];
pre0[39] <= #1 sr[195]+sr[196]+sr[197]+sr[198]+sr[199];
pre0[55] <= #1 sr[275]+sr[276]+sr[277]+sr[278]+sr[279];
pre0[56] <= #1 sr[280]+sr[281]+sr[282]+sr[283]+sr[284];
pre0[57] <= #1 sr[285]+sr[286]+sr[287]+sr[288]+sr[289];
pre0[58] <= #1 sr[290]+sr[291]+sr[292]+sr[293]+sr[294];
pre0[59] <= #1 sr[295]+sr[296]+sr[297]+sr[298]+sr[299];
pre0[60] <= #1 sr[300]+sr[301]+sr[302]+sr[303]+sr[304];
pre0[61] <= #1 sr[305]+sr[306]+sr[307]+sr[308]+sr[309];
pre0[62] <= #1 sr[310]+sr[311]+sr[312]+sr[313]+sr[314];
pre0[63] <= #1 sr[315]+sr[316]+sr[317]+sr[318]+sr[319];
pre0[64] <= #1 sr[320]+sr[321]+sr[322]+sr[323]+sr[324];
pre0[90] <= #1 sr[450]+sr[451]+sr[452]+sr[453]+sr[454];
pre0[91] <= #1 sr[455]+sr[456]+sr[457]+sr[458]+sr[459];
pre0[92] <= #1 sr[460]+sr[461]+sr[462]+sr[463]+sr[464];
pre0[93] <= #1 sr[465]+sr[466]+sr[467]+sr[468]+sr[469];
pre0[94] <= #1 sr[470]+sr[471]+sr[472]+sr[473]+sr[474];
pre0[95] <= #1 sr[475]+sr[476]+sr[477]+sr[478]+sr[479];
pre0[96] <= #1 sr[480]+sr[481]+sr[482]+sr[483]+sr[484];
pre0[97] <= #1 sr[485]+sr[486]+sr[487]+sr[488]+sr[489];
pre0[98] <= #1 sr[490]+sr[491]+sr[492]+sr[493]+sr[494];
pre0[99] <= #1 sr[495]+sr[496]+sr[497]+sr[498]+sr[499];
//	
	end else 
		flag_in_reg[1] <= #1 0; 

end


//////////////////////////////////////////////////////////
//  2nd calculation, add all the 100 pre0 values
//////////////////////////////////////////////////////////
always @ (negedge (clk) or posedge (reset)) begin:begin3
integer l;
if (reset) begin

	for (l=0; l<20; l=l+1) begin
		p1[l] <= #1 0;
	end
end else if (flag_in_reg[1] == 1) begin
	flag_in_reg[2] <= #1 flag_in_reg[1];
	p1[0] <= #1 pre0[0]+pre0[1]+pre0[2]+pre0[3]+pre0[4];
	p1[1] <= #1 pre0[5]+pre0[6]+pre0[7]+pre0[8]+pre0[9];
	p1[2] <= #1 (~(pre0[10]+pre0[11]+pre0[12]+pre0[13]+pre0[14])+32'd1);//   2's complement taken accordinf to 1001111100   0110000011
	p1[3] <= #1 (~(pre0[15]+pre0[16]+pre0[17]+pre0[18]+pre0[19])+32'd1);//
	p1[4] <= #1 (~(pre0[20]+pre0[21]+pre0[22]+pre0[23]+pre0[24])+32'd1);//
	p1[5] <= #1 (~(pre0[25]+pre0[26]+pre0[27]+pre0[28]+pre0[29])+32'd1);//
	p1[6] <= #1 (~(pre0[30]+pre0[31]+pre0[32]+pre0[33]+pre0[34])+32'd1);//
	p1[7] <= #1 pre0[35]+pre0[36]+pre0[37]+pre0[38]+pre0[39];
	p1[8] <= #1 pre0[40]+pre0[41]+pre0[42]+pre0[43]+pre0[44];
	p1[9] <= #1 (~(pre0[45]+pre0[46]+pre0[47]+pre0[48]+pre0[49])+32'd1);//
	p1[10] <= #1 (~(pre0[50]+pre0[51]+pre0[52]+pre0[53]+pre0[54])+32'd1);//
	p1[11] <= #1 (~(pre0[55]+pre0[56]+pre0[57]+pre0[58]+pre0[59])+32'd1);//
	p1[12] <= #1 pre0[60]+pre0[61]+pre0[62]+pre0[63]+pre0[64];
	p1[13] <= #1 pre0[65]+pre0[66]+pre0[67]+pre0[68]+pre0[69];
	p1[14] <= #1 pre0[70]+pre0[71]+pre0[72]+pre0[73]+pre0[74];
	p1[15] <= #1 pre0[75]+pre0[76]+pre0[77]+pre0[78]+pre0[79];
	p1[16] <= #1 pre0[80]+pre0[81]+pre0[82]+pre0[83]+pre0[84];
	p1[17] <= #1 (~(pre0[85]+pre0[86]+pre0[87]+pre0[88]+pre0[89])+32'd1);//
	p1[18] <= #1 (~(pre0[90]+pre0[91]+pre0[92]+pre0[93]+pre0[94])+32'd1);//
	p1[19] <= #1 pre0[95]+pre0[96]+pre0[97]+pre0[98]+pre0[99];
	end else 
	flag_in_reg[2] <= #1 0; 
end

//////////////////////////////////////////////////////////
//  3rd calculation, add all the 100 pre0 values
//////////////////////////////////////////////////////////
always @ (negedge (clk) or posedge (reset)) begin:block4
integer m;
if (reset) begin

	for (m=0; m<4; m=m+1) begin
		p2[m] <= #1 0;
	end
end else if (flag_in_reg[2] == 1) begin
	flag_in_reg[3] <= #1 flag_in_reg[2];
	p2[0] <= #1 p1[0]+p1[1]+p1[2]+p1[3]+p1[4];
	p2[1] <= #1 p1[5]+p1[6]+p1[7]+p1[8]+p1[9];
	p2[2] <= #1 p1[10]+p1[11]+p1[12]+p1[13]+p1[14];
	p2[3] <= #1 p1[15]+p1[16]+p1[17]+p1[18]+p1[19];
	end else 
	flag_in_reg[3] <= #1 0; 
end

//////////////////////////////////////////////////////////
//  3rd calculation, add all the 100 pre0 values
//////////////////////////////////////////////////////////
always @ (negedge (clk) or posedge (reset)) begin
	if (reset) begin
	  p3 <= #1 0;
	end
	else if (flag_in_reg[3] == 1) begin
	  flag_in_reg[4] <= #1 flag_in_reg[3];
	  p3 <= #1 p2[0]+p2[1]+p2[2]+p2[3];
	end else 
	  flag_in_reg[4] <= #1 0; 
end

always @(*) begin
dout1=p3;
//less = ($signed(dout) > $signed(32'd800000000) \);
end

assign flagout = flag_in_reg[4];

/////////////////////////////////////////////////////////
// Creating a sync flag and flushing the shift register
/////////////////////////////////////////////////////////

always @(negedge (clk) or posedge (reset)) begin
	if (reset) sync <= #1 0;
	else
	//sync <= #1 (dout > 32'd800000000 || dout < -32'd800000000)?1:0; 
	if (((flagout == 1) && ($signed(dout1) > $signed(32'd740000000))) || ($signed(dout1) < $signed(-32'd740000000) && (flagout == 1)))
	  sync <= #1 1;
	else 
	  sync <= #1 0;	

end

//////////////////////////////////////////////////
//////
//Taking in data (13th sample of each)
////////////////////////////////////////////////////////
reg [31:0] reg250[0:249];   // shift reg for 10 bits signal data
reg [31:0] d0,d1,d2,d3,d4,d5,d6,d7,d8,d9;
//reg eof;
//wire eof;
//reg sync250;
reg [1:0] flag2_reg;
reg [9:0] final_reg_out;

assign eof = (final_reg == 10'h143 || final_reg == 10'h2BC)?1:0;

// Setting and clearing sync flag
always @(*) begin
	if(sync == 1) begin 
	  syncflag = 1;
	 // eof = 0;
	end else begin
	  syncflag = (eof ==1)?0:syncflag;  //syncflag shows the data are signal data
	  cnt = (cnt == 251)?1:cnt;
	  /*if(eof == 1) syncflag = 0;		
	  if (cnt == 251) begin     // good point, credit for Jayesh, Apr29, 2013
	  cnt = 1; 
	  end
	else cnt = cnt;*/
	end
end


// putting 250 samples in a register
always @(negedge (clk) or posedge (reset)) begin: bl
integer i,j,k;
  if (reset) begin
	for(i=0;i<250;i=i+1) begin: g1
		reg250[i] <= #1 0;
	end
	
  end else begin 
  	if (flagin && syncflag) begin         
		reg250[0] <= #1 din;     //reg250 is a shift reg
		cnt <= #1 1;
		for (j=1; j<250; j=j+1) begin
		reg250[j] <= #1 reg250[j-1];
		cnt <= #1 cnt + 1;
		end 
  	end else if (syncflag==0) begin
		for(k=0;k<250;k=k+1)
		reg250[k] <= #1 0;	// if not syncflag, reset the SR
  	end
   end
end


//////////////////////////////////////////////////////
// Taking out 13th sample from 250 reg into 10 bit reg
//////////////////////////////////////////////////////
always @(negedge (clk) or posedge (reset)) begin: gh
integer i;
if (reset) begin
	d9 <= #1 0;
	d8 <= #1 0;
	d7 <= #1 0;
	d6 <= #1 0;
	d5 <= #1 0;
	d4 <= #1 0;
	d3 <= #1 0;
	d2 <= #1 0;
	d1 <= #1 0;
	d0 <= #1 0;
end else if ((cnt == 250) && (syncflag == 1) ) begin
	d9 <= #1 reg250[12];
	d8 <= #1 reg250[37];
	d7 <= #1 reg250[62];
	d6 <= #1 reg250[87];
	d5 <= #1 reg250[112];
	d4 <= #1 reg250[137];
	d3 <= #1 reg250[162];
	d2 <= #1 reg250[187];
	d1 <= #1 reg250[212];
	d0 <= #1 reg250[237];
end
end

// store the MSB of ten 32bit values into an 10bit array 
always @(negedge (clk) or posedge (reset)) begin:bh
integer l,m;
//if (reset || eof) begin
 if (reset) begin	
	cnt <= #1 0;
	flag2_reg[0] <= #1 0;
	for(l=0;l<10;l=l+1)
	   final_reg[l] <= #1 0;
   end
else if(eof) begin
	cnt <= #1 0;
	flag2_reg[0] <= #1 0;
	for(l=0;l<10;l=l+1)
	   final_reg[l] <= #1 0;
   end
   else begin
   if (cnt == 250 && flagin) begin  // why need flagin?
	flag2_reg[0] <= #1 1;
	final_reg[0] <= #1 (d0[31]) ? 0 : 1;
	final_reg[1] <= #1 (d1[31]) ? 0 : 1;
	final_reg[2] <= #1 (d2[31]) ? 0 : 1;
	final_reg[3] <= #1 (d3[31]) ? 0 : 1;
	final_reg[4] <= #1 (d4[31]) ? 0 : 1;
	final_reg[5] <= #1 (d5[31]) ? 0 : 1;
	final_reg[6] <= #1 (d6[31]) ? 0 : 1;
	final_reg[7] <= #1 (d7[31]) ? 0 : 1;
	final_reg[8] <= #1 (d8[31]) ? 0 : 1;
	final_reg[9] <= #1 (d9[31]) ? 0 : 1;
   end
   else flag2_reg[0] <= #1 0;
end
end

`include "decode.v"

always @(negedge (clk) or posedge (reset)) begin:de
if (reset) begin
	flag2_reg[1] <= #1 0;
end else if (syncflag && flag2_reg[0]) begin
	flag2_reg[1] <= #1 flag2_reg[0];
	dout <= #1 (final_reg != 10'h143 || final_reg != 10'h2BC)?decode(final_reg):dout;
end else begin
	flag2_reg[1] <= #1 0;
end
end

assign flagout1 = flag2_reg[1];

endmodule

