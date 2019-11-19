module Pillar(clk10, clr, game_over, pillar1_x, pillar2_x, pillar3_x, pillar1_y, pillar2_y, pillar3_y, score);
	input clk10, clr, game_over;
	output reg [9:0] pillar1_y, pillar2_y, pillar3_y, pillar1_x, pillar2_x, pillar3_x;
	output reg [9:0] score;
	
	initial score = 8'b0;
	initial pillar1_x = 10'd400;
	initial pillar2_x = 10'd650;
	initial pillar3_x = 10'd900;
	initial pillar1_y = 10'd240;
	initial pillar2_y = 10'd180;
	initial pillar3_y = 10'd200;
	
	wire [6:0] rand;
	reg [9:0] new_rand;
	
	Random_Generator random_generator(.clk(clk10), .out(rand));
	
	always @(posedge clk10, negedge clr) begin
		if(!clr)begin
			score <= 8'b0;
			pillar1_x <= 10'd400;
			pillar2_x <= 10'd650;
			pillar3_x <= 10'd900;
			pillar1_y <= 10'd240;
			pillar2_y <= 10'd180;
			pillar3_y <= 10'd200;
		end
		else if(!game_over) begin
			new_rand <= rand + 10'd150;
			pillar1_x <= pillar1_x - 10'd5;
			pillar2_x <= pillar2_x - 10'd5;
			pillar3_x <= pillar3_x - 10'd5;
			
			if(pillar1_x <= 10'd80) begin
				pillar1_x <= 10'd900;
				pillar1_y <= new_rand;
				score <= score + 1;
			end
			
			if(pillar2_x <= 10'd80) begin
				pillar2_x <= 10'd900;
				pillar2_y <= new_rand;
				score <= score + 1;
			end
			
			if(pillar3_x <= 10'd80) begin
				pillar3_x <= 10'd900;
				pillar3_y <= new_rand;
				score <= score + 1;
			end
		end
	end
endmodule
