vlib work

vlog -timescale 1ns/1ns part2.v

vsim control

log {/*}
add wave {/*}

force {clk} 0 0, 1 10 -r 20
force {resetn} 1 0, 0 20, 1 40
force {go1} 1 0, 0 60, 1 80
force {go2} 1 0, 0 120, 1 140

run 500ns
