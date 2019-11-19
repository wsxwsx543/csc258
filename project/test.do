vlib work

vlog -timescale 1ns/1ns FlappyBird.v

vsim FlappyBird

log {/*}
add wave {/*}


# This test case is used for only going down.
# force {CLOCK_50} 0 0, 1 1 -r 2;
# force {clk10} 0 0, 1 10 -r 20;

# force {KEY[1]} 1 0, 0 20, 1 40;

# force {KEY[0]} 1;

# run 1700ns

#This test case is used for the bird can pass the first pillar.

force {CLOCK_50} 0 0, 1 1 -r 2;
force {clk10} 0 0, 1 10 -r 20;

force {KEY[1]} 1 0, 0 20, 1 40;

force {KEY[0]} 1 0, 0 440, 1 460, 0 480, 1 500, 0 520, 1 540, 0 560, 1 580, 0 600, 1 620, 0 640, 1 660, 0 680, 1 700, 0 720, 1 740, 0 760, 1 780, 0 800, 1 820, 0 840, 1 860, 0 880, 1 900, 0 920, 1 940, 0 960, 1 980, 0 1000, 1 1020, 0 1040, 1 1060, 0 1080, 1 1100, 0 1120, 1 1140, 0 1160, 1 1180, 0 1200, 1 1220, 0 1240, 1 1260, 0 1280, 1 1300, 0 1320, 1 1340, 0 1360, 1 1380, 0 1400

run 1500ns
