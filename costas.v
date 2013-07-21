//Apr19 1:11AM

`timescale 1ns/10ps

`include "nco_try.v"
`include "mult_pre_try.v"
`include "mult_post.v"
`include "Filter.v"
`include "match21.v"
`include "fifo_V21.v"

module costas(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn);
input clk, reset, pushADC, stopIn;
input [9:0] ADC;
output [7:0] Byte;
output Sync, lastByte, pushByte;
wire flagout, mf_flagout;
wire [31:0] dout;
wire eof;
wire [15:0] cos, sin;
wire fo_I, fo_Q;
wire [31:0] mul_I,mul_Q;
wire [31:0] fir_Q, fir_I;
wire [7:0] mf_out;
wire fg_Q, fg_I;
wire fo_IQ;
wire [31:0] ph_err;

wire fg_nco, syncmf;//pushByte,sync,last;

wire flagout_nco;
wire [31:0] ou;
//1st stage: mQ, mI, NCO;
//module nco (clk,reset,diff,pushins,flagout,ou,sinvalue,cosvalue);
nco n(.clk(clk), .reset(reset),.diff(ph_err), .flagin(fo_IQ), .flagout(flagout_nco), .ou(ou), .sinvalue(sin), .cosvalue(cos));

//multi_pre mQ (.flag_in(pushADC),.flag_out(fo_Q), .clk(clk), .ADC({{16{ADC[9]}},ADC[8:0],7'b0}), .IQ({{16{sin[15]}},sin[15:0]}), .dout(mul_Q));

//multi_pre mI (.flag_in(pushADC),.flag_out(fo_I), .clk(clk), .ADC({{16{ADC[9]}},ADC[8:0],7'b0}), .IQ({{16{cos[15]}},cos[15:0]}), .dout(mul_I));

multi_pre mQ (.reset(reset),.flag_in(pushADC),.flag_out(fo_Q), .clk(clk), .ADC({{23{ADC[9]}},ADC[8:0]}), .IQ({{17{sin[15]}},sin[14:0]}), .dout(mul_Q));

multi_pre mI (.reset(reset),.flag_in(pushADC),.flag_out(fo_I), .clk(clk), .ADC({{23{ADC[9]}},ADC[8:0]}), .IQ({{17{cos[15]}},cos[14:0]}), .dout(mul_I));

//2nd stage: fQ, fI
//module fir( clk, reset, flag_in,din,dout, flag_out );
fir fQ (.clk(clk), .reset(reset), .flagin(fo_Q), .din(mul_Q), .dout(fir_Q), .flagout(fg_Q) );

fir fI (.clk(clk), .reset(reset), .flagin(fo_I), .din(mul_I), .dout(fir_I), .flagout(fg_I) );
//3rd stage: mIQ
//module multi_post(flag_in, flag_out, clk, fir_Q, fir_I, dout);
multi_post mIQ (.reset(reset),.flag_in(fg_Q && fg_I), .flag_out(fo_IQ), .clk(clk), .ADC(fir_Q), .IQ(fir_I), .dout(ph_err));

//Match filter: mfil       //start from Aaaapr 29 for sync to EOF to FIFO
mf mfil(.clk(clk), .reset(reset), .flagin(fg_I), .din(fir_I), .dout(mf_out), .flagout1(mf_flagout), .eof(eof), .sync(syncmf));
//fifo module fifo (clk,reset,din, flagin, syncin, eofin, Byte, pushByte, Sync, lastByte, stopin); 
fifo fifo (.clk(clk), .reset(reset), .din(mf_out), .flagin(mf_flagout), .syncin(syncmf), .eofin(eof), .Byte(Byte), .pushByte(pushByte), .Sync(Sync), .lastByte(lastByte), .stopin(stopIn));
endmodule
