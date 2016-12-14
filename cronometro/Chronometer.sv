/*
 *	@file Start.sv
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Modulo responsavel pela operacao do cronometro
 *
**/

module Chronometer(
	input logic clock,
	input logic pause,
	input logic reset,
	input logic lap,
	input logic [2:0]key,
	output logic [3:0]du,
	output logic [3:0]dd,
	output logic [3:0]su,
	output logic [3:0]sd
);

logic flag;
logic [5:0]cont_sec;
logic [6:0]cont_dec;
logic [5:0]saved_cont_sec;
logic [6:0]saved_cont_dec;
logic [1:0]save_pos;
logic [10:0]save_cont[2:0];

always_ff @(posedge clock)
begin
	
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
		if (reset == 1'b1)
		begin
			cont_sec = 'd0;
			cont_dec = 'd0;
			saved_cont_sec = 'd0;
			saved_cont_dec = 'd0;
			flag = 1'b0;
		end
		
		if(key[0] == 1'b1)
		begin	
			cont_dec = save_cont[0][6:0];
			cont_sec = save_cont[0][10:7];
			flag = 1'b1;
		end
		else if(key[1] == 1'b1)
		begin	
			cont_dec = save_cont[1][6:0];
			cont_sec = save_cont[1][10:7];
			flag = 1'b1;
		end
		else if(key[2] == 1'b1)
		begin	
			cont_dec = save_cont[2][6:0];
			cont_sec = save_cont[2][10:7];
			flag = 1'b1;
		end
		else if(flag == 1'b1)
		begin
			cont_sec = saved_cont_sec;
			cont_dec = saved_cont_dec;
		end
	end
	
	du <= cont_dec % 6'd10;
	dd <= cont_dec / 6'd10;
	su <= cont_sec % 5'd10;
	sd <= cont_sec / 5'd10;
	
end

always_ff @(negedge lap)
begin
		
	save_cont[save_pos][6:0] <= cont_dec;
	save_cont[save_pos][10:7] <= cont_sec;
	
	if(save_pos == 2'd2)
		save_pos <= 2'd0;
	else save_pos <= save_pos + 2'd1;

end


endmodule
