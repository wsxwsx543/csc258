module RAMtop(SW, KEY, HEX5, HEX4, HEX2, HEX0);
	input [9:0]SW;
	input [0:0] KEY;
	input [6:0]HEX5, HEX4, HEX2, HEX0;
	
	wire [3:0]outdata;
	
	ram32x4(SW[8:4], KEY[0], SW[3:0], SW[9], outdata[3:0]);
	
	HEXdecoder d2(.data(SW[3:0]), .hex(HEX2));
	HEXdecoder d4(.data(SW[7:4]), .hex(HEX4));
	HEXdecoder d5(.data({3'b000, SW[8]}), .hex(HEX5));
	HEXdecoder d0(.data(outdata), .hex(HEX0));
endmodule

module HEXdecoder(data, hex);
	input [3:0]data;
	output reg [6:0]hex;
	
	always @(*)
		case(data)
			4'b0000: hex = 7'b100_0000;
			4'b0001: hex = 7'b111_1001;
			4'b0010: hex = 7'b010_0100;
			4'b0011: hex = 7'b011_0000;
			4'b0100: hex = 7'b001_1001;
			4'b0101: hex = 7'b001_0010;
			4'b0110: hex = 7'b000_0010;
			4'b0111: hex = 7'b111_1000;
			4'b1000: hex = 7'b000_0000;
			4'b1001: hex = 7'b001_1000;
			4'b1010: hex = 7'b000_1000;
			4'b1011: hex = 7'b000_0011;
			4'b1100: hex = 7'b100_0110;
			4'b1101: hex = 7'b010_0001;
			4'b1110: hex = 7'b000_0110;
			4'b1111: hex = 7'b000_1110;
			default: hex = 7'b111_1111;
		endcase
endmodule
