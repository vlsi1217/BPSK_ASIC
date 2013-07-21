//Apr 14
//Cum with me 5

//Apr 20
//Apr 22: modify according to NCO_Raguu to sync with flag_in

module multi_post(reset, flag_in, flag_out, clk, ADC, IQ, dout);
input [31:0] ADC, IQ;  // (8.24)*(8.24)=(16.48)
input flag_in;
input clk, reset;
output reg signed [31:0] dout;  // (16.16)
output flag_out;

reg [1:0] flag_out_reg;
reg signed [63:0] dout_reg;
reg signed [31:0] dout_reg1, dout_reg2;
reg signed [31:0] ADC_in, IQ_arm;

always @(negedge (clk) or posedge (reset))
 begin :block1
	 if (reset) begin
		ADC_in<= #1 0;
		IQ_arm<= #1 0;
		flag_out_reg[0] <= #1 0;
	 end else if (flag_in==1) begin
	   ADC_in<= #1 ADC;
	   IQ_arm<= #1 IQ;
	   flag_out_reg[0] <= #1 flag_in;
	 end else
	   flag_out_reg[0] <= #1 0;
 end  


always @ (negedge (clk) or posedge (reset))
begin: block2
	 if (reset) begin
		dout<= #1 0;
		flag_out_reg[1] <= #1 0;
	 end else if (flag_out_reg[0]==1)begin
		dout<= #1 dout_reg1;
		flag_out_reg[1] <= #1 flag_out_reg[0];
	 end else flag_out_reg[1] <= #1 0;
end 

		 
always @(*) begin
 dout_reg = ADC_in*IQ_arm;
 //dout_reg1 = {{16{dout_reg[48]}},dout_reg[47:32]};
 dout_reg1 = dout_reg[51:20];
 //dout_reg1 = {{12{dout_reg[40]}},dout_reg[39:20]}; //12.20
 //dout_reg2 = {{16{dout_reg1[40]}},dout_reg1[39:24]};
end	 

assign flag_out = flag_out_reg[1];
	 
endmodule

