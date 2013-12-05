#############################################################################
# Copy to your local directory and make appropriate modifications
#
# Mods required:
#  Update the myBlock variable
#  Update the create_clock commands
#  Update the constrants.
#
# Invoke with:
#  > dc_shell -topographical_mode -f dc_??????????.tcl
# -or-
#  > dc_shell --topographical_mode
#  dc_shell-t> source dc_?????????????.tcl
#
#############################################################################

# 2 MHz operation
set TARGET_FREQ .1
set CCT [expr (1 / $TARGET_FREQ) - 0.125]

set INPUT_EXT_DELAY  [expr 0.2 * $CCT]
set OUTPUT_EXT_DELAY [expr 0.1 * $CCT]

set use_pdb_lib_format true


#****************************************************************************
#
#   Define the libraries
#
#****************************************************************************

set synlib  "/usr/local/packages/synopsys_2009/syn/libraries/syn/dw_foundation.sldb"
set typlib  "/scratch/wodonnell/mp/Artisan/synopsys/typical.db"
set symbol_library "/scratch/wodonnell/mp/Artisan/symbols/synopsys/tsmc18.sdb"
set physical_library "/scratch/wodonnell/mp/Artisan/synopsys/tsmc18_6lm.pdb"
set vd_syndir "/scratch/wodonnell/soc/soc-project/dc/src/InitDecode.v29"
set vd_srcdir "/scratch/wodonnell/soc/soc-project/hls/src"

read_lib /scratch/wodonnell/mp/Artisan/synopsys/tsmc18_6lm.plib -no_warnings
read_lib /scratch/wodonnell/mp/Artisan/synopsys/typical.lib -no_warnings

set target_library $typlib ;

set synthetic_library  $synlib;

set link_library " * $typlib $synlib" ;

set command_log_file  "./command.log";

#****************************************************************************
#
#   Define the design
#
#****************************************************************************


set myBlock viterbi_decoder 		

# Define the Verilog files you are going to compile
set fileList [glob -directory $vd_syndir *.v]	


# Read all source files that need to be compiled

foreach file $fileList {
    read_file -format verilog $file
}

read_file -format verilog $vd_srcdir/memory.v
read_file -format verilog $vd_srcdir/top.v


# Link the design with the libraries.
link

# Make sure all components are unique (deprecated)			
#uniquify

#quit

#****************************************************************************
#
#   Create clock(s)
#
#****************************************************************************

create_clock -period $CCT [get_ports clk]
set_fix_hold clk



#****************************************************************************
#
#  Setup the input and output delays
#
#****************************************************************************

#set_input_delay	 -max  $INPUT_EXT_DELAY  -clock clk [remove_from_collection [all_inputs] [get_ports {chan_insert, fire,  ret, loop_ctr, ucode_cc, ucode_op, loop_cnt}]]

set_input_delay	 -max  $INPUT_EXT_DELAY  -clock clk [all_inputs]

#set_input_delay 1.2 -clock [get_clocks clk] [all_inputs]

set_input_delay -max  $INPUT_EXT_DELAY  -clock clk [remove_from_collection [all_inputs] [get_ports reset_b]]


set_output_delay -max  $OUTPUT_EXT_DELAY -clock clk [all_outputs] 


# set_multicycle_path 5 -from [all_inputs] -to clk 


#Set isolate ports on all inputs
#set_isolate_ports [all_inputs] -force 

#Set driving cell on all inputs
set_driving_cell -lib_cell INVX4 [all_inputs]

#Set isolate ports on all outputs
#set_isolate_ports [all_outputs] -force


#Set load on all outputs

set_load 0.020 [all_outputs]

#set_load 0.020 adder_out
#set_load 0.020 co1
#set_load 0.020 co2


#****************************************************************************
#
#  Set the area constraints
#
#****************************************************************************

set_max_area 5000

#****************************************************************************
#
#  Check design and compile
#
#****************************************************************************

check_design > ../reports/check_design.txt

#compile_ultra -area_high_effort_script
compile

#compile_ultra -incremental -area_high_effort_script

#compile_ultra -incremental -area_high_effort_script

#compile_ultra -incremental -area_high_effort_script

#compile_ultra -incremental -area_high_effort_script



#****************************************************************************
#
#  Write out data 
#
#****************************************************************************

# Write out the structural verilog netlist
write -format verilog -hierarchy -output ${myBlock}.gate.v

# Write out the structural netlist in DDC format
# This format contains much more information than just the netlist--it also
# contains some constraints, clocks, etc--and is a good (faster) starting
# point (source file) for later optimizations within Design Compiler/Vision

write -format ddc -hierarchy -output ${myBlock}_struct.ddc
write_sdf -version 2.1 ${myBlock}.sdf

write_sdc -version 1.7 ${myBlock}.sdc

write_link_library -output ${myBlock}.db -full_path_lib_names

#file mkdir report
#
report_timing -max 50 -path end -nosplit > ../reports/timing.txt
report_timing >> ../reports/timing.txt
report_power > ../reports/power.txt
report_cell > ../reports/cell.txt
report_area -nosplit -physical -hierarchy > ../reports/area.txt
quit


#****************************************************************************
#
#  Post Process the data for Global Timer
#
#****************************************************************************
#source ./getLibCellCount.tcl > getLibCellCount.log
#source ./genAtRat.tcl 



