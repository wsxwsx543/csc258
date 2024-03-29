module part3(KEY, SW, LEDR, CLOCK_50);
	input [1:0] KEY;
	input [2:0]SW;
	input CLOCK_50;
	output [9:0] LEDR;

	wire [13:0] load;
	wire en;
	LUT lut(.select(SW), .out(load));
	rateDivider rd(.clock(CLOCK_50), .start(KEY[1]), .q(en));
	shiftRegister sr(.load(load), .enable(en), .start(KEY[1]), .clock(CLOCK_50), .clear(KEY[0]), .out(LEDR[0]));
endmodule

module LUT(select, out);
	input [2:0] select;
	output reg [13:0] out;
	
	always @(*)
	begin
		case(select)
			3'b000: out = 14'b10_1010_0000_0000;
			3'b001: out = 14'b11_1000_0000_0000;
			3'b010: out = 14'b10_1011_1000_0000;
			3'b011: out = 14'b10_1010_1110_0000;
			3'b100: out = 14'b10_1110_1110_0000;
			3'b101: out = 14'b11_1010_1011_1000;
			3'b110: out = 14'b11_1010_1110_1110;
			3'b111: out = 14'b11_1011_1010_1000;
		endcase
	end
endmodule

module rateDivider(clock, start, q);
	input clock, start;
	output q;
	
	reg [24:0] out;
	
	wire [24:0] load;
	assign load = 25'd24_999_999;
	
	always @(posedge clock or negedge start)
	begin
		if (start == 1'b0)
			out <= load;
		else 
		begin
			if(out == 25'd0)
				out <= load;
			else
				out <= out - 1'b1;
		end
	end
	
	assign q = (out == 25'd0) ? 1 : 0;
endmodule

module shiftRegister(load, enable, start, clock, clear, out);
	input [13:0] load;
	input enable, clock, clear, start;
	output reg out;
	
	reg [13:0] shifter;
	
	always @(posedge clock, negedge clear, negedge start)
	begin
		if(clear == 1'b0)
		begin
			shifter <= 0;
			out <= 0;
		end
		else if(start == 1'b0)
			shifter <= load;
		else if(enable == 1'b1)
		begin
			out <= shifter[13];
			shifter = shifter << 1'b1;
		end
	end
endmodule
