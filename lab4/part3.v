module part3(SW, KEY, LEDR);
	input [3:0] KEY;
	input [9:0] SW;
	
	output [9:0] LEDR;
	
	wire clk, reset_n, shift, load_n, ASR;
	wire w_asr;
	wire [7:0] w;
	assign clk = KEY[0];
	assign load_n = KEY[1];
	assign shift = KEY[2];
	assign ASR = KEY[3];
	assign reset_n = SW[9];
	
	ASRcircuits asr(.ASR(ASR), .first(SW[7]), .m(w_asr));
	shifterBit shifter0(.in(w_asr), .shift(shift), .load_val(SW[7]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[7]));
	shifterBit shifter1(.in(w[7]), .shift(shift), .load_val(SW[6]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[6]));
	shifterBit shifter2(.in(w[6]), .shift(shift), .load_val(SW[5]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[5]));
	shifterBit shifter3(.in(w[5]), .shift(shift), .load_val(SW[4]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[4]));
	shifterBit shifter4(.in(w[4]), .shift(shift), .load_val(SW[3]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[3]));
	shifterBit shifter5(.in(w[3]), .shift(shift), .load_val(SW[2]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[2]));
	shifterBit shifter6(.in(w[2]), .shift(shift), .load_val(SW[1]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[1]));
	shifterBit shifter7(.in(w[1]), .shift(shift), .load_val(SW[0]), .load_n(load_n), .clock(clk), .reset_n(reset_n), .out(w[0]));
	
	assign LEDR[7:0] = w[7:0];
endmodule

module ASRcircuits(ASR, first, m);
	input ASR, first;
	output m;
	
	reg m;
	always @(*)
	begin
		if(ASR == 1'b1)
			m <= first;
		else
			m <= 1'b0;
	end
endmodule

module shifterBit(in, shift, load_val, load_n, clock, reset_n, out);
	input in, shift, load_val, load_n, clock, reset_n;
	output out;
	wire out_w;
	assign out_w = out;
	wire w1, w2;
	mux2to1 mux1(.x(out_w), .y(in), .s(shift), .m(w1));
	mux2to1 mux2(.x(load_val), .y(w1), .s(load_n), .m(w2));
	flipflop f(.d(w2), .q(out), .clock(clock), .reset_n(reset_n));
endmodule

module mux2to1(x, y, s, m);
	input x, y;
	input s;
	output m;
	
	assign m = x * ~s + y * s;
endmodule

module flipflop(d, q, clock, reset_n);
	input d;
	input clock;
	input reset_n;
	output q;
	
	reg q;
	always @(posedge clock)
	begin
		if(reset_n == 1'b0)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule
