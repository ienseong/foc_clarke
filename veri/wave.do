onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /jpl_foc_clarke_tb/B
add wave -noupdate /jpl_foc_clarke_tb/SYSCLK_PERIOD
add wave -noupdate -divider Inputs
add wave -noupdate /jpl_foc_clarke_tb/i_clk
add wave -noupdate /jpl_foc_clarke_tb/i_rst_n
add wave -noupdate /jpl_foc_clarke_tb/jpl_foc_clarke/i_start_clarke
add wave -noupdate -radix decimal /jpl_foc_clarke_tb/i_ia
add wave -noupdate -radix decimal /jpl_foc_clarke_tb/i_ib
add wave -noupdate -radix decimal /jpl_foc_clarke_tb/s_cnt_clk
add wave -noupdate -radix unsigned /jpl_foc_clarke_tb/jpl_foc_clarke/s_cnt_valid_i_clarke_raw
add wave -noupdate -radix decimal /jpl_foc_clarke_tb/jpl_foc_clarke/b_latched
add wave -noupdate /jpl_foc_clarke_tb/jpl_foc_clarke/b_latched_sum
add wave -noupdate -radix decimal /jpl_foc_clarke_tb/jpl_foc_clarke/b_latched_2
add wave -noupdate -divider Outputs
add wave -noupdate /jpl_foc_clarke_tb/jpl_foc_clarke/o_clarke_done
add wave -noupdate /jpl_foc_clarke_tb/o_ialpha
add wave -noupdate /jpl_foc_clarke_tb/o_ibeta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 182
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {231 ns}
