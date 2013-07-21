// This is the top level file for testing the costas loop...
//
`timescale 1ns/10ps

module top;

wire clk,reset,pushADC,pushByte,Sync,lastByte,stopIn;
wire [9:0] ADC;
wire [7:0] Byte;
wire [31:0] maxCycles;
integer sid0=1234;
integer sid1=4567;
integer sid2=8910;
reg [31:0] cycleCnt=0;
reg gates=1;

tcostas t(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn,
	sid0,sid1,sid2,gates,maxCycles,
	5);
	
costas c(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn);

initial begin

 #10;
 while(cycleCnt < maxCycles) begin
   @(negedge(clk));
   cycleCnt=cycleCnt+1;
 end
 $display("Ran out of time waiting for the results");
 #10;
 $finish;

end


endmodule
