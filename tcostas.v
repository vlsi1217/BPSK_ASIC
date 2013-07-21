// This is the test bench for the costas loop decoder in the ee287 project
// for Spring 2013
// Author Morris Jones
//
`timescale 1ns/10ps


module tcostas(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn,
	sid0,sid1,sid2,gates,maxCycles,randomSets);
output clk,reset,pushADC;
output [9:0] ADC;
input pushByte,Sync,lastByte;
input [7:0] Byte;
output stopIn;
input [31:0] sid0,sid1,sid2;
integer rseed,sid0x,sid1x,sid2x;
input gates;
output [31:0] maxCycles;
input [31:0] randomSets;

reg [31:0] _maxCycles;
assign maxCycles=_maxCycles;

reg debug=1;
reg _clk;
assign clk=_clk;
reg adcpush;
assign pushADC=adcpush;
reg _reset;
assign reset=_reset;
reg [9:0]  sinangle;
assign ADC=sinangle;
reg _stopIn;
assign stopIn=_stopIn;

reg [9:0] xFifo[0:1024];
reg [9:0] xfh,xft;

reg bad=0;
integer qq,ix;

`include "tables.v"
`include "encode.v"

initial 
 begin
  #1;
  sid0x=sid0;
  sid1x=sid1;
  sid2x=sid2;
  rseed=sid0x*sid1x*sid2x+sid1x+sid2x+sid0x;
  qq=$random(rseed);
  for(ix=0; ix < (sid0%31); ix=ix+1) begin
    qq=$random;
  end
 end

function R1;
  input [2:0] junk;
  integer qq;
  begin
    qq=$random;
    R1=qq[15+junk];
  end
endfunction

initial begin
  _clk=0;
  forever begin
    #5 _clk=~_clk;
  end
end

task death;
 begin
   bad=1;
   #10;
   $display("Shutting down simulation with errors");
   $finish;
 end
endtask

reg [31:0] phase;
reg [31:0] acc;
reg [33:0] bitphase;
reg [32:0] sumacc;
reg bitValue;
reg bitNoise;
integer fdivcntr;
reg [15:0] sinvalue;
reg [9:0] dcnt;
integer sendlock;
reg [9:0] sendData;
integer sendCount;
reg rd;

task waitNoise;
begin
  while(!bitNoise) begin 
    @(negedge(clk));
    #1;
  end
end
endtask

initial begin
  phase=429496729;
  acc=0;
  bitValue=0;
  fdivcntr=0;
  bitNoise=0;
  dcnt=0;
  bitphase=0;
  sendlock=0;
  sendData=0;
  sendCount=0;
  xfh=0;
  xft=0;
  _maxCycles=5000;
end

task pushx;
input [9:0] data;
reg [9:0] wpn;
begin
  wpn=xfh+1;
  if(wpn == xft) begin
    $display("Get real morris, you overpushed the test case");
    $finish;
  end
  xFifo[xfh]=data;
  xfh=wpn;
end
endtask

task nextBitValue;
begin
  bitNoise=0;
  if(sendlock > 0) begin
    bitValue=0;
    sendlock=sendlock-1;
  end else begin
    if(sendCount > 0) begin
      bitValue=sendData[0];
      sendData=sendData >> 1;
      sendCount=sendCount-1;
    end else if(xfh != xft) begin
      sendData=xFifo[xft];
      xft=xft+1;
      bitValue=sendData[0];
      sendData=sendData >> 1;
      sendCount=9;
    end else begin
      bitNoise=1;
    end
  end
end
endtask

always @(negedge(clk) or posedge(reset)) begin
  if(reset) begin
   adcpush=#1 0;
   sinangle=#1 0;
   fdivcntr=#1 0;
  end else begin
   if(fdivcntr==19) begin
     adcpush=#1 1;
     fdivcntr= #1 0;
     sinvalue = sinTable(acc[31:22]);
     dcnt=dcnt+1;
     #1;
     sinangle=sinvalue[15:6];
     if(!bitValue) sinangle=-sinangle;
     if(bitNoise) sinangle = $random;
     sumacc={1'b0,acc}+{1'b0,phase}; 
     acc = #1 sumacc[31:0];
     bitphase=bitphase+phase;
     if(bitphase >= 34'h280000000) begin
       nextBitValue;
       bitphase= bitphase-34'h280000000;
     end
   end else begin
     fdivcntr=#1 fdivcntr+1;
     adcpush= #1 0;
   end
  end
end

reg pushFirst=0;
reg pushLast=0;

task addByteCycles;
input [31:0] cyclesToAdd;
begin
  cyclesToAdd=cyclesToAdd*5000;
  _maxCycles = _maxCycles+cyclesToAdd;
end
endtask

task pushSync;
begin
  rd=0;
  pushx(10'h0f9); // send the sync...
  pushx(10'h306);
  addByteCycles(2);
  pushFirst=1;	  // the next byte is the last one
end
endtask

task pushStop;
input integer nops;
integer iq;
begin
  if(rd == 0) begin
    pushx(10'h2bc);
  end else begin
    pushx(10'h143);
  end
  addByteCycles(2);
  for(iq=0; iq < nops; iq=iq+1) begin
    pushx(0);
  end
end
endtask

integer datacnt=0;

reg Ffirst[0:4095];
reg Flast[0:4095];
reg [7:0] Fdata[0:4095];
integer Fpos[0:4095];
reg [11:0] fh,ft;
integer stopCntr;


initial begin
  fh=0;
  ft=0;
  _stopIn=0;
  stopCntr=0;
end



always @(negedge(clk))begin
  #1;
  if(stopCntr>0) begin
    _stopIn=1;
    stopCntr=stopCntr-1;
  end else begin
    _stopIn=0;
    stopCntr=$random;
    if(stopCntr < 0) stopCntr= -stopCntr;
    stopCntr = stopCntr%11;    
  end
end

reg efirst,elast;
reg [7:0] edata;
integer epos;

always @(negedge(clk)) begin
  #0.05;
  if(pushByte==1 && _stopIn==0) begin
    if(fh == ft) begin
      $display("\n\n\n");
      $display("Error --- You pushed on the output when I expected nothing");
      death;
    end
    efirst=Ffirst[ft];
    elast =Flast[ft];
    edata =Fdata[ft];
    epos  =Fpos[ft];
    ft=ft+1;
    if(efirst !== Sync || elast !== lastByte || edata !== Byte) begin
      $display("\n\n\nError --- At transmitted data %d",epos);
      $display("Error --- Expected Sync %h Last %h Data %02h",efirst,elast,edata);
      $display("Error --- Received Sync %h Last %h Data %02h",Sync,lastByte,Byte);
      death;
    end else if(debug) begin
      $display("Received data at position %d correctly data=%02h",epos,edata);
    end
  end
end

reg [11:0] fnext;

task encodePushx;
input [7:0] data;
reg [9:0] fres;
reg rdin;
begin
 rdin=rd;
 {rd,fres}=encode(rd,data);
 if(debug) $display("Encoded %x to %x rd in %x rdout %x position %d",data,fres,rdin,rd,datacnt);
 pushx(fres);
 addByteCycles(1);
 fnext=fh+1;
 if(fnext==ft) begin
   $display("You overran the return FIFO morris... Bad professor");
   death;
 end
 
 
 
 Ffirst[fh]=pushFirst;
 Flast[fh]=pushLast;
 Fdata[fh]=data;
 Fpos[fh]=datacnt;
 fh=fnext;
 pushLast=0;
 pushFirst=0;
 datacnt=datacnt+1;
end
endtask

task waitDataBack;
begin
  if(debug) $display("Waiting for all previous data to come back");
  while(fh != ft) @(negedge(clk));
  if(debug) $display("All previous data back");
end
endtask

function [31:0] randMod;
input [31:0] modval;
reg [31:0] randval;
begin
  randval=$random;
  randMod=randval % modval;
end
endfunction

task sendRandTest;
integer bc;
integer np;
begin
  bc=randMod(35);
  if(randMod(2)) begin
    waitDataBack;
    bitNoise=1;
    np=randMod(237);
    if(debug) $display("Adding a noise period of %3d cycles",np);
    addByteCycles(np);
    while(np > 0) @(negedge(clk)) begin
      np=np-1;
    end
    sendlock=20;
    addByteCycles(20);
  end
  pushLast=0;
  pushSync;
  if(debug) $display("frame will have %3d bytes of data",bc);
  while(bc > 0) begin
    if(bc == 1) pushLast=1;
    encodePushx($random);
    bc=bc-1;
  end
  pushLast=0;
  pushStop(0);
end
endtask

integer tix;
initial begin
  _reset=1;
  repeat(10) @(negedge(clk));
  #1 _reset=0;
  bitNoise=1;
  addByteCycles(10);
  repeat(100) @(negedge(clk));
  pushSync;
  encodePushx(0);
  encodePushx(1);
  pushLast=1;
  encodePushx(2);
  pushStop(0);
  sendlock=20;
  addByteCycles(20);
  pushSync;
  pushLast=1;
  pushStop(1);
  waitNoise;
  bitNoise=1;
  addByteCycles(15);
  repeat(125) @(negedge(clk));
  pushSync;
  pushLast=1;
  encodePushx(8'h55);
  pushStop(1);
  waitNoise;
  addByteCycles(8);
  repeat(913) @(negedge(clk));
  waitDataBack;
  #1;
  if(!gates) begin
    if(debug) $display("Starting a frame of 00-ff");
    sendlock=20;
    addByteCycles(20);
    pushSync;
    for(tix=0; tix < 256; tix=tix+1) begin
      if(tix==255) pushLast=1;
      encodePushx(tix);
    end
    pushStop(1);
    waitNoise;
    for(tix=0; tix < randomSets; tix=tix+1) begin
      if(debug) $display("Starting a random test %2d",tix);
      sendRandTest;
    end
    waitDataBack;
  end
  $display("Congratulations, you completed the simulation without error");
  $finish;

end


endmodule

