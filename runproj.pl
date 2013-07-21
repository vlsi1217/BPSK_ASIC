#!/usr/bin/perl

use Getopt::Long;

@smod = ();
$vcomm="";
@uname = ();
@uid = ();
$clkperiod = 5;
$cdly2 = "";
$debug = '';
$synthesis = '';

sub buildNames
{
  my $fn=shift(@_);
  my $w;
  if(-e $fn) {
    open(fsname,"<",$fn) or die "Couldn't open the student ID file %s\n",$fn;
    my $i=0;
    for( $i=0; $i < 3; $i++) {
      $w = <fsname> or die "Couldn't read a name from the student id file \n";
      chomp($w);
      push(@name,$w);
      $w = <fsname>;
      chomp($w);
      push(@uid,$w);
    }
    close(fsname);
    return 1;
  }
  printf "Enter the name of the first student on the project\n";
  my $nm = <stdin>;
  chomp($nm);
  push(@name,$nm);
  printf "Enter the last 4 digits of the SJSU ID for the first student on the project\n";
  my $sn = <stdin>;
  chomp($sn);
  push(@uid,$sn);
  printf "Enter the name of the second student on the project\n";
  my $nm = <stdin>;
  chomp($nm);
  push(@name,$nm);
  printf "Enter the last 4 digits of the SJSU ID for the second student on the project\n";
  my $sn = <stdin>;
  chomp($sn);
  push(@uid,$sn);
  printf "Enter the name of the third student on the project (If none, enter none)\n";
  my $nm = <stdin>;
  chomp($nm);
  push(@name,$nm);
  printf "Enter the last 4 digits of the SJSU ID for the third student on the project(If none, enter 1234)\n";
  my $sn = <stdin>;
  chomp($sn);
  push(@uid,$sn);
  open(fsname,">",$fn) or die "Couldn't open the student name file %s\n",$fn;
   my $i;
   for( $i=0; $i<3; $i++ ) {
     printf fsname "%s\n%d\n",@name[$i],@uid[$i];
   }
  close(fsname);
}


