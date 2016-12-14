/*
 *	@file Start.sv
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Modulo responsavel por gerar o clock para o sistema (1 centesimos de segundo)
 *
**/
module Clock(
	input logic clock,
	output logic clock_dec
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
end


endmodule
