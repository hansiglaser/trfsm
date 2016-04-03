onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_inputswitchingmatrix/Reset_n
add wave -noupdate /tb_inputswitchingmatrix/CfgClk
add wave -noupdate /tb_inputswitchingmatrix/CfgDataIn
add wave -noupdate /tb_inputswitchingmatrix/CfgDataOut
add wave -noupdate /tb_inputswitchingmatrix/CfgMode
add wave -noupdate /tb_inputswitchingmatrix/CfgShift
add wave -noupdate /tb_inputswitchingmatrix/InputSwitchingMatrix_1/CfgValue
add wave -noupdate /tb_inputswitchingmatrix/Input
add wave -noupdate /tb_inputswitchingmatrix/Output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {708205 ns} 0}
configure wave -namecolwidth 263
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
WaveRestoreZoom {0 ns} {993427 ns}
