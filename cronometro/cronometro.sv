/*
 *	@file cronometro.sv (TOP LEVEL)
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Cronometro com segundos e centesimos
**/

module cronometro (
	input logic CLOCK_50,
	input logic  [9:0]SW,
	input logic  [3:0]KEY,
	output logic [9:0]LEDR,
	output logic [7:0]LEDG,
	output logic [6:0]HEX0,
	output logic [6:0]HEX1,
	output logic [6:0]HEX2,
	output logic [6:0]HEX3
);

logic clock_dec; // clock de 1 centesimo
logic reset;	  // reset do sistema
logic pause;	  // pause do sistema
logic [3:0]du;   // unidade centesimos
logic [3:0]dd;   // dezena centesimos
logic [3:0]su;   // unidade segundos
logic [3:0]sd;   // dezena segundos

Display disp0(.digit(du), .out(HEX0));
Display disp1(.digit(dd), .out(HEX1));
Display disp2(.digit(su), .out(HEX2));
Display disp3(.digit(sd), .out(HEX3));

Clock clk(.clock(CLOCK_50), .clock_dec(clock_dec));

Chronometer chrono( .clock(clock_dec), .pause(pause), .reset(reset), .lap(KEY[2]), .key(SW[2:0]) , .du(du), .dd(dd), .su(su), .sd(sd) );

Start str(.start(KEY[0]), .pause(pause));

always_comb
begin
	LEDR[0] <= pause;
	LEDR[1] <= reset;
	reset <= ~KEY[1];
end

endmodule
