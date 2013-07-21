function [4:0] dec5;
input [5:0] cdin;
begin
    case(cdin)
       6'b111001:    dec5=0;
       6'b101110:    dec5=1;
       6'b101101:    dec5=2;
       6'b100011:    dec5=3;
       6'b101011:    dec5=4;
       6'b100101:    dec5=5;
       6'b100110:    dec5=6;
       6'b000111:    dec5=7;
       6'b100111:    dec5=8;
       6'b101001:    dec5=9;
       6'b101010:    dec5=10;
       6'b001011:    dec5=11;
       6'b101100:    dec5=12;
       6'b001101:    dec5=13;
       6'b001110:    dec5=14;
       6'b111010:    dec5=15;
       6'b110110:    dec5=16;
       6'b110001:    dec5=17;
       6'b110010:    dec5=18;
       6'b010011:    dec5=19;
       6'b110100:    dec5=20;
       6'b010101:    dec5=21;
       6'b010110:    dec5=22;
       6'b010111:    dec5=23;
       6'b110011:    dec5=24;
       6'b011001:    dec5=25;
       6'b011010:    dec5=26;
       6'b011011:    dec5=27;
       6'b011100:    dec5=28;
       6'b011101:    dec5=29;
       6'b011110:    dec5=30;
       6'b110101:    dec5=31;
      6'b000110:    dec5=0;
      6'b010001:    dec5=1;
      6'b010010:    dec5=2;
      6'b010100:    dec5=4;
      6'b111000:    dec5=7;
      6'b011000:    dec5=8;
      6'b000101:    dec5=15;
      6'b001001:    dec5=16;
      6'b101000:    dec5=23;
      6'b001100:    dec5=24;
      6'b100100:    dec5=27;
      6'b100010:    dec5=29;
      6'b100001:    dec5=30;
      6'b001010:    dec5=31;
 endcase 
end
endfunction

function [2:0] dec3;
input [3:0] cdin;
begin
    case(cdin)
      4'b1101:    dec3=0;
      4'b1001:    dec3=1;
      4'b1010:    dec3=2;
      4'b0011:    dec3=3;
      4'b1011:    dec3=4;
      4'b0101:    dec3=5;
      4'b0110:    dec3=6;
      4'b0111:    dec3=7;
      4'b1110:    dec3=7;
      4'b0010:    dec3=0;
      4'b1100:    dec3=3;
      4'b0100:    dec3=4;
      4'b1000:    dec3=7;
      4'b0001:    dec3=7;
   
    endcase
end
endfunction

function [7:0] decode;
input [9:0] dataout;

reg [7:0] dox;
begin
  dox[4:0]= dec5(dataout[5:0]);
  dox[7:5]= dec3(dataout[9:6]);
  decode = dox;
 
end
endfunction



