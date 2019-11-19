vlib work

vlog -timescale 1ns/1ns Draw_Bird.v

vsim Draw_Bird

log {/*}
add wave {/*}

force {clk10} 0 0, 1 10 -r 20
force {clr} 1 0, 0 20, 1 40
force {game_over} 0 0;
force {up} 0 0, 1 300
force {down} 1 0, 0 300

run 500ns
