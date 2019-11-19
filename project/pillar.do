vlib work

vlog -timescale 1ns/1ns Pillar.v

vsim Pillar

log {/*}
add wave {/*}

force {clk10} 0 0, 1 10 -r 20
force {clr} 1 0, 0 20, 1 40
force {game_over} 0

run 1400ns
