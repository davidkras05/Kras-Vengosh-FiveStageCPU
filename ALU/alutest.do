onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CNTRL /alustim/cntrl
add wave -noupdate -label A -radix unsigned /alustim/A
add wave -noupdate -label B -radix unsigned /alustim/B
add wave -noupdate -label result -radix unsigned /alustim/result
add wave -noupdate -label {negative FLAG} /alustim/negative
add wave -noupdate -label {zero FLAG} /alustim/zero
add wave -noupdate -label {overflow FLAG} /alustim/overflow
add wave -noupdate -label {carry_out FLAG} /alustim/carry_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10328536582 ps} 0} {{Cursor 2} {10136006313 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {9986980479 ps} {10423876091 ps}
