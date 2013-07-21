//`define ntaps 43
`timescale 1ns/10ps
//`include "DW02_mult_2_stage.v"

module fir(clk,reset,flagin,din,dout,flagout);
input clk, flagin,reset;
input [31:0] din;
output signed [31:0] dout;
//input [5:0] waddr;
//input wstrobe;
//input [31:0] wdata;
//output [31:0] rdata;
reg flagin1,flagin2,flagin3,flagin4;
output flagout;
reg signed [63:0] sum[0:42];
reg signed[63:0] sumout;
reg signed[31:0] coef[0:42];
            //  wire [31:0] sr1;
             //    wire [63:0] pr1;
reg signed [31:0] sr[0:42];
reg signed[63:0] pr[0:42];
reg signed [63:0] pr_dw0, pr_dw1, pr_dw2, pr_dw3, pr_dw4, pr_dw5, pr_dw6, pr_dw7, pr_dw8, pr_dw9, pr_dw10, pr_dw11, pr_dw12, pr_dw13, pr_dw14, pr_dw15, pr_dw16, pr_dw17, pr_dw18, pr_dw19, pr_dw20, pr_dw21, pr_dw22, pr_dw23, pr_dw24, pr_dw25, pr_dw26, pr_dw27, pr_dw28, pr_dw29, pr_dw30, pr_dw31, pr_dw32, pr_dw33, pr_dw34, pr_dw35, pr_dw36, pr_dw37, pr_dw38, pr_dw39, pr_dw40, pr_dw41, pr_dw42;
//reg [42:0] flag_out_reg;
//wire [63:0] pr_sample;
//reg [63:0] sum;

always @(negedge clk)
begin
coef[0]= 32'd2; 
coef[1]=32'd4;
coef[2]=32'd4;
coef[3]=32'd2;
coef[4]=-32'd3;
coef[5]=-32'd10;
coef[6]=-32'd14;
coef[7]=-32'd14;
coef[8]=-32'd6;
coef[9]=32'd7;
coef[10]=32'd19;
coef[11]= 32'd22;
coef[12]=32'd12;
coef[13]=-32'd11;
coef[14]=-32'd36;
coef[15]=-32'd48;
coef[16]=-32'd35;
coef[17]=32'd11;
coef[18]=32'd83;
coef[19]=32'd161;
coef[20]=32'd221;
coef[21]=32'd244;
coef[22]=32'd221;
coef[23]=32'd161;
coef[24]=32'd83;
coef[25]=32'd11;
coef[26]=-32'd35;
coef[27]=-32'd48;
coef[28]=-32'd36;
coef[29]=-32'd11;
coef[30]=32'd12;
coef[31]=32'd22;
coef[32]=32'd19;
coef[33]=32'd7;
coef[34]=32'd6;
coef[35]=-32'd14;
coef[36]=-32'd14;
coef[37]=-32'd10;
coef[38]=-32'd3;
coef[39]=32'd2;
coef[40]=32'd4;
coef[41]=32'd4;
coef[42]=32'd2;
//$display ("coef[0]=%d",coef[0]);
end

