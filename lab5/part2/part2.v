module part2(HEX0, SW, CLOCK_50);
	input [3:0] SW;
	input CLOCK_50;

	output [6:0] HEX0;
	
	wire [27:0] load;
	wire en;
	wire [3:0] out;
	
	selectFrequency sf(.select(SW[1:0]), .frequency(load));
	rateDivider rd(.load(load), .enable(SW[2]), .clock(CLOCK_50), .reset(SW[3]), .q(en));
	displayCounter dc(.enable(en), .clock(CLOCK_50), .reset(SW[3]), .out(out));
	showHex sh(.bits(out), .Hex(HEX0));
endmodule

module selectFrequency(select, frequency);
	input [1:0] select;
	output reg [27:0] frequency;
		
	always @(*)
	begin
		case(select[1:0])
			2'b00: frequency = 28'd0;
			2'b01: frequency = 28'd49_999_999;
			2'b10: frequency = 28'd99_999_999;
			2'b11: frequency = 28'd199_999_999;
			default: frequency = 28'd0;
		endcase
	end
endmodule

module rateDivider(load, enable, clock, reset, q);
	input [27:0] load;
	input enable, clock, reset;
	output q;
	
	reg [27:0] out;
	
	always @(posedge clock)
	begin
		if(reset == 1'b0)
			out <= load[27:0];
		else if(enable == 1'b1)
		begin
			if(out == 28'd0)
				out <= load;
			else
				out = out - 1'b1;
		end
	end
	
	assign q = (out == 28'd0) ? 1 : 0;
endmodule

module displayCounter(enable, clock, reset, out);
	input enable, clock, reset;
	output reg [3:0] out;
	
	always @(posedge clock)
	begin
		if(reset == 1'b0)
			out <= 4'b0000;
		else if(enable == 1'b1)
		begin
			if(out == 4'b1111)
				out <= 4'b0000;
			else
				out <= out + 1'b1;
		end
	end
endmodule

module showHex(bits, Hex);
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
