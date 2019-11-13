// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
	wire ldx, ldy, ldclr, en;
	
	control c(.clk(CLOCK50), .resetn(KEY[0]), .go1(KEY[3]), .go2(KEY[1]), .ldx(ldx), .ldy(ldy), .ldclr(ldclr), .en(en), .wren(writeEn));
	datapath dp(.ldx(ldx), .ldy(ldy), .ldclr(ldclr), .clk(CLOCK50), .data(SW[6:0]), .clr(SW[9:7]), .en(en), .resetn(KEY[0]), .xout(x), .yout(y), .clrout(colour));

endmodule

module datapath(ldx, ldy, ldclr, clk, data, clr, en, resetn, 
					 xout, yout,clrout);
	input ldx, ldy, ldclr, clk, resetn, en;
	input [6:0] data;
	input [2:0] clr;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] clr_reg;
	reg counterResetn; 
	
	output [7:0] xout;
	output [6:0] yout;
	output [2:0] clrout;
	
	wire [3:0] addXY;
	
	always @(posedge clk, negedge resetn) begin
		if(resetn == 1'b0) begin
			x <= 8'd0;
			y <= 7'd0;
			clr_reg <= 3'd0;
			
			counterResetn <= 1'b0;
		end
		
		else begin
			if(ldx) begin
				x <= {1'b0, data};
				counterResetn <= 1'b0;
			end
			else if(ldy) begin
				y <= data;
			end
			else if(ldclr) begin
				clr_reg <= clr;
				counterResetn <= 1'b1;
			end
		end
	end
	
	FourBitCounter c(.en(en), .resetn(counterResetn), .clk(clk), .out(addXY));
	assign xout = x + addXY[1:0];
	assign yout = y + addXY[3:2];
	assign clrout = clr_reg;
endmodule


module control(clk, resetn, go1, go2, ldx, ldy, ldclr, en, wren);
	input clk, resetn, go1, go2;
	output reg ldx, ldy, ldclr, en, wren;
	
	reg [3:0] cur_state, next_state;
	reg counter_en, counter_resetn;
	
	wire [3:0] counter_out;
	
	localparam S_LOAD_X 			= 3'd0,
				  S_LOAD_X_WAIT	= 3'd1,
				  S_LOAD_Y			= 3'd2,
				  S_LOAD_Y_WAIT	= 3'd3,
				  S_LOAD_CLR		= 3'd4,
				  DRAW				= 3'd5;
				  
	always @(*)
	begin: state_table
		case(cur_state)
			S_LOAD_X: next_state = go1 ? S_LOAD_X : S_LOAD_X_WAIT;
			S_LOAD_X_WAIT: next_state = go1 ? S_LOAD_Y : S_LOAD_X_WAIT;
			S_LOAD_Y: next_state = go2 ? S_LOAD_Y : S_LOAD_Y_WAIT;
			S_LOAD_Y_WAIT: next_state = go2 ? S_LOAD_CLR : S_LOAD_Y_WAIT;
			S_LOAD_CLR: next_state = DRAW;
			DRAW: next_state = S_LOAD_X;
			default: begin
				next_state = S_LOAD_X;
				// cur_state = S_LOAD_X;
			end
		endcase
	end
	
	always @(*)
	begin: enable_signals
		ldx = 0;
		ldy = 0;
		ldclr = 0;
		en = 0;
		wren = 0;
		
		case(cur_state)
			S_LOAD_X: begin
				ldx = 1;
				ldy = 0;
				ldclr = 0;
				en = 0;
				wren = 0;
			end
			S_LOAD_Y: begin
				ldx = 0;
				ldy = 1;
				ldclr = 0;
				en = 0;
				wren = 0;
			end
			S_LOAD_CLR: begin
				ldx = 0;
				ldy = 0;
				ldclr = 1;
				en = 0;
				wren = 0;
			end
			DRAW: begin
				ldx = 0;
				ldy = 0;
				ldclr = 0;
				en = 1;
				wren = 1;
			end
		endcase
	end
	
	DelayCounter c(.en(counter_en), .resetn(counter_resetn), .clk(clk), .out(counter_out));
	
	always @(posedge clk, negedge resetn) begin
		if(resetn == 1'b0) begin
			cur_state <= S_LOAD_X;
			counter_en <= 0;
			counter_resetn <= 0;
		end
		else begin
			if(cur_state != DRAW) begin
				counter_en <= 0;
				counter_resetn <= 0;
				cur_state <= next_state;
			end
			else begin
				counter_en <= 1;
				counter_resetn <= 1;
				cur_state <= (counter_out == 4'b0000) ? next_state : cur_state;
			end
		end
	end
endmodule

module test(clk, resetn, go1, go2, data, clr, wren, xout, yout, clrout);
	input clk, resetn, go1, go2;
	input [6:0] data;
	input [2:0] clr;
	output wren;
	output [7:0] xout;
	output [6:0] yout;
	output [2:0] clrout;
	
	wire ldx, ldy, ldclr, en;
	
	control c(.clk(clk), .resetn(resetn), .go1(go1), .go2(go2), .ldx(ldx), .ldy(ldy), .ldclr(ldclr), .en(en), .wren(wren));
	datapath dp(.ldx(ldx), .ldy(ldy), .ldclr(ldclr), .clk(clk), .data(data), .clr(clr), .en(en), .resetn(resetn), .xout(xout), .yout(yout), .clrout(clrout));
endmodule


module FourBitCounter(en, resetn, clk, out);
	input en, resetn, clk;
	output reg [3:0] out;
	
	always @(posedge clk) begin
		if(resetn == 1'b0) begin
			out <= 4'b0000;
		end
		else begin
			if(en == 1'b1) begin
				if(out == 4'b1111)
					out <= 4'b0000;
				else begin
					out <= out + 4'b0001;
				end
			end
		end
	end
endmodule

module DelayCounter(en, resetn, clk, out);
	input en, resetn, clk;
	output reg [3:0] out;
	
	always @(posedge clk) begin
		if(!resetn)
			out <= 4'b1111;
		else if(en) begin
			if(out == 4'b0000)
				out <= 4'b1111;
			else
				out <= out - 1'b1;
		end
	end
endmodule