always @(negedge clk or posedge reset)
begin
if (reset) begin
/*sr[0] <= #1 32'd0;
sr[1] <= #1 32'd0;
sr[2] <= #1 32'd0;
sr[3] <= #1 32'd0;
sr[4] <= #1 32'd0;
sr[5] <= #1 32'd0;
sr[6] <= #1 32'd0;
sr[7] <= #1 32'd0;
sr[8] <= #1 32'd0;
sr[9] <= #1 32'd0;
sr[10] <= #1 32'd0;
sr[11] <= #1 32'd0;
sr[12] <= #1 32'd0;
sr[13] <= #1 32'd0;
sr[14] <= #1 32'd0;
sr[15] <= #1 32'd0;
sr[16] <= #1 32'd0;
sr[17] <= #1 32'd0;
sr[18] <= #1 32'd0;
sr[19] <= #1 32'd0;
sr[20] <= #1 32'd0;
sr[21] <= #1 32'd0;
sr[22] <= #1 32'd0;
sr[23] <= #1 32'd0;
sr[24] <= #1 32'd0;
sr[25] <= #1 32'd0;
sr[26] <= #1 32'd0;
sr[27] <= #1 32'd0;
sr[28] <= #1 32'd0;
sr[29] <= #1 32'd0;
sr[30] <= #1 32'd0;
sr[31] <= #1 32'd0;
sr[32] <= #1 32'd0;
sr[33] <= #1 32'd0;
sr[34] <= #1 32'd0;
sr[35] <= #1 32'd0;
sr[36] <= #1 32'd0;
sr[37] <= #1 32'd0;
sr[38] <= #1 32'd0;
sr[39] <= #1 32'd0;
sr[40] <= #1 32'd0;
sr[41] <= #1 32'd0;
sr[42] <= #1 32'd0;*/
pr_dw0 <= 64'd0;
pr_dw1 <= 64'd0;
pr_dw2 <= 64'd0;
pr_dw3 <= 64'd0;
pr_dw4 <= 64'd0;
pr_dw5 <= 64'd0;
pr_dw6 <= 64'd0;
pr_dw7 <= 64'd0;
pr_dw8 <= 64'd0;
pr_dw9 <= 64'd0;
pr_dw10 <=  64'd0;
pr_dw11 <= 64'd0;
pr_dw12 <= 64'd0;
pr_dw13 <= 64'd0;
pr_dw14 <= 64'd0;
pr_dw15 <= 64'd0;
pr_dw16 <= 64'd0;
pr_dw17 <= 64'd0;
pr_dw18 <= 64'd0;
pr_dw19 <= 64'd0;
pr_dw20 <= 64'd0;
pr_dw21 <= 64'd0;
pr_dw22 <= 64'd0;
pr_dw23 <= 64'd0;
pr_dw24 <= 64'd0;
pr_dw25 <= 64'd0;
pr_dw26 <= 64'd0;
pr_dw27 <= 64'd0;
pr_dw28 <= 64'd0;
pr_dw29 <= 64'd0;
pr_dw30 <= 64'd0;
pr_dw31 <= 64'd0;
pr_dw32 <= 64'd0;
pr_dw33 <= 64'd0;
pr_dw34 <= 64'd0;
pr_dw35 <= 64'd0;
pr_dw36 <= 64'd0;
pr_dw37 <= 64'd0;
pr_dw38 <= 64'd0;
pr_dw39 <= 64'd0;
pr_dw40 <= 64'd0;
pr_dw41 <= 64'd0;
pr_dw42 <= 64'd0;
flagin2 <= #1 0; end
else if (flagin1 == 1)begin 
flagin2 <= #1 flagin1;
pr_dw0 <= sr[0] * coef[0];
pr_dw1 <= sr[1] * coef[1];
pr_dw2 <= sr[2] * coef[2];
pr_dw3 <= sr[3] * coef[3];
pr_dw4 <= sr[4] * coef[4];
pr_dw5 <= sr[5] * coef[5];
pr_dw6 <= sr[6] * coef[6];
pr_dw7 <= sr[7] * coef[7];
pr_dw8 <= sr[8] * coef[8];
pr_dw9 <= sr[9] * coef[9];
pr_dw10 <= sr[10] * coef[10];
pr_dw11 <= sr[11] * coef[11];
pr_dw12 <= sr[12] * coef[12];
pr_dw13 <= sr[13] * coef[13];
pr_dw14 <= sr[14] * coef[14];
pr_dw15 <= sr[15] * coef[15];
pr_dw16 <= sr[16] * coef[16];
pr_dw17 <= sr[17] * coef[17];
pr_dw18 <= sr[18] * coef[18];
pr_dw19 <= sr[19] * coef[19];
pr_dw20 <= sr[20] * coef[20];
pr_dw21 <= sr[21] * coef[21];
pr_dw22 <= sr[22] * coef[22];
pr_dw23 <= sr[23] * coef[23];
pr_dw24 <= sr[24] * coef[24];
pr_dw25 <= sr[25] * coef[25];
pr_dw26 <= sr[26] * coef[26];
pr_dw27 <= sr[27] * coef[27];
pr_dw28 <= sr[28] * coef[28];
pr_dw29 <= sr[29] * coef[29];
pr_dw30 <= sr[30] * coef[30];
pr_dw31 <= sr[31] * coef[31];
pr_dw32 <= sr[32] * coef[32];
pr_dw33 <= sr[33] * coef[33];
pr_dw34 <= sr[34] * coef[34];
pr_dw35 <= sr[35] * coef[35];
pr_dw36 <= sr[36] * coef[36];
pr_dw37 <= sr[37] * coef[37];
pr_dw38 <= sr[38] * coef[38];
pr_dw39 <= sr[39] * coef[39];
pr_dw40 <= sr[40] * coef[40];
pr_dw41 <= sr[41] * coef[41];
pr_dw42 <= sr[42] * coef[42];
end
else flagin2 <= #1 0;
end

