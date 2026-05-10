onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /singleCycle_tb/clk
add wave -noupdate /singleCycle_tb/reset
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/ALUOp
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/ALUSrc
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/BrTaken
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/IsBL
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/IsBR
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/Mem2Reg
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/MemRead
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/MemWrite
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/NegativeFlag
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/Reg2Loc
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/RegWrite
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/SetFlags
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/UncondBr
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/ZeroFlag
add wave -noupdate -group {Control Signals} -color Gold /singleCycle_tb/DUT/control/xfer_size
add wave -noupdate -group IF /singleCycle_tb/DUT/instructionFetch/CurrPC
add wave -noupdate -group IF /singleCycle_tb/DUT/instruction
add wave -noupdate -group ID /singleCycle_tb/DUT/instructionDecode/Rd
add wave -noupdate -group ID /singleCycle_tb/DUT/instructionDecode/Rm
add wave -noupdate -group ID /singleCycle_tb/DUT/instructionDecode/Rn
add wave -noupdate -group ID /singleCycle_tb/DUT/instructionDecode/Aw_in
add wave -noupdate -group ID /singleCycle_tb/DUT/instructionDecode/Dw_in
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/ALUIn0
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/ALUIn1
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/NegativeFlag
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/ZeroFlag
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/BrAddr26
add wave -noupdate -group EX /singleCycle_tb/DUT/execution/CondAddr19
add wave -noupdate -group MEM /singleCycle_tb/DUT/MEM/address
add wave -noupdate -group MEM /singleCycle_tb/DUT/MEM/write_data
add wave -noupdate -group WB /singleCycle_tb/DUT/writeBack/ALURes
add wave -noupdate -group WB /singleCycle_tb/DUT/writeBack/MEMData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
