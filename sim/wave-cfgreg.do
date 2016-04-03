onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_configregister/Reset_n_i
add wave -noupdate /tb_configregister/CfgClk_i
add wave -noupdate /tb_configregister/CfgDataIn_i
add wave -noupdate /tb_configregister/CfgDataOut_o
add wave -noupdate /tb_configregister/CfgMode_i
add wave -noupdate /tb_configregister/CfgShift_i
add wave -noupdate /tb_configregister/DUT/ValueShift
add wave -noupdate /tb_configregister/Output_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {22625 ns} 0}
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
configure wave -timelineunits ms
update
WaveRestoreZoom {0 ns} {22807 ns}
