onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Outputs -label Enable /three_eight_tb/En
add wave -noupdate -group Outputs -label Input /three_eight_tb/input_test
add wave -noupdate -group Outputs -label Output /three_eight_tb/y
add wave -noupdate -expand -group {Second Layer First Dec} /three_eight_tb/DUT/first/A
add wave -noupdate -expand -group {Second Layer First Dec} /three_eight_tb/DUT/first/B
add wave -noupdate -expand -group {Second Layer First Dec} /three_eight_tb/DUT/first/En
add wave -noupdate -expand -group {Second Layer First Dec} /three_eight_tb/DUT/first/y
add wave -noupdate -expand -group {Second Layer Second Dec} /three_eight_tb/DUT/second/A
add wave -noupdate -expand -group {Second Layer Second Dec} /three_eight_tb/DUT/second/B
add wave -noupdate -expand -group {Second Layer Second Dec} /three_eight_tb/DUT/second/En
add wave -noupdate -expand -group {Second Layer Second Dec} /three_eight_tb/DUT/second/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9994 ps} 0}
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
WaveRestoreZoom {9040 ps} {11512 ps}
