module Random_Generator(
		input clk,
		output reg [6:0] out
);
		reg [20:0] random;
		initial random = ~(20'b0);
		reg [20:0] next_random;
		wire link1;
		wire link2;
		
		//using XOR shift to produce random generator
		assign link1 = random[20] ^ random[10];
		assign link2 = random[0] ^ random[5];
		
		always @ (posedge clk)
	 begin
		random <= next_random;
		out = random[6:0];
	 end
	 
	 always @ (*)
	 begin
		next_random = {random[18:0], link1, link2};
	 end
endmodule 