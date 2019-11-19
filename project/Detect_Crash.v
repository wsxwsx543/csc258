module Detect_Crash(
		input clr,
		input [9:0] bird_y,
		input [9:0] pillar1_x,
		input [9:0] pillar1_y,
		input [9:0] pillar2_x,
		input [9:0] pillar2_y,
		input [9:0] pillar3_x,
		input [9:0] pillar3_y,
		output game_over
		);
		
			wire crash;
			// Set the x position of the bird
			wire [9:0] bird_x;
			assign bird_x = 10'd80;
			//Detecting if the bird crash on the pillar or on the boundary or neither
			assign check_crash = (
						(((bird_y + 10'd6 >= pillar1_y + 10'd35) | (bird_y - 10'd6 >= pillar1_y - 10'd35)) &
							((bird_x + 10'd15 >= pillar1_x - 10'd30) & (bird_x - 10'd15 <= pillar1_x + 10'd30))) |
						(((bird_y + 10'd6 >= pillar2_y + 10'd35) | (bird_y - 10'd6 >= pillar2_y - 10'd35)) &
							((bird_x + 10'd15 >= pillar2_x - 10'd30) & (bird_x - 10'd15 <= pillar2_x + 10'd30))) |
						(((bird_y + 10'd6 >= pillar3_y + 10'd35) | (bird_y - 10'd6 >= pillar3_y - 10'd35)) &
							((bird_x + 10'd15 >= pillar3_x - 10'd30) & (bird_x - 10'd15 <= pillar3_x + 10'd30))) |
						(bird_y + 10'd6 >= 10'd480) | (bird_y - 10'd6 <= 10'd0)
						);
			
			//if the bird is crashed, then the game is end
			assign game_over =
						(!clr) ? 0:
						(check_crash) ? 1:
						0;
endmodule
