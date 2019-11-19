module ScoreBoard(score, clk, hex2, hex1, hex0);
	input [9:0] score;
	input clk;
	output [6:0] hex2, hex1, hex0;
	
	reg [3:0] digit0;
	reg [3:0] digit1;
	reg [3:0] digit2;
	
	always @(posedge clk)
	begin
		digit2 <= score / 8'd100;
		digit1 <= (score / 4'd10) % 10;
		digit0 <= (score % 10);
	end
	
	DecDecoder d2(.digit(digit2), .out(hex2));
	DecDecoder d1(.digit(digit1), .out(hex1));
	DecDecoder d0(.digit(digit0), .out(hex0));
endmodule


module DecDecoder(digit, out);
	input [3:0] digit;
	output reg [6:0] out;
	
	always @(*)
	begin
		case(digit)
            4'd0: out = 7'b100_0000;
            4'd1: out = 7'b111_1001;
            4'd2: out = 7'b010_0100;
            4'd3: out = 7'b011_0000;
            4'd4: out = 7'b001_1001;
            4'd5: out = 7'b001_0010;
            4'd6: out = 7'b000_0010;
            4'd7: out = 7'b111_1000;
            4'd8: out = 7'b000_0000;
            4'd9: out = 7'b001_1000;
				default: out = 7'b1;
		endcase
	end
endmodule
