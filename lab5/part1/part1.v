module part1(SW, KEY, HEX0, HEX1);
	input [9:0] SW;
	input [3:0] KEY;
	
	output [6:0] HEX0;
	output [6:0] HEX1;
	
	wire clk;
	wire enable, clear;
	wire [7:0] out;
	
	assign clk = KEY[0];
	assign enable = SW[1];
	assign clear = SW[0];
	
	counter8 cnt(.enable(enable), .clear(clear), .clock(clk), .out(out));
	
	ShowHex showHex0(.bits(out[7:4]), .Hex(HEX0));
	ShowHex showHex1(.bits(out[3:0]), .Hex(HEX1));
endmodule

module counter8(enable, clear, clock, out);
	input enable, clear, clock;
	output [7:0] out;
	
	wire [7:0] w;
	MyTFF tff0(.t(enable), .clock(clock), .clear(clear), .q(out[0]));
	assign w[0] = enable & out[0];
	MyTFF tff1(.t(w[0]), .clock(clock), .clear(clear), .q(out[1]));
	assign w[1] = w[0] & out[1];
	MyTFF tff2(.t(w[1]), .clock(clock), .clear(clear), .q(out[2]));
	assign w[2] = w[1] & out[2];
	MyTFF tff3(.t(w[2]), .clock(clock), .clear(clear), .q(out[3]));
	assign w[3] = w[2] & out[3];
	MyTFF tff4(.t(w[3]), .clock(clock), .clear(clear), .q(out[4]));
	assign w[4] = w[3] & out[4];
	MyTFF tff5(.t(w[4]), .clock(clock), .clear(clear), .q(out[5]));
	assign w[5] = w[4] & out[5];
	MyTFF tff6(.t(w[5]), .clock(clock), .clear(clear), .q(out[6]));
	assign w[6] = w[5] & out[6];
	MyTFF tff7(.t(w[6]), .clock(clock), .clear(clear), .q(out[7]));
endmodule	

module MyTFF(t, clock, clear, q);
	input t, clock, clear;
	output q;
	
	reg q;
	
	always @(posedge clock or negedge clear)
	begin
		if (clear == 1'b0)
			q <= 1'b0;
		else if(t == 1'b1)
			q <= ~q;
	end
endmodule

module ShowHex(bits, Hex);
	input [3:0] bits;
	output [6:0] Hex;

	Zero zero(.a(bits[3]),
			    .b(bits[2]), 
			    .c(bits[1]), 
				 .d(bits[0]),
				 .ret(Hex[0]));
	One one(.a(bits[3]),
			  .b(bits[2]), 
			  .c(bits[1]), 
			  .d(bits[0]),
			  .ret(Hex[1]));
	Two two(.a(bits[3]),
			  .b(bits[2]), 
			  .c(bits[1]), 
			  .d(bits[0]),
			  .ret(Hex[2]));
	Three three(.a(bits[3]),
		         .b(bits[2]), 
					.c(bits[1]), 
					.d(bits[0]),
					.ret(Hex[3]));
	Four four(.a(bits[3]),
				 .b(bits[2]), 
				 .c(bits[1]), 
				 .d(bits[0]),
				 .ret(Hex[4]));
	Five five(.a(bits[3]),
		       .b(bits[2]), 
				 .c(bits[1]), 
				 .d(bits[0]),
		  .ret(Hex[5]));
	Six six(.a(bits[3]),
		     .b(bits[2]), 
		     .c(bits[1]), 
		     .d(bits[0]),
		     .ret(Hex[6]));
endmodule
		 

module Zero(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & ~b & ~c & d | ~a & b & ~c & ~d | a & ~b & c & d | a & b & ~c & d;
endmodule


module One(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & b & ~c & d | a & b & ~c & ~d | a & c & d | b & c & ~d;
endmodule


module Two(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = a & b & ~c & ~d | ~a & ~b & c & ~d | a & b & c;
endmodule


module Three(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & b & ~c & ~d | ~b & ~c & d | b & c & d | a & ~b & c & ~d;
endmodule


module Four(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & b & ~c | ~a & c & d | ~b & ~c & d;
endmodule


module Five(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & ~b & ~c & d | a & b & ~c & d | ~a & ~b & c & ~d | ~a & c & d;
endmodule


module Six(a, b, c, d, ret);
	input a, b, c, d;
	output ret;
	assign ret = ~a & b & c & d | a & b & ~c & ~d | ~a & ~b & ~c;
endmodule