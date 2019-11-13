vlib work

vlog -timescale 1ns/1ns part2.v

vsim datapath

log {/*}
add wave {/*}

force {clk} 0 0, 1 10 -r 20
force {clr} 101

force {data} 1010000
force {ldx} 1 0, 0 20
force {ldy} 0 0, 1 20, 0 40
force {ldclr} 0 0, 1 40, 0 60

force {en} 0 0, 1 60
force {resetn} 1 0, 0 180, 1 200

run 260ns
