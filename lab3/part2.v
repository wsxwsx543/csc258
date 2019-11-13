module part2(LEDR, SW);
	input [9:0] SW;
	output [9:0] LEDR;
	
	FourRippleCarryAdder frca(.A(SW[7:4]), .B(SW[3:0]), .Cin(SW[8]), .S(LEDR[3:0]), .Cout(LEDR[4]));
endmodule


module FourRippleCarryAdder(A, B, Cin, S, Cout);
	input [3:0] A;
	input [3:0] B;
	input Cin;
	
	output [3:0] S;
	output Cout;
	
	wire [2:0] w;
	
	FullAdder FA0(.b(B[0]), .a(A[0]), .cin(Cin), .cout(w[0]), .out(S[0]));
	FullAdder FA1(.b(B[1]), .a(A[1]), .cin(w[0]), .cout(w[1]), .out(S[1]));
	FullAdder FA2(.b(B[2]), .a(A[2]), .cin(w[1]), .cout(w[2]), .out(S[2]));
	FullAdder FA3(.b(B[3]), .a(A[3]), .cin(w[2]), .cout(Cout), .out(S[3]));
endmodule


module FullAdder(b, a, cin, cout, out);
	input b, a, cin;
	output cout, out;
	
	assign cout = (b & ~(a ^ b)) | (cin & (a ^ b));
	assign out = b ^ a ^ cin;
endmodule
