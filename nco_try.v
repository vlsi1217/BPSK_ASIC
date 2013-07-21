`timescale 1ns/10ps
module nco (clk,reset,diff,flagin,flagout,ou,sinvalue,cosvalue);
input [31:0]diff;
output[15:0]sinvalue,cosvalue;
input clk,reset;
output reg[31:0]ou;
output flagout;
input flagin;
reg flagina,flagina1;
reg [31:0]ou_reg;
wire [9:0]angle;
wire phase[31:0]; 

wire [31:0] out;

assign flagout = flagina1;

always @(negedge (clk) or posedge (reset)) begin
if (reset)begin
	ou <= #1 0;
	flagina <= #1 0;
end
else if (flagin==1)begin
	ou <= #1 ou_reg+32'd429496729+(diff<<3);
	flagina <= #1 flagin;
end
else flagina <= #1 0;
end

always @(negedge (clk) or posedge (reset)) begin
  if (reset) begin
    ou_reg <= #1 0; 
	flagina1 <= #1 0;
  end else if (flagina==1)begin
    ou_reg <= #1 ou;
	flagina1 <= #1 flagina;
  end
else flagina1 <= #1 0;
end

`include "tables.v"
assign angle = ou_reg[31:22];
assign out = scTable(angle);
assign sinvalue = out[31:16];
assign cosvalue = out[15:0];

endmodule 
