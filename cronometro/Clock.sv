module Clock(
	input logic clock,
	output logic clock_dec
	//output logic clock_sec
); 

logic [26:0]cont_clock_dec;

always_ff @(posedge clock)
begin
	
	if( cont_clock_dec == 'd249999 )
	begin
		clock_dec <= ~clock_dec;
		cont_clock_dec <= 0;
	end
	else
		cont_clock_dec <= cont_clock_dec + 1'b1;

/*	if( cont_clock_sec == 'd24999999 )
	begin
		clock_sec <= ~clock_sec;
		cont_clock_sec <= 0;
	end
	else
		cont_clock_sec <= cont_clock_sec + 1'b1;*/
end


endmodule
