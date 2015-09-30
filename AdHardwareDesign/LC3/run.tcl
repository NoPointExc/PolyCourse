# Modified from Erik Erik Brunvand's script (N. Sertac Artan, 2014)
# Synthesize executing the following command at command prompt:
# rc -f THIS_FILE_NAME
# You can also show the gui executing the following command at command prompt:
# rc -gui -f THIS_FILE_NAME
######################################################
# Script for Cadence RTL Compiler synthesis      
# Erik Brunvand, 2008
# Replace items inside <> with your own information
######################################################

# Set the search paths to the libraries and the HDL files
# Remember that "." means your current directory. Add more directories
# after the . if you like. 
# This is the script we will use for synthesis. 
# More details to follow
# For now, note that we have listed fa.v as the file we eant to synthesize and fulladder as the topmodule
set_attribute hdl_search_path {./} 
set_attribute lib_search_path {/opt/cadence/local/ncsu-cdk-1.5.1-with-UofU/lib/UofU_Digital_v1_2/}
set_attribute library [list UofU_Digital_v1_2_modified.lib];
#set_attribute library [list UofU_Digital_v1_2_modified.lib]; # Use this modified library
							# instead if the mapping cannot be completed since a suitable 
							# cell is not available.
set_attribute information_level 6 

set myFiles [list fa.v]   ;# All your VHDL files
set basename  fulladder   ;# name of top level module
set myClk clk                  ;# clock signal name
set myPeriod_ps 5000            ;# Clock period in ps, 100 MHz
set clock_rise_fall_ns 0.04     ;# clock rise and fall times
set myInDelay_ns 25           ;# delay from clock to inputs valid
set myOutDelay_ns 25          ;# delay from clock to output valid
set runname RTL            ;# name appended to output files
set rundirname build_3	   ;# directory where the output files kept.



#*********************************************************
#*   below here shouldn't need to be changed...          *
#*********************************************************

# Analyze and Elaborate the HDL files
read_hdl -sv ${myFiles} ; # Remove the -vhdl flag if you'd like to synthesize Verilog files. use a flag for system verilog -sv
elaborate ${basename}

# Apply Constraints and generate clocks
set clock [define_clock -period ${myPeriod_ps} -name ${myClk} [clock_ports]]	
external_delay -input $myInDelay_ns -clock ${myClk} [find / -port ports_in/*]
external_delay -output $myOutDelay_ns -clock ${myClk} [find / -port ports_out/*]

# Sets transition to default values for Synopsys SDC format, 
dc::set_clock_transition ${clock_rise_fall_ns} $myClk

# check that the design is OK so far
check_design -unresolved
report timing -lint

# Synthesize the design to the target library
synthesize -to_mapped ; # -effort high -incremental

# Write out the reports
report timing > ${rundirname}/${basename}_${runname}_timing.rep
report gates  > ${rundirname}/${basename}_${runname}_cell.rep
report power  > ${rundirname}/${basename}_${runname}_power.rep

# Write out the structural Verilog and sdc files
write_hdl -mapped >  ${rundirname}/${basename}_${runname}.v
write_sdc >  ${rundirname}/${basename}_${runname}.sdc
# Write out the sdf file.
write_sdf >  ${rundirname}/${basename}_${runname}.sdf
