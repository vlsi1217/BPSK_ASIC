/*
Version: May10 ver 0.2

time: May 10, 2013 1:22 AM;
Addr: Lab E289
ref: http://electrosofts.com/verilog/fifo.html;
ref: http://electrosofts.com/verilog/fsm.html          case statement inside always posedge clk
ref: HW_FIFO_DONE
proj: FIFO after match filter to find:
      1. Byte;
      2. pushByte
      3. Sync
      4. lastByte.
*/

////////////////////////////////////////
/*
idea: along with 8 bit data, I put 2 bit at MSB:
  {flag2_reg[1], eofinin, data[7:0]}
  if the two flags is valid, then 1, otherwise 0;
  else if Sync(when peak detected), set as:
  {2'b11, data[7:0]}
*/
/////////////////////////////////////////
`timescale 1ns/10ps

module fifo (clk,reset,din, flagin, syncin, eofin, Byte, pushByte, Sync, lastByte, stopin);

// input is from match filter: flag2_reg[1], sync, eofinin, dout;
// output is Byte, pushByte, Sync, lastByte;

input clk, reset, stopin,eofin;//, push, pull;
input [7:0] din;
input flagin, syncin;

output reg [7:0] Byte;
output reg Sync, pushByte, lastByte;
//output reg Sync; 

//reg [9:0] fifo [0:1];
reg [9:0] fifo [0:1023];  //1k FIFO
reg [3:0] temp;
reg empty_reg, full_reg;

////////////////////////////////////////////////////
//pointers for reading and writing
reg [9:0] read_ptr, write_ptr;
reg [9:0]	cnt;//flag for the 1st byte
reg first;
//reg [9:0] tony_w, tony_r;//see if I can write in FIFO (Yes, I can)
			 //But I cannot read from FIFO
//reg [9:0] tony_read_ptr;
//reg [9:0] tony_write_ptr;

assign full = full_reg;
assign empty = empty_reg;
//reg full, empty;


always @(*)
begin
   empty_reg = (write_ptr == read_ptr + 1)?1:0;
   full_reg = (read_ptr == write_ptr + 1)?1:0;
end
/*
always @(negedge clk or negedge reset)
begin
if(reset) begin
	full <= 0;
    empty <= 0;
end else begin
	full <= #0 full_reg;
    empty <= #0 empty_reg;
end
end
*/
// write_ptr operation
always @(negedge (clk) or posedge (reset))
begin
if(reset) begin
	write_ptr <= #0 0;
end
else begin 
if  ((flagin && ~full) || (eofin && ~full))
	write_ptr <= #0 write_ptr + 1 ;
end
end

// read_ptr operation
always @(negedge (clk) or posedge (reset)) begin         //read operation
if (reset) 
	read_ptr <= #0 0;
else 
	read_ptr <= #0 (~empty && ~stopin && (write_ptr >= (read_ptr+2))) ? read_ptr + 1: read_ptr;
end

initial begin
	cnt = 0;
end
always @ (flagin || eofin) begin
	if (flagin == 1) begin
		cnt = cnt + 1;
	end else if (eofin == 1) begin
		cnt = 0;
	end else
		cnt = cnt;
end

always @ (*) begin 
   if (cnt == 1 && flagin) begin
	first =  1;
   end else
	first =  0;
end

////////////////////////////////////////////////////
// for write operation
always @(negedge (clk) or posedge (reset))
begin: block1 //block1 is to read data into 2 cell FIFO
integer i;
   if( reset ) begin
   		for(i=0; i<1024; i=i+1) begin
   			fifo[write_ptr] <= #0  0;
			//tony_w <= #0  0;
  		end 
   end else if  ((flagin && ~full) || (eofin && ~full) ) begin
  			fifo[write_ptr] <= #0  {first,eofin,din[7:0]};   //change!!
			//tony_w <= #0  {first,eofin,din[7:0]};
			//tony_write_ptr <= #0  write_ptr;
   end
end

///////////////////////////////////////////////////
// for read operation
/*
always @ (*)begin
	if (~empty && ~stopin && read_ptr!=0) begin
		//tony_r =  fifo[read_ptr][7:0];
		Byte =  fifo[read_ptr][7:0]; //changes
		//tony_read_ptr = read_ptr;
	end
end
*/
always @(negedge (clk) or posedge (reset))
begin: block2 //block1 is to read data into 2 cell FIFO
   if( reset ) begin
   		Sync <= #0  0;
	 	pushByte <= #0  0;
		lastByte <= #0  0;
		Byte <= #0 0;
  // end else if (~empty && ~stopin && read_ptr!=0) begin
  //end else if (~empty && ~stopin && (write_ptr > read_ptr)) begin
	end else if (empty == 0 && stopin == 0 ) begin
		Sync <= #0 (fifo[read_ptr][9:8]==2'b10)?1:0; //changes 
		//Sync <= #0  (fifo[read_ptr][9:8] != 2'b11)?1:0;		
		//pushByte <= #0  (~fifo[raead_ptr][9])?1:0;  //changes
   		pushByte <= #0 ((fifo[read_ptr][9:8] == 2'b10)||(fifo[read_ptr][9:8] == 2'b00) && (read_ptr >0))?1:0;
   		//lastByte <= #0  ((fifo[write_ptr][9:8] == 2'b01) && (read_ptr >0))?1:0;
   		lastByte <= #0 ((fifo[read_ptr+1][9:8] == 2'b01) && (read_ptr >0)) ?1:0;  //changes
   		//lastByte <= #0 ((fifo[write_ptr][9:8] == 2'b01) && (read_ptr >0)) ?1:0;
   		Byte <= #0 fifo[read_ptr][7:0];
		//tony_r <= #0 fifo[read_ptr][7:0];
   end else begin
   		Sync <= #0  0;
	 	pushByte <= #0  0;
		lastByte <= #0  0;
		Byte <= #0 Byte;
   end
end

endmodule



