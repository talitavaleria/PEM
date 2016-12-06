/*
 *	@file cronometro.sv
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Cronometro com segundos e decimos
 *
**/

module cronometro (
	input logic CLOCK_50,
	input logic  [9:0]SW,
	input logic  [3:0]KEY,
	output logic [9:0]LEDR,
	output logic [6:0]HEX0,
	output logic [6:0]HEX1,
	output logic [6:0]HEX2,
	output logic [6:0]HEX3
);

logic clock_sec, clock_dec, reset, pause;
logic [26:0]cont_clock_sec;
logic [26:0]cont_clock_dec;
logic [5:0]cont_sec;
logic [5:0]cont_dec;
logic [3:0]du;
logic [3:0]dd;
logic [3:0]su;
logic [3:0]sd;

always_ff @(negedge KEY[0])
	pause <= ~pause;

always_comb
begin
	LEDR[0] <= pause;
	LEDR[1] <= reset;
	reset <= ~KEY[1];
end
	
always_ff @(posedge CLOCK_50)
begin
	
	if( cont_clock_dec == 'd416667 )
	begin
		clock_dec <= ~clock_dec;
		cont_clock_dec <= 0;
	end
	else
		cont_clock_dec <= cont_clock_dec + 1'b1;

	if( cont_clock_sec == 'd24999999 )
	begin
		clock_sec <= ~clock_sec;
		cont_clock_sec <= 0;
	end
	else
		cont_clock_sec <= cont_clock_sec + 1'b1;
end

always_ff @(posedge clock_dec)
begin
	if (reset == 1'b1)
	begin
		cont_sec <= 'd0;
		cont_dec <= 'd0;
	end
	
	if (pause == 1'b0)
	begin
		if( cont_sec == 'd59 )
			cont_sec <= 'd0;
			
		if( cont_dec == 'd59 )
		begin
			cont_dec <= 'd0;
			cont_sec <= cont_sec + 1'b1;
		end
		else
			cont_dec <= cont_dec + 1'b1;
	end

	du <= cont_dec % 5'd10;
	dd <= cont_dec / 5'd10;
	
	case(du)
		4'd0: HEX0 <= 7'b1000000;
		4'd1: HEX0 <= 7'b1111001;
		4'd2: HEX0 <= 7'b0100100;
		4'd3: HEX0 <= 7'b0110000;
		4'd4: HEX0 <= 7'b0011001;
		4'd5: HEX0 <= 7'b0010010;
		4'd6: HEX0 <= 7'b0000010;
		4'd7: HEX0 <= 7'b1111000;
		4'd8: HEX0 <= 7'b0000000;
		4'd9: HEX0 <= 7'b0010000;
		default: HEX0 <= 7'b1000000;
	endcase
	
	case(dd)
		4'd0: HEX1 <= 7'b1000000;
		4'd1: HEX1 <= 7'b1111001;
		4'd2: HEX1 <= 7'b0100100;
		4'd3: HEX1 <= 7'b0110000;
		4'd4: HEX1 <= 7'b0011001;
		4'd5: HEX1 <= 7'b0010010;
		4'd6: HEX1 <= 7'b0000010;
		4'd7: HEX1 <= 7'b1111000;
		4'd8: HEX1 <= 7'b0000000;
		4'd9: HEX1 <= 7'b0010000;
		default: HEX1 <= 7'b1000000;
	endcase
	
	su <= cont_sec % 5'd10;
	sd <= cont_sec / 5'd10;
	
	case(su)
		4'd0: HEX2 <= 7'b1000000;
		4'd1: HEX2 <= 7'b1111001;
		4'd2: HEX2 <= 7'b0100100;
		4'd3: HEX2 <= 7'b0110000;
		4'd4: HEX2 <= 7'b0011001;
		4'd5: HEX2 <= 7'b0010010;
		4'd6: HEX2 <= 7'b0000010;
		4'd7: HEX2 <= 7'b1111000;
		4'd8: HEX2 <= 7'b0000000;
		4'd9: HEX2 <= 7'b0010000;
		default: HEX2 <= 7'b1000000;
	endcase
	
	case(sd)
		4'd0: HEX3 <= 7'b1000000;
		4'd1: HEX3 <= 7'b1111001;
		4'd2: HEX3 <= 7'b0100100;
		4'd3: HEX3 <= 7'b0110000;
		4'd4: HEX3 <= 7'b0011001;
		4'd5: HEX3 <= 7'b0010010;
		4'd6: HEX3 <= 7'b0000010;
		4'd7: HEX3 <= 7'b1111000;
		4'd8: HEX3 <= 7'b0000000;
		4'd9: HEX3 <= 7'b0010000;
		default: HEX3 <= 7'b1000000;
	endcase
end

endmodule
