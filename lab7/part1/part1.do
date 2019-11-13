vlib work


vlog -timescale 1ps/1ps ram32x4.v

vsim -L altera_mf_ver ram32x4

log {/*}
add wave {/*}

force {address} 01101 0, 01000 55, 10010 115 
force {clock} 0 0, 1 10 -r 20
force {data} 1010 0, 1111 35, 0000 55, 1001 115
force {wren} 0 0, 1 9 -r 20 

run 200ps