always @(negedge clk or posedge reset)
begin:block2
integer i,k,j;
if (reset) begin
//dout <= #1 0;
//sum <= #1 64'd0;
flagin1 <= #1 0;
sr[0] <= #1 32'd0;
sr[1] <= #1 32'd0;
sr[2] <= #1 32'd0;
sr[3] <= #1 32'd0;
sr[4] <= #1 32'd0;
sr[5] <= #1 32'd0;
sr[6] <= #1 32'd0;
sr[7] <= #1 32'd0;
sr[8] <= #1 32'd0;
sr[9] <= #1 32'd0;
sr[10] <= #1 32'd0;
sr[11] <= #1 32'd0;
sr[12] <= #1 32'd0;
sr[13] <= #1 32'd0;
sr[14] <= #1 32'd0;
sr[15] <= #1 32'd0;
sr[16] <= #1 32'd0;
sr[17] <= #1 32'd0;
sr[18] <= #1 32'd0;
sr[19] <= #1 32'd0;
sr[20] <= #1 32'd0;
sr[21] <= #1 32'd0;
sr[22] <= #1 32'd0;
sr[23] <= #1 32'd0;
sr[24] <= #1 32'd0;
sr[25] <= #1 32'd0;
sr[26] <= #1 32'd0;
sr[27] <= #1 32'd0;
sr[28] <= #1 32'd0;
sr[29] <= #1 32'd0;
sr[30] <= #1 32'd0;
sr[31] <= #1 32'd0;
sr[32] <= #1 32'd0;
sr[33] <= #1 32'd0;
sr[34] <= #1 32'd0;
sr[35] <= #1 32'd0;
sr[36] <= #1 32'd0;
sr[37] <= #1 32'd0;
sr[38] <= #1 32'd0;
sr[39] <= #1 32'd0;
sr[40] <= #1 32'd0;
sr[41] <= #1 32'd0;
sr[42] <= #1 32'd0;
/*
pr[0] <= #1 64'd0;
pr[1] <= #1 64'd0;
pr[2] <= #1 64'd0;
pr[3] <= #1 64'd0;
pr[4] <= #1 64'd0;
pr[5] <= #1 64'd0;
pr[6] <= #1 64'd0;
pr[7] <= #1 64'd0;
pr[8] <= #1 64'd0;
pr[9] <= #1 64'd0;
pr[10] <= #1 64'd0;
pr[11] <= #1 64'd0;
pr[12] <= #1 64'd0;
pr[13] <= #1 64'd0;
pr[14] <= #1 64'd0;
pr[15] <= #1 64'd0;
pr[16] <= #1 64'd0;
pr[17] <= #1 64'd0;
pr[18] <= #1 64'd0;
pr[19] <= #1 64'd0;
pr[20] <= #1 64'd0;                                block 1;
pr[21] <= #1 64'd0;
pr[22] <= #1 64'd0;
pr[23] <= #1 64'd0;
pr[24] <= #1 64'd0;
pr[25] <= #1 64'd0;
pr[26] <= #1 64'd0;
pr[27] <= #1 64'd0;
pr[28] <= #1 64'd0;
pr[29] <= #1 64'd0;
pr[30] <= #1 64'd0;
pr[31] <= #1 64'd0;
pr[32] <= #1 64'd0;
pr[33] <= #1 64'd0;
pr[34] <= #1 64'd0;
pr[35] <= #1 64'd0;
pr[36] <= #1 64'd0;
pr[37] <= #1 64'd0;
pr[38] <= #1 64'd0;
pr[39] <= #1 64'd0;
pr[40] <= #1 64'd0;
pr[41] <= #1 64'd0;
pr[42] <= #1 64'd0;
//$display ("pr=%d,sr=%d",pr[0],sr[0]);
//for (k =0; k< 42; k = k+1)
//begin
//sr[k] <= #1 0; end
//for (j = 0; j< 42; j=j+1)
//begin
//pr[j] <= #1 0;
//flag_out_reg <= #1 43'd0 ;   */
end
else
 if(flagin==1)
   begin
 sr[0] <= #1 din;
flagin1 <= #1 flagin;
for (i=1; i < 43; i=i+1) begin
	sr[i] <= #1 sr[i-1];

