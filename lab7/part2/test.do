vlib work

vlog -timescale 1ns/1ns part2.v

vsim test

log {/*}
add wave {/*}

force {clk} 0 0, 1 10 -r 20
force {resetn} 1 0, 0 20, 1 40
force {data} 0000001 0, 0000010 90
force {clr} 110
force {go1} 1 0, 0 60, 1 80 
force {go2} 1 0, 0 120, 1 140

run 260ns 
