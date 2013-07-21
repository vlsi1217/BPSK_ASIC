BPSK_ASIC
=========

BPSK demodulator ASIC design with Toshiba 45nm lib in verilog for EE 287 Spring 2013

This is the class project for EE 287 SPring 2013



//------------------------------------------------------------//
There are 4 major stages:

1st stage: 
1. multiplier_pre: it is uesd to do multiplication in Sin and Cos arm; 
2. NCO: it is a numerical control oscillator as a feedback loop for the multipliers. Both Sin and Cos data are from table.v

2nd stage:
1. fir: it is a 43-tap FIR filters for Sin and Cos arm;

3rd stage:
1. Multiplier_post: it is used to combine both results out of Sin and Cos arm

4th stage:
1. mf: it is a match filter (simply a 500 units shift register to extract pos or neg peak)
2. fifo: it is a FIFO controller with 1k register which is used to function as a buffer so as to detect the specific signals: eofin, Byte, pushByte, Sync, lastByte.


//------------------------------------------------------------//
code discreption
1. costas.v 
2. top.v
3. encode.v
4. decode.v
5. Filter.v
6. march21.v
7. mult_pre_try.v
8. mult_post.v
9. nco_try.v
10. tcostas.v
11. tables.v