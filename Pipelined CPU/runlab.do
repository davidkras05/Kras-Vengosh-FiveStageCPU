# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./n_bit_2to1.sv"
vlog "./EX.sv"
vlog "./control_unit.sv"
vlog "./math.sv"
vlog "./instructmem.sv"
vlog "./datamem.sv"
vlog "./register_file/thirtytwo_1_mux.sv"
vlog "./register_file/register.sv"
vlog "./register_file/regfile.sv"
vlog "./register_file/loopedthirtytwo_mux.sv"
vlog "./register_file/five_thirtytwodecoder.sv"
vlog "./register_file/D_FF.sv"
vlog "./ALU/full_adder.sv"
vlog "./ALU/flags.sv"
vlog "./ALU/bitsliceALU.sv"
vlog "./ALU/ALU.sv"
vlog "./IF.sv"
vlog "./sixtyfourbit_fulladder.sv"
vlog "./ID.sv"
vlog "./WB.sv"
vlog "./pipelinedTop.sv"
vlog "./pipelined_tb.sv"
vlog "./IF_ID.sv"
vlog "./ID_EX.sv"
vlog "./EX_MEM.sv"
vlog "./MEM_WB.sv"
vlog "./forwardingUnit.sv"
vlog "./nbit_register.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work pipelined_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do benchmark4pipelined.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