end
end
else flagin1 <= #1 0;
end
/*
always @(negedge clk or posedge reset)
begin
if (reset) begin
flagin1 <= #1 0;
sr[0] <= #1 0; end
else begin
 if(flagin==1)begin
   sr[0] <= #1 din;
flagin1 <= #1 flagin; end
//$display ("sr[0]=%d",sr[0]);
end
end
*/
always @ (negedge clk or posedge reset)
begin:block3
if (reset)
begin
/*sr[0] <= #1 32'd0;
sr[1] <= #1 32'd0;
sr[2] <= #1 32'd0;
sr[3] <= #1 32'd0;
sr[4] <= #1 32'd0;
sr[5] <= #1 32'd0;
sr[6] <= #1 32'd0;
sr[7] <= #1 32'd0;
sr[8] <= #1 32'd0;
sr[9] <= #1 32'd0;
sr[10] <= #1 32'd0;
sr[11] <= #1 32'd0;
sr[12] <= #1 32'd0;
sr[13] <= #1 32'd0;
sr[14] <= #1 32'd0;
sr[15] <= #1 32'd0;
sr[16] <= #1 32'd0;
sr[17] <= #1 32'd0;
sr[18] <= #1 32'd0;
sr[19] <= #1 32'd0;
sr[20] <= #1 32'd0;
sr[21] <= #1 32'd0;
sr[22] <= #1 32'd0;
sr[23] <= #1 32'd0;
sr[24] <= #1 32'd0;
sr[25] <= #1 32'd0;
sr[26] <= #1 32'd0;
sr[27] <= #1 32'd0;
sr[28] <= #1 32'd0;
sr[29] <= #1 32'd0;
sr[30] <= #1 32'd0;
sr[31] <= #1 32'd0;
sr[32] <= #1 32'd0;
sr[33] <= #1 32'd0;
sr[34] <= #1 32'd0;
sr[35] <= #1 32'd0;
sr[36] <= #1 32'd0;
sr[37] <= #1 32'd0;
sr[38] <= #1 32'd0;
sr[39] <= #1 32'd0;
sr[40] <= #1 32'd0;
sr[41] <= #1 32'd0;
sr[42] <= #1 32'd0;
*/
pr[0] <= #1 pr_dw0;
pr[1] <= #1 pr_dw1;
pr[2] <= #1 pr_dw2;
pr[3] <= #1 pr_dw3;
pr[4] <= #1 pr_dw4;
pr[5] <= #1 pr_dw5;
pr[6] <= #1 pr_dw6;
pr[7] <= #1 pr_dw7;
pr[8] <= #1 pr_dw8;
pr[9] <= #1 pr_dw9;
pr[10] <= #1 pr_dw10;
pr[11] <= #1 pr_dw11;
pr[12] <= #1 pr_dw12;
pr[13] <= #1 pr_dw13;
pr[14] <= #1 pr_dw14;
pr[15] <= #1 pr_dw15;
pr[16] <= #1 pr_dw16;
pr[17] <= #1 pr_dw17;
pr[18] <= #1 pr_dw18;
pr[19] <= #1 pr_dw19;
pr[20] <= #1 pr_dw20;
pr[21] <= #1 pr_dw21;
pr[22] <= #1 pr_dw22;
pr[23] <= #1 pr_dw23;
pr[24] <= #1 pr_dw24;
pr[25] <= #1 pr_dw25;
pr[26] <= #1 pr_dw26;
pr[27] <= #1 pr_dw27;
pr[28] <= #1 pr_dw28;
pr[29] <= #1 pr_dw29;
pr[30] <= #1 pr_dw30;
pr[31] <= #1 pr_dw31;
pr[32] <= #1 pr_dw32;
pr[33] <= #1 pr_dw33;
pr[34] <= #1 pr_dw34;
pr[35] <= #1 pr_dw35;
pr[36] <= #1 pr_dw36;
pr[37] <= #1 pr_dw37;
pr[38] <= #1 pr_dw38;
pr[39] <= #1 pr_dw39;
pr[40] <= #1 pr_dw40;
pr[41] <= #1 pr_dw41;
pr[42] <= #1 pr_dw42;
flagin3 <= #1 0; end
//flag_out_reg <= #1 42'd0 ; end
else if (flagin2 == 1)begin
flagin3 <= #1 flagin2;
pr[0] <= #1 pr_dw0; //$display ("pr[0]=%d", pr[0]);$display ("pr_dw0=%d", pr_dw0);
pr[1] <= #1 pr_dw1; 
pr[2] <= #1 pr_dw2; 
pr[3] <= #1 pr_dw3; 
pr[4] <= #1 pr_dw4; 
pr[5] <= #1 pr_dw5; 
pr[6] <= #1 pr_dw6; 
pr[7] <= #1 pr_dw7; 
pr[8] <= #1 pr_dw8; 
pr[9] <= #1 pr_dw9; 
pr[10] <= #1 pr_dw10; 
pr[11] <= #1 pr_dw11; 
pr[12] <= #1 pr_dw12; 
pr[13] <= #1 pr_dw13; 
pr[14] <= #1 pr_dw14; 
pr[15] <= #1 pr_dw15; 
pr[16] <= #1 pr_dw16; 
pr[17] <= #1 pr_dw17; 
pr[18] <= #1 pr_dw18; 
pr[19] <= #1 pr_dw19; 
pr[20] <= #1 pr_dw20; 
pr[21] <= #1 pr_dw21; 
pr[22] <= #1 pr_dw22; 
pr[23] <= #1 pr_dw23; 
pr[24] <= #1 pr_dw24; 
pr[25] <= #1 pr_dw25; 
pr[26] <= #1 pr_dw26; 
pr[27] <= #1 pr_dw27; 
pr[28] <= #1 pr_dw28; 
pr[29] <= #1 pr_dw29; 
pr[30] <= #1 pr_dw30; 
pr[31] <= #1 pr_dw31; 
pr[32] <= #1 pr_dw32; 
pr[33] <= #1 pr_dw33; 
pr[34] <= #1 pr_dw34; 
pr[35] <= #1 pr_dw35; 
pr[36] <= #1 pr_dw36; 
pr[37] <= #1 pr_dw37; 
pr[38] <= #1 pr_dw38; 
pr[39] <= #1 pr_dw39; 
pr[40] <= #1 pr_dw40; 
pr[41] <= #1 pr_dw41; 
pr[42] <= #1 pr_dw42; 
end
else flagin3 <= #1 0;
end

