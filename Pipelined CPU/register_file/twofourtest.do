onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Outputs /two_four_tb/input_test
add wave -noupdate -group Outputs /two_four_tb/En
add wave -noupdate -group Outputs /two_four_tb/y
add wave -noupdate -expand -group {Second Layer First Dec} /two_four_tb/DUT/first/A
add wave -noupdate -expand -group {Second Layer First Dec} /two_four_tb/DUT/first/En
add wave -noupdate -expand -group {Second Layer First Dec} /two_four_tb/DUT/first/y
add wave -noupdate -expand -group {Second Layer Second Dec} /two_four_tb/DUT/second/A
add wave -noupdate -expand -group {Second Layer Second Dec} /two_four_tb/DUT/second/En
add wave -noupdate -expand -group {Second Layer Second Dec} /two_four_tb/DUT/second/y
add wave -noupdate -expand -group {Enable Dec} /two_four_tb/DUT/en_dec/A
add wave -noupdate -expand -group {Enable Dec} /two_four_tb/DUT/en_dec/En
add wave -noupdate -expand -group {Enable Dec} /two_four_tb/DUT/en_dec/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4900 ps} 0}
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
WaveRestoreZoom {0 ps} {6646 ps}
