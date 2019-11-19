vlib work

vlog -timescale 1ns/1ns FlappyBird.v

vsim ScoreBoard

log {/*}
add wave {/*}

force {score} 000001111
force {clk} 0 0, 1 10 -r 20;

run 100ns
