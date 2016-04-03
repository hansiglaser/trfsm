onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_transitionrow/Reset_n_i
add wave -noupdate /tb_transitionrow/CfgClk_i
add wave -noupdate /tb_transitionrow/CfgDataIn_i
add wave -noupdate /tb_transitionrow/CfgMode_i
add wave -noupdate /tb_transitionrow/CfgShift_i
add wave -noupdate /tb_transitionrow/Input_i
add wave -noupdate /tb_transitionrow/State_i
add wave -noupdate /tb_transitionrow/Match_o
add wave -noupdate /tb_transitionrow/NextState_o
add wave -noupdate /tb_transitionrow/Output_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18494 ns} 0}
configure wave -namecolwidth 235
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
WaveRestoreZoom {0 ns} {24193 ns}
