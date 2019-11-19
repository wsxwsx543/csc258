module FlappyBird(CLOCK_50, KEY, HEX2, HEX1, HEX0);
	input CLOCK_50;
	input [3:0] KEY;
	output [6:0] HEX2, HEX1, HEX0;
	
	wire [9:0] score, pillar1_x, pillar2_x, pillar3_x, pillar1_y, pillar2_y, pillar3_y;
	wire [9:0] bird_x, bird_y;
	wire clk10, game_over, clr;
	
	assign clr = KEY[1];
	
	ScoreBoard scoreBoard(.score(score), 
								 .clk(CLOCK_50), 
								 .hex2(HEX2),
								 .hex1(HEX1), 
								 .hex0(HEX0));
	Pillar pillar(.clk10(clk10), 
					  .clr(clr),
					  .game_over(game_over),
					  .pillar1_x(pillar1_x),
					  .pillar2_x(pillar2_x),
					  .pillar3_x(pillar3_x),
					  .pillar1_y(pillar1_y),
					  .pillar2_y(pillar2_y),
					  .pillar3_y(pillar3_y),
					  .score(score));
	Detect_Crash dectect_crash(.clr(clr),
										.bird_y(bird_y),
										.pillar1_x(pillar1_x),
										.pillar1_y(pillar1_y),
										.pillar2_x(pillar2_x),
										.pillar2_y(pillar2_y),
										.pillar3_x(pillar3_x),
										.pillar3_y(pillar3_y),
										.game_over(game_over));
	Draw_Bird draw_bird(.clk10(clk10),
							  .clr(clr),
							  .game_over(game_over),
							  .up(~KEY[0]),
							  .down(KEY[0]),
							  .bird_y(bird_y));
endmodule
