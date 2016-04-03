onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_trfsm/Reset_n_i
add wave -noupdate /tb_trfsm/Clk_i
add wave -noupdate /tb_trfsm/CfgClk_i
add wave -noupdate /tb_trfsm/CfgDataIn_i
add wave -noupdate /tb_trfsm/CfgDataOut_o
add wave -noupdate /tb_trfsm/CfgMode_i
add wave -noupdate /tb_trfsm/CfgShift_i
add wave -noupdate /tb_trfsm/Input_i
add wave -noupdate /tb_trfsm/Output_o
add wave -noupdate /tb_trfsm/TRFSM_1/State_s
add wave -noupdate /tb_trfsm/TRFSM_1/NextState_s
add wave -noupdate /tb_trfsm/TRFSM_1/RowMatch_s
add wave -noupdate /tb_trfsm/TRFSM_1/RowNextState_s
add wave -noupdate /tb_trfsm/TRFSM_1/RowOutput_s
add wave -noupdate /tb_trfsm/TRFSM_1/RowOutputVec_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {184754 ns} 0}
configure wave -namecolwidth 262
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
WaveRestoreZoom {0 ns} {198192 ns}
