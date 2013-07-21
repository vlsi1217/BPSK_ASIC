// This is the encoding table for the 8 to 10 bit encoding. Note the order is backwards
// on the wiki, and I have switched it here.

function [6:0] enc5;
input rd;
input [4:0] cdin;
begin
  if(rd==0) begin
    case(cdin)
      0:  enc5=7'b1111001;
      1:  enc5=7'b1101110;
      2:  enc5=7'b1101101;
      3:  enc5=7'b0100011;
      4:  enc5=7'b1101011;
      5:  enc5=7'b0100101;
      6:  enc5=7'b0100110;
      7:  enc5=7'b0000111;
      8:  enc5=7'b1100111;
      9:  enc5=7'b0101001;
      10: enc5=7'b0101010;
      11: enc5=7'b0001011;
      12: enc5=7'b0101100;
      13: enc5=7'b0001101;
      14: enc5=7'b0001110;
      15: enc5=7'b1111010;
      16: enc5=7'b1110110;
      17: enc5=7'b0110001;
      18: enc5=7'b0110010;
      19: enc5=7'b0010011;
      20: enc5=7'b0110100;
      21: enc5=7'b0010101;
      22: enc5=7'b0010110;
      23: enc5=7'b1010111;
      24: enc5=7'b1110011;
      25: enc5=7'b0011001;
      26: enc5=7'b0011010;
      27: enc5=7'b1011011;
      28: enc5=7'b0011100;
      29: enc5=7'b1011101;
      30: enc5=7'b1011110;
      31: enc5=7'b1110101;
    endcase
  end else begin
    case(cdin)
      0:  enc5=7'b0000110;
      1:  enc5=7'b0010001;
      2:  enc5=7'b0010010;
      3:  enc5=7'b1100011;
      4:  enc5=7'b0010100;
      5:  enc5=7'b1100101;
      6:  enc5=7'b1100110;
      7:  enc5=7'b1111000;
      8:  enc5=7'b0011000;
      9:  enc5=7'b1101001;
      10: enc5=7'b1101010;
      11: enc5=7'b1001011;
      12: enc5=7'b1101100;
      13: enc5=7'b1001101;
      14: enc5=7'b1001110;
      15: enc5=7'b0000101;
      16: enc5=7'b0001001;
      17: enc5=7'b1110001;
      18: enc5=7'b1110010;
      19: enc5=7'b1010011;
      20: enc5=7'b1110100;
      21: enc5=7'b1010101;
      22: enc5=7'b1010110;
      23: enc5=7'b0101000;
      24: enc5=7'b0001100;
      25: enc5=7'b1011001;
      26: enc5=7'b1011010;
      27: enc5=7'b0100100;
      28: enc5=7'b1011100;
      29: enc5=7'b0100010;
      30: enc5=7'b0100001;
      31: enc5=7'b0001010;
    endcase  
  end
end
endfunction

function [4:0] enc3;
input rd;
input [2:0] cdin;
input [5:0] x;
begin
  if(rd==0) begin
    case(cdin)
      0: enc3=5'b11101;
      1: enc3=5'b01001;
      2: enc3=5'b01010;
      3: enc3=5'b00011;
      4: enc3=5'b11011;
      5: enc3=5'b00101;
      6: enc3=5'b00110;
      7: begin
        if(x==17 || x == 18 || x == 20) begin
          enc3=5'b10111;
        end else begin
          enc3=5'b11110;
        end
      end
    endcase
  end else begin
    case(cdin)
      0: enc3=5'b00010;
      1: enc3=5'b11001;
      2: enc3=5'b11010;
      3: enc3=5'b01100;
      4: enc3=5'b00100;
      5: enc3=5'b10101;
      6: enc3=5'b10110;
      7: begin
        if(x==11 || x == 13 || x == 14) begin
          enc3=5'b01000;
        end else begin
          enc3=5'b00001;
        end
      end
    endcase
  end
end

endfunction

function [10:0] encode;
input rd;
input [7:0] data;
reg rdx;
reg [9:0] dox;
begin
 {rdx,dox[5:0]}=enc5(rd,data[4:0]);
 {rdx,dox[9:6]}=enc3(rd,data[7:5],data[4:0]);
 encode={rdx,dox}; 
end
endfunction


