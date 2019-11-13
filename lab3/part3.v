module part3(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [9:0] SW;
	input [9:0] KEY;
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	wire [7:0] w;
	
	ALUFunctions alu(.A(SW[7:4]), .B(SW[3:0]), .functions(KEY[2:0]), .out(w[7:0]));
	assign LEDR[7:0] = w[7:0];
	
	ShowHex showhex0(SW[3:0], HEX0[6:0]);
	ShowHex showhex2(SW[7:4], HEX2[6:0]);
	ShowHex showhex1(4'b0000, HEX1[6:0]);
	ShowHex showhex3(4'b0000, HEX3[6:0]);
	ShowHex showhex4(w[3:0], HEX4[6:0]);
	ShowHex showhex5(w[7:4], HEX5[6:0]);
endmodule

module ALUFunctions(A, B, functions, out);
	input [3:0] A;
	input [3:0] B;
	input [2:0] functions;
	output [7:0] out;
	
	reg [7:0] out;
	wire [4:0] f0;
	wire [4:0] f1;
	
	FourRippleFullAdder frfa0(.A(A), .B(4'b0000), .Cin(1'b1), .Cout(f0[4]), .S(f0[3:0]));
	FourRippleFullAdder frfa1(.A(A), .B(B), .Cin(1'b0), .Cout(f1[4]), .S(f1[3:0]));
	
	always @(*)
	begin
		case (functions)
			3'b111: out = {3'b000, f0};
			3'b110: out = {3'b000, f1};
			3'b101: out = A + B;
			3'b100: out = {A | B, A ^ B};
			3'b011: out = |{A, B};
			3'b010: out = {A, B};
			default: out = 8'b00000000;
		endcase
	end
endmodule


module FourRippleFullAdder(A, B, Cin, Cout, S);
	input [3:0] A;
   input	[3:0] B;
	input	Cin;
	output Cout;
	output [3:0] S;
	wire [2:0] w;
	
	FullAdder FA0(.a(A[0]), .b(B[0]), .cin(Cin), .cout(w[0]), .s(S[0]));
	FullAdder FA1(.a(A[1]), .b(B[1]), .cin(w[0]), .cout(w[1]), .s(S[1]));
	FullAdder FA2(.a(A[2]), .b(B[2]), .cin(w[1]), .cout(w[2]), .s(S[2]));
	FullAdder FA3(.a(A[3]), .b(B[3]), .cin(w[2]), .cout(Cout), .s(S[3]));
endmodule


module FullAdder(a, b, cin, cout, s);
	input a, b, cin;
	output cout, s;
	
	assign s = a ^ b ^ cin;
	assign cout = (~(a ^ b) & b) | ((a ^ b) & cin);
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