always @ (*) begin
//if (reset) begin
//sum =0; end
//else begin
//if (reset) begin

sum[0]= pr[0]; //$display ("sum[0]= %d",sum[0]);
sum[1]= pr[1] + sum[0];//$display ("sum[1]= %d",sum[1]);
sum[2]= pr[2] + sum[1];//$display ("sum[2]= %d",sum[2]);
sum[3]= pr[3] + sum[2];//$display ("sum[3]= %d",sum[3]);
sum[4]= pr[4] + sum[3];//$display ("sum[4]= %d",sum[4]);
sum[5]= pr[5] + sum[4];//$display ("sum[5]= %d",sum[5]);
sum[6]= pr[6] + sum[5];//$display ("sum[6]= %d",sum[6]);
sum[7]= pr[7] + sum[6];//$display ("sum[7]= %d",sum[7]);
sum[8]= pr[8] + sum[7];//$display ("sum[8]= %d",sum[8]);
sum[9]= pr[9] + sum[8];
sum[10]= pr[10] + sum[9];
sum[11]= pr[11] + sum[10];
sum[12]= pr[12] + sum[11];
sum[13]= pr[13] + sum[12];
sum[14]= pr[14] + sum[13];
sum[15]= pr[15] + sum[14];
sum[16]= pr[16] + sum[15];
sum[17]= pr[17] + sum[16];
sum[18]= pr[18] + sum[17];
sum[19]= pr[19] + sum[18];//$display ("sum[19]= %d",sum[19]);
sum[20]= pr[20] + sum[19];
sum[21]= pr[21] + sum[20];
sum[22]= pr[22] + sum[21];
sum[23]= pr[23] + sum[22];
sum[24]= pr[24] + sum[23];
sum[25]= pr[25] + sum[24];
sum[26]= pr[26] + sum[25];
sum[27]= pr[27] + sum[26];
sum[28]= pr[28] + sum[27];
sum[29]= pr[29] + sum[28];
sum[30]= pr[30] + sum[29];//$display ("sum[30]= %d",sum[30]);
sum[31]= pr[31] + sum[30];
sum[32]= pr[32] + sum[31];
sum[33]= pr[33] + sum[32];
sum[34]= pr[34] + sum[33];
sum[35]= pr[35] + sum[34];
sum[36]= pr[36] + sum[35];
sum[37]= pr[37] + sum[36];//$display ("sum[36]= %d",sum[36]);
sum[38]= pr[38] + sum[37];
sum[39]= pr[39] + sum[38];
sum[40]= pr[40] + sum[39];
sum[41]= pr[41] + sum[40];
sum[42]= pr[42] + sum[41]; //$display("sum[42]= %d",sum[42]);
end

always @(negedge clk or posedge reset)
begin
if (reset) begin
flagin4 <= #1 0;
sumout <= #1 64'd0; end
else if (flagin3 == 1)begin
flagin4 <= #1 flagin3;
sumout <= #1 sum[42]; end
else flagin4 <= #1 0;
end

assign dout=sumout[39:8];
//assign dout=sumout[31:0];
//assign dout={{12{sumout[28]}},sumout[27:8]};
//assign dout=sumout;
assign flagout=flagin4;

endmodule
