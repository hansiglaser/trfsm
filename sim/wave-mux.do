onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_largemux/Inputs_i
add wave -noupdate /tb_largemux/Select_i
add wave -noupdate /tb_largemux/DUT/InputAnd_s
add wave -noupdate /tb_largemux/Output_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {653280 ns} 0}
configure wave -namecolwidth 182
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {798798 ns}