sub buildFile 
{
  my $fn=shift(@_);
  my $fxx="frexxx";

  if(-e $fn) { 
    open(fmkfl,"<",$fn) or die "Couldn't open input file %s\n",$fn;
    $vcomm = <fmkfl> or die "Couldn't read costas name from file %s\n",fn;
    chomp($vcomm);
    do {
      $fxx = <fmkfl> or die "End of file getting module names\n";
      chomp($fxx);
      printf "file name -%s-\n",$fxx;
      if($fxx ne "end") { push(@smod, $fxx); }
    } while($fxx ne "end");
    close(fmkfl);
    return (1); 
  }
  printf "Please enter your costas module name (costas.v)\n";
  $vcomm = <stdin>;
  chomp($vcomm) ;
  if($vcomm == "") {
   $vcomm = "costas.v";
  }
  do {
    printf "Please enter any submodules of costas in hierarchy order\nif finished, please enter   end\n";
    $fxx = <stdin>;
    chomp($fxx);
    if($fxx ne "end") { push(@smod, $fxx); }
  } while($fxx ne "end");
  open(fmkfl,">",$fn) or die "Couldn't open file list %s\n",$fn;
  printf fmkfl "%s\n",$vcomm;
  foreach $sn ( @smod ) {
   printf fmkfl "%s\n",$sn;
  }
  printf fmkfl "end\n";
  close(fmkfl);
  return 4;
}
sub makeVcsFiles {
open(vf,">","vcs_files.f");
foreach $ix (@smod) {
  printf vf "%s\n",$ix;
}
printf vf "/home/morris/costas/tcostas.v\n%s\n",$vcomm;
printf vf "top.v\n";
close(vf);
}
sub maketop {
  my $gates=shift(@_);
  my $loops=shift(@_);
  open(tf,">","top.v");
  printf tf "// This is the top level file for testing the costas loop...
//
\`timescale 1ns/10ps

module top;

wire clk,reset,pushADC,pushByte,Sync,lastByte,stopIn;
wire [9:0] ADC;
wire [7:0] Byte;
wire [31:0] maxCycles;
integer sid0=1234;
integer sid1=4567;
integer sid2=8910;
reg [31:0] cycleCnt=0;
reg gates=$gates;

tcostas t(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn,
	sid0,sid1,sid2,gates,maxCycles,
	$loops);
	
costas c(clk,reset,pushADC,ADC,pushByte,Byte,Sync,lastByte,stopIn);

initial begin
";
 printf tf " \$dumpfile(\"costas.vcd\");
 \$dumpvars(9,top);
" if ($debug);
printf tf "
 #10;
 while(cycleCnt < maxCycles) begin
   @(negedge(clk));
   cycleCnt=cycleCnt+1;
 end
 \$display(\"Ran out of time waiting for the results\");
 #10;
 \$finish;

end


endmodule
";
  close(tf);
}

sub makesynscript{
open(sf,">","synthesis.script") or die "\n\n\nFAILED --- Couldn't open the synthesis script for editing\n";
printf sf "set link_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25 /apps/synopsys/C-2009.06-SP2/libraries/syn/dw02.sldb /apps/synopsys/C-2009.06-SP2/libraries/syn/dw01.sldb }
set target_library {/apps/toshiba/sjsu/synopsys/tc240c/tc240c.db_NOMIN25}\n";
my $ix;
for $ix ( reverse @smod) {
if( $ix=~ m/DW0/ ) {} else {
  printf sf "read_verilog %s\n",$ix;
  printf sf "check_design\n";
  printf sf "create_clock clk -name clk -period %f\n",$clkperiod;
  printf sf "set_propagated_clock clk\n";
  printf sf "set_clock_uncertainty 0.35 clk
set_propagated_clock clk
dont_touch tc240c/CDLY2XL
dont_use tc240c/CFDN2QXL
dont_use tc240c/CFDN2XL
dont_use tc240c/CFDN1QXL
dont_use tc240c/CFDN*L
dont_use tc240c/CFDN*1
dont_use tc240c/CFDN*Q*
set_driving_cell -lib_cell CND2X1 [all_inputs]
set_drive 0 clk
set_input_delay 0.5 -clock clk [all_inputs]
set_output_delay 0.5 -clock clk [all_outputs]
set_fix_hold [ get_clocks clk ]
compile -map_effort medium
";
 }
}
printf sf "read_verilog %s\n",$vcomm;
printf sf "check_design\n";
printf sf "set_driving_cell -lib_cell CND2X1 [all_inputs]
set_drive 0 clk
set_dont_touch_network clk\n";
printf sf "create_clock clk -name clk -period %f\n",$clkperiod*0.95;
printf sf "set_propagated_clock clk
set_clock_uncertainty 0.35 clk
set_propagated_clock clk
dont_touch tc240c/CDLY2XL
dont_use tc240c/CFDN2QXL
dont_use tc240c/CFDN2XL
dont_use tc240c/CFDN1QXL
dont_use tc240c/CFDN*L
dont_use tc240c/CFDN*1
dont_use tc240c/CFDN*Q*
set_max_delay 50 -from reset
set_max_delay 5 -from pushADC
set_max_delay 5 -from ADC
set_max_delay 5 -to pushByte
set_max_delay 5 -to Byte
set_max_delay 5 -to Sync
set_max_delay 5 -to lastByte
set_max_delay 5 -from stopIn
set_fix_hold [ get_clocks clk ]
compile -map_effort medium
";
printf sf "create_clock clk -name clk -period %f\n",$clkperiod;
printf sf "set_propagated_clock clk
set_clock_uncertainty 0.35 clk
set_propagated_clock clk
update_timing
report -cell
report_timing -max_paths 10
write -hierarchy -format verilog -output costas_gates.v
quit
";
close(sf);


}
sub runiverilog{
maketop(1,5);
makeVcsFiles;
system("rm simres");
printf "The following simulation is slow...\n";
printf "Starting iverilog simulation... slow simulator, short test cases... Be patient\n";
printf "iverilog -f vcs_files.f ".$cdly2."\n";
system("iverilog -f vcs_files.f ".$cdly2)==0 or die "\n\n\n\nFailed icarus Verilog compile\n";
system("./a.out | tee simres")==0 or die "\n\nFailed icarus verilog run\n";
printf f "icarus Verilog finished";
system("grep -i 'Congratulations, you completed the simulation without error' simres")==0 
  or die "\n\n\n\nFAILED --- iverilog simulation didn't get correct results";
printf f "icarus Verilog completed OK\n";
system("rm a.out");

}
sub runvcs {
maketop(0,7);
makeVcsFiles;
printf f "vcs Simulation run on %s", `date`;
printf "Starting vcs simulation... Be patient\n";
printf "vcs +v2k -f vcs_files.f ".$cdly2."\n";
system("vcs +v2k -f vcs_files.f ".$cdly2)==0 or die "\n\n\n\nFAILED --- vcs compile failed (Verilog problem)";
printf f "VCS finished\n";
system("rm simres");
system("./simv | tee simres")==0 or die "\n\n\n\n\nFAILED --- simulation failed (Logic problem)";
printf f "simv finished\n";
system("grep -i 'Congratulations, you completed the simulation without error' simres")==0 or die "\n\n\n\nFAILED --- simulation didn't get correct results";
printf f " simulation OK\n";
system("rm simres");
system("rm synres.txt");
system("rm -rf simv csrc");
system("rm vcs_files.f");
}
sub runncverilog{
makeVcsFiles;
maketop(0,15);
my $ncv = "ncverilog +sv +access+r -f vcs_files.f";
for $ix (@smod) {
  $ncv = $ncv." ".$ix;
}
$ncv=$ncv." | tee simres";
printf f "NCverilog\n";
printf f "NCverilog Simulation run on %s", `date`;
printf "Starting NCverilog simulation... Fast simulator, large test cases... Be patient\n";
system($ncv);
system("grep -i 'Congratulations, you completed the simulation without error' simres")==0 or die "\n\n\n Failed --- ncverilog didn't get correct results";
printf f " simulation OK\n";

}

GetOptions("debug" => \$debug,
	   "synthesis" => \$synthesis );
($#ARGV >= 1 ) or die "Need the cycle time, and result name as parameters";
$clkperiod = $ARGV[0];
open(f,">",$ARGV[1]) or die "Couldn't open the output file";


if( -e "CDLY2XL.v" ) {
 print "setting the delay block in simulation\n";
 $cdly2=" CDLY2XL.v ";
} 
buildFile( "fnames.txt" );
printf "simulation files\n %s\n",$vcomm;
foreach $ix ( @smod ) {
  printf "    %s\n",$ix;
}
buildNames("snames.txt");
printf "Student names for this run\n";
for($i=0; $i < 3; $i++) {
  printf "%d %s\n",@uid[$i],@name[$i];
}
$vcomm_name = $vcomm;
$vcomm_name=~ s/.v// ;

printf f "Starting the run of the project cycle time %s\n",$ARGV[0] or die "\n\n\n\nFAILED --- didn't write\n\n\n";
printf f "Run on %s", `date`;
printf f "%s on %s\n", $ENV{"USER"}, $ENV{"HOSTNAME"};
if ( ! $synthesis ) {
printf f "Running simulation cases\n";
runncverilog;
runvcs;
runiverilog;
} else {
 printf f "Not running simulation\n";
}
makesynscript;
system("dc_shell -xg -f synthesis.script | tee synres.txt")==0 or die "\n\n\n\nFAILED --- synthesis failed";
printf f "synthesis ran\n";
system("grep '(MET)' synres.txt")==0 or die "\n\n\n\nFAILED --- Didn't find timing met condition";
system("grep -i error synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis contained errors";
system("grep -i latch synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis created latches";
system("grep -i violated synres.txt")!=0 or die "\n\n\n\nFAILED --- synthesis violated timing";
$tline = `grep Total synres.txt`;
chomp($tline);
@gates = split(" ",$tline);
$size = @gates[3];
printf f "Total gates %s\n", $size;
die "\n\n\nFAILED --- Number of gates too small, check warinings\n\n" if ($size < 80000.0);
printf f "Design synthesized OK\n";
system("rm command.log");
system("rm default.svf");
print "\n\nSynthesis results are in file synres.txt\n";
$aline = `/sbin/ifconfig | grep eth | grep Bcast`;
chomp($aline);
@astuff = split(" ",$aline);
printf f "%s\n",@astuff[1];
system("rm gatesim.res");
maketop(1,3);
system("ncverilog +libext+.tsbvlibp +access+r +sv -y /apps/toshiba/sjsu/verilog/tc240c top.v /home/morris/costas/tcostas.v costas_gates.v | tee gatesim.res");
system("grep -i 'Congratulations, you completed the simulation without error' gatesim.res")==0 or die "\n\n\n Failed --- ncverilog(gates) didn't get correct results";
$md5 = `cat runproj.pl | md5sum`;
chomp($md5);
printf f "NCverilog ran on the gates";
print "NCverilog ran on the gates";
printf f "%s %s %s\n", $md5 , $ENV{"USER"}, $ENV{"HOSTNAME"};
printf f "Completed %s", `date`;
close f;
print "Successful Completion of HW run\n";
printf "Run summary file is %s\n",$ARGV[2];
