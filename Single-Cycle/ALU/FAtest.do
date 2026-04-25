onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {FA Outputs} -expand /full_adder_tb/in
add wave -noupdate -expand -group {FA Outputs} -radix unsigned /full_adder_tb/Cin
add wave -noupdate -expand -group {FA Outputs} -radix unsigned /full_adder_tb/Cout
add wave -noupdate -expand -group {FA Outputs} -radix unsigned /full_adder_tb/S
add wave -noupdate -expand -group {Internal Signals} -radix unsigned /full_adder_tb/dut/Cin_buf
add wave -noupdate -expand -group {Internal Signals} -radix unsigned /full_adder_tb/dut/Cout_term_2
add wave -noupdate -expand -group {Must be synced} -radix unsigned /full_adder_tb/dut/Cout_term_3
add wave -noupdate -expand -group {Must be synced} -radix unsigned /full_adder_tb/dut/Cout_term_1_buf
add wave -noupdate -radix unsigned /full_adder_tb/dut/Cout_term_1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3141102 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {4200 ns}
