/*
 *	@file Start.sv
 * @author Talita Valeria
 * @date 06/12/2016
 * @brief Modulo responsavel por iniciar/pausar o cronometro
 *
**/

module Start(
	input logic start,
	output logic pause
);

always_ff @(negedge start)
	pause = ~pause;
	
endmodule
