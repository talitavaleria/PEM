/*
 *	@file cronometro.sv
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Cronometro com segundos e centesimos
 *
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

logic clock_sec, clock_dec, reset, pause, flag;
logic [26:0]cont_clock_sec;
logic [26:0]cont_clock_dec;
logic [5:0]cont_sec;
logic [6:0]cont_dec;
logic [5:0]saved_cont_sec;
logic [6:0]saved_cont_dec;
logic [3:0]du;
logic [3:0]dd;
logic [3:0]su;
logic [3:0]sd;
logic [10:0]save_cont[2:0];
logic [1:0]save_pos; 

Display disp0(.digit(du), .out(HEX0));
Display disp1(.digit(dd), .out(HEX1));
Display disp2(.digit(su), .out(HEX2));
Display disp3(.digit(sd), .out(HEX3));

always_ff @(negedge KEY[0])
	pause <= ~pause;

always_ff @(negedge KEY[2])
begin
		
	save_cont[save_pos][6:0] <= cont_dec;
	save_cont[save_pos][10:7] <= cont_sec;
	
	if(save_pos == 2'd2)
		save_pos <= 2'd0;
	else save_pos <= save_pos + 2'd1;

end	
	
always_comb
begin
	LEDR[0] <= pause;
	LEDR[1] <= reset;
	LEDR[2] <= flag;
	reset <= ~KEY[1];
end
	
always_ff @(posedge CLOCK_50)
begin
	
	if( cont_clock_dec == 'd249999 )
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
		cont_sec = 'd0;
		cont_dec = 'd0;
	end

	if(pause == 1'b1)
	begin
		if(flag == 1'b1)
		begin
			cont_sec = saved_cont_sec;
			cont_dec = saved_cont_dec;
			flag <= 1'b0;
		end
		if( cont_sec == 'd59 )
			cont_sec = 'd0;
			
		if( cont_dec == 'd99 )
		begin
			cont_dec = 'd0;
			cont_sec = cont_sec + 1'b1;
		end
		else
			cont_dec = cont_dec + 1'b1;
			
		saved_cont_dec = cont_dec;
		saved_cont_sec = cont_sec;
	end
	else
	begin
		
		if(SW[0] == 1'b1)
		begin	
			cont_dec = save_cont[0][6:0];
			cont_sec = save_cont[0][10:7];
			flag = 1'b1;
		end
		else if(SW[1] == 1'b1)
		begin	
			cont_dec = save_cont[1][6:0];
			cont_sec = save_cont[1][10:7];
			flag = 1'b1;
		end
		else if(SW[2] == 1'b1)
		begin	
			cont_dec = save_cont[2][6:0];
			cont_sec = save_cont[2][10:7];
			flag = 1'b1;
		end
	
	end
	
	du <= cont_dec % 6'd10;
	dd <= cont_dec / 6'd10;
	su <= cont_sec % 5'd10;
	sd <= cont_sec / 5'd10;
	
end

endmodule
