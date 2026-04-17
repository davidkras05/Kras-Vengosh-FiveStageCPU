onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CNTRL -expand /alustim/cntrl
add wave -noupdate -label A -radix unsigned /alustim/A
add wave -noupdate -label B -radix unsigned /alustim/B
add wave -noupdate -label result -radix decimal /alustim/result
add wave -noupdate -label {negative FLAG} /alustim/negative
add wave -noupdate -label {zero FLAG} /alustim/zero
add wave -noupdate -label {overflow FLAG} /alustim/overflow
add wave -noupdate -label {carry_out FLAG} /alustim/carry_out
add wave -noupdate -expand -group {XOR Test} {/alustim/dut/body_ALUs[63]/body/B}
add wave -noupdate -expand -group {XOR Test} {/alustim/cntrl[0]}
add wave -noupdate -expand -group {XOR Test} {/alustim/dut/body_ALUs[63]/body/B_add_sub}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10328536582 ps} 0} {{Cursor 2} {9674061 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {9429336 ps} {10647178 ps}
