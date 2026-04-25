onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mux_8_1_tb/in
add wave -noupdate /mux_8_1_tb/s
add wave -noupdate /mux_8_1_tb/y
add wave -noupdate -expand -group {Sec Layer} /mux_8_1_tb/dut/sec_layer/in
add wave -noupdate -expand -group {Sec Layer} /mux_8_1_tb/dut/sec_layer/s
add wave -noupdate -expand -group {Sec Layer} /mux_8_1_tb/dut/sec_layer/y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2313 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 189
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
WaveRestoreZoom {1382 ps} {3760 ps}
