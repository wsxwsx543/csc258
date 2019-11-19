module Draw_Bird(
    input clk10,
    input clr,
	 input game_over,
    input up,
	 input down,
    output reg [9:0] bird_y
    );
	
	// set the initial position of the bird while the game start
	 initial bird_y = 10'd90;
	 
	 always @ (posedge clk10, negedge clr) 
	 begin
		//reset
		if (!clr)
			bird_y <= 10'd90;
		//while the game is still going on
		else if (~game_over)
		 begin
			if ((up == 1) && (bird_y >= 10'd15))
				bird_y <= bird_y - 10'd6;
			if ((down == 1) && (bird_y <= 10'd465))
				bird_y <= bird_y + 10'd6;
		end
	 end
endmodule
