# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./thirtytwo_1_mux.sv"
vlog "./regstim.sv"
vlog "./register.sv"
vlog "./loopedthirtytwo_mux.sv"
vlog "./five_thirtytwodecoder.sv"
vlog "./D_FF.sv"
vlog "./regfile.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work two_four_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do twofourtest.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
